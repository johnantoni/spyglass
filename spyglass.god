app_name 		= "spyglass"
rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/web/sku.red91.com"
num_workers = rails_env == 'production' ? 1 : 1

num_workers.times do |num|
  God.watch do |w|
    w.dir      = "#{rails_root}"
    w.name     = "#{app_name}-#{num}"
    w.group    = '#{app_name}'
    w.interval = 30.seconds
    w.env      = {"QUEUE"=>"*", "RAILS_ENV"=>rails_env}
    w.start    = "/usr/local/bin/rake -f #{rails_root}/Rakefile environment resque:work"
    w.log      = "/var/log/god/#{w.name}.log"

    w.uid = 'local'
    w.gid = 'local'

    # retart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end
