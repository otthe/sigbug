## Allows you to:
1) Bind the logger to your program and log the stack trace when spesified signal is met. <b>For example:</b>
```ruby
require_relative '../sigbug'

SIGBug.install("SIGURG")

# *** EXAMPLE OUTPUT ON RUNTIME: ***

# [2025-05-19 17:26:56] SIGURG received in PID 25307
# Thread 2020 (run):
# /home/dev/Desktop/ruby_debug/sigbug.rb:14:in `backtrace'
# /home/dev/Desktop/ruby_debug/sigbug.rb:14:in `block in log_thread_backtraces'
# /home/dev/Desktop/ruby_debug/sigbug.rb:12:in `each'
# /home/dev/Desktop/ruby_debug/sigbug.rb:12:in `log_thread_backtraces'
# /home/dev/Desktop/ruby_debug/sigbug.rb:4:in `block in install'
# /home/dev/.rbenv/versions/3.3.0/lib/ruby/gems/3.3.0/gems/debug-1.10.0/lib/debug/server.rb:264:in `block in setup_interrupt'
# /home/dev/.rbenv/versions/3.3.0/lib/ruby/gems/3.3.0/gems/puma-6.4.2/lib/puma/single.rb:63:in `join'
# /home/dev/.rbenv/versions/3.3.0/lib/ruby/gems/3.3.0/gems/puma-6.4.2/lib/puma/single.rb:63:in `run'
# /home/dev/.rbenv/versions/3.3.0/lib/ruby/gems/3.3.0/gems/puma-6.4.2/lib/puma/launcher.rb:194:in `run'
```

2) Use `strace` -wrapper method to listen any incoming signals on `pid_or_name` for `duration` seconds on out of context process. <b>For example:</b>
```ruby
SIGBug.trace_signals("puma") # process by name
SIGBug.trace_signals(25307, 10)  # pid and duration
```

## Why?
Makes it easier to debug faulty behaviour, that might be related to unhandled or wrongly handled signals when doing IPC.

## Linux manpage for Signal-spesific explanations
https://man7.org/linux/man-pages/man7/signal.7.html