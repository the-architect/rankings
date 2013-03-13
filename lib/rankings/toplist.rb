module Rankings
  class Toplist
    class << self

      def top(count=10, type=:all)
        if type == :all
          types.inject({}) do |akk, t|
            akk[t] = get_toplist_for_type(count, t.to_s)
            akk
          end
        else
          get_toplist_for_type(count, type.to_s)
        end
      end

      def get_toplist_for_type(count, type)
        return nil unless count > 0 && types.include?(type.to_s)

        redis.zrevrange(['toplist', type].join('::'), 0, count).map do |id|
          Rankings::User.find(id)
        end
      end

      def types
        ::Rankings::User::TYPES
      end

      def redis
        ::Rankings::Config.redis
      end

    end
  end
end