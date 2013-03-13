require_relative 'rankings/version'
require_relative 'rankings/config'
require_relative 'rankings/user'
require_relative 'rankings/toplist'
require_relative 'rankings/api'

# default config
Rankings::Config.redis = Redis::Namespace.new('rankings', :redis => Redis.new)