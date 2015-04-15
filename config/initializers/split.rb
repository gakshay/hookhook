Split.configure do |config|
  config.db_failover = true # handle redis errors gracefully
  config.db_failover_on_db_error = proc{|error| Rails.logger.error(error.message) }
  config.enabled = !Rails.env.test?
  config.experiments = YAML.load_file "config/ab_experiments.yml"
end


Split::Dashboard.use Rack::Auth::Basic do |username, password|
  username == 'maalik' && password == 'baap'
end

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV['REDISTOGO_URL'])
  namespace = ['split', 'request.to', Rails.env].join(':')

  redis = Redis.new(host: uri.host,
                    port: uri.port,
                    password: uri.password,
                    thread_safe: true
  )

  redis_namespace = Redis::Namespace.new(namespace, redis: redis)

  Split.redis = redis_namespace
else
  Split.redis = ENV['REDISTOGO_URL'] || 'redis://localhost:6379'
end
# Split.redis = ENV['REDISTOGO_URL'] || 'redis://localhost:6379'
# Split.redis.namespace = "split:trajectory"