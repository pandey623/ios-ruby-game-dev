require 'readline'

def restart
  result = IO.popen('rake device', 'w')
  result.puts 'do_live_reload'
  result
end

ios_io = restart
first_time = true

Signal.trap('SIGUSR1') do
  if first_time
    first_time = false
  else
    repl_pid = `pgrep repl`
    Process.kill('INT', repl_pid.to_i)
    ios_io.close
    ios_io = restart
  end
end

`echo rerun \\"kill -30 #{Process.pid}\\" --no-notify | pbcopy`

Readline.readline('Press any key to exit..', true)
