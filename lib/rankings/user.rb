require 'json'
require 'redis'
require 'redis-namespace'

module Rankings
  class User

    TYPES = %w{overall xp honor might}

    def initialize(id, name = nil, scores = {})
      @id       = id

      persisted = self.class.load_data(@id) || {}

      @scores   = (persisted['scores'] || {}).merge(scores)
      @name     = name || persisted['name']

      # setup types
      TYPES.each do |t|
        @scores[t.to_s] ||= 0
      end
    end

    attr_accessor :scores
    attr_accessor :name

    def save
      # first save instance
      if redis.set(redis_id(@id), to_json)
        redis.pipelined do
          # update sorted sets
          TYPES.each do |t|
            redis.zadd(['toplist', t].join('::'), @scores[t.to_s] || 0, @id)
          end
        end
      end
    end

    def add(type, points)
      @scores[type.to_s] += points
      save
    end

    def deduct(type, points)
      @scores[type.to_s] -= points
      save
    end

    protected

    def redis
      self.class.redis
    end

    def redis_id(id)
      self.class.store_id(id)
    end

    def to_json
      JSON.dump({
        'name'    => @name,
        'scores'  => @scores
      })
    end


    class << self

      def exists?(id)
        redis.exists(store_id(id))
      end

      def find(id)
        exists?(id) ? new(id) : nil
      end

      def create(id, name, scores = {})
        return nil if exists?(id)

        user = new(id, name, scores)
        user.save
        user
      end

      def load_data(id)
        data = redis.get(store_id(id))
        data = JSON.parse(data) if data
        valid?(data) ? data : nil
      end

      def valid?(data)
        data && data.key?('scores') && data.key?('name')
      end

      def redis
        ::Rankings::Config.redis
      end

      def store_id(id)
        'User::%s' % id
      end
    end
  end
end