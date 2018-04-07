require 'tty-spinner'
require 'pastel'


pastel = Pastel.new

format = "[#{pastel.red(':spinner')}] " + pastel.yellow("Task name")
spinner = TTY::Spinner.new(format, success_mark: pastel.green('+'), hide_cursor: true)
10.times do
  spinner.spin
  sleep(0.1)
end
spinner.success(pastel.green("(successful)"))


spinner = TTY::Spinner.new("[:spinner] Task name")
20.times do
  spinner.spin
  sleep(0.1)
end

spinner.error('(error)')
