ENV["REDISTOGO_URL"] ||= "redis://johnantoni:4478229e5c7155168f958e011767f1b1@pike.redistogo.com:9248/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
