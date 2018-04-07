# Exercise 6 - Hard
# Create a coffee machine app.
# - At the start of the app, make a variable to track the cost of the coffee the user is requesting.
# - Greet the user, and present them with a series of coffee product options.
# - When going through the series of coffee options, increase the cost of their coffee depending on which options they select.
# --- eg. sizes - small = .50, medium = 1.00, large = 1.50
# --- eg. flavours - mocha = 1.00, vanilla = 2.00
# --- eg. sugar - yes = .5, no = 0.00
# - When they have finished choosing all their relevant options, present the final price of the coffee.
# HINT: Use switch cases and if/else statements. Good habit is to use cases for larger groups of options, and if/else for smaller groups of options. Make sure you have a mix of both.

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
