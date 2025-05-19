require 'open3'

module SIGBug
  # bind this to ruby program execution task.
  # !!! if the program requires multiple worker processes, you have to bind this to every single one of them explicitly
  def self.install(sig = "SIGURG")
    original = Signal.trap(sig) do
      begin
        log_thread_backtraces(sig)
      rescue => e
        File.open("sig_error.log", "a") do |f|
          f.puts "[#{Time.now}] exception in #{sig} trap: #{e.class} - #{e.message}"
          f.puts e.backtrace.join("\n")
        end
      ensure
        original.call if original.respond_to?(:call)
      end
    end
  end  

  def self.log_thread_backtraces(sig)
    timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    puts "[#{timestamp}] #{sig} received in PID #{Process.pid}"
    Thread.list.each do |t|
      puts "Thread #{t.object_id} (#{t.status}):"
      puts t.backtrace&.join("\n") || "<no backtrace>"
      puts "-" * 40
    end
  end

  # use this independently to trace processes outside of context
  def self.trace_signals(target, duration = 5)
    pid = resolve_pid(target)

    unless pid
      puts "!** could not resolve PID for: #{target}"
      return
    end

    puts "!** tracing signals for PID #{pid} using strace (#{duration}s)..."

    cmd = [
      "sudo",
      "timeout", duration.to_s,
      "strace", "-e", "trace=signal",
      "-p", pid.to_s
    ]

    begin
      Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thr|
        stderr.each { |line| puts "[strace] #{line}" }
      end
    rescue => e
      puts "[!] Error running strace: #{e.message}"
    end
  end

  def self.resolve_pid(target)
    return target.to_i if target.to_s =~ /^\d+$/
    pid = `pgrep -f #{target}`.lines.first #try to grep the pid by name if its not a pid already
    pid&.strip&.to_i
  end
end