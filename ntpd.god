God.watch do |w|
  w.name = 'ntpd'
  w.start = "/etc/init.d/ntpd start"
  w.stop = "/etc/init.d/ntpd stop"
  w.restart = "/etc/init.d/ntpd restart"
  w.interval = 30.seconds
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = '/var/run/ntpd.pid'
  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end

  # lifecycle
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end
