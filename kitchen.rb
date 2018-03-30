require 'rainbow'
require 'command_line_reporter'
require 'progress_bar'
require 'io/console'
system ('clear') or system ('cls')

def bar

  bar = ProgressBar.new(100, :percentage)

100.times do
  sleep 0.01
  bar.increment!
  end
end

def testing

puts "Hi, Welcome To The Kitchen Application"
sleep(0.5)
system('clear')
puts Rainbow("We Need You To Register Before We Can Let You Use This App").bg(:red)
sleep(0.5)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@full_name = []
@stored_password = []

puts "Please Enter Your First Name"
@first_name = gets.chomp.capitalize

puts "Please Enter Your Last Name"
@last_name = gets.chomp.capitalize

puts Rainbow("Please Enter Your New Password
Password Will Be Invisble").cyan
@password = STDIN.noecho(&:gets).chomp

@full_name << [@first_name, @last_name]
@stored_password << [@password]
sleep(1)

puts "Welcome #{@first_name} #{@last_name}"
sleep(0.5)

exit_menu = true
while exit_menu
puts Rainbow("We Need To Verify Your Password Again").bg(:red)
if STDIN.noecho(&:gets).chomp == @password
  puts "Loading . . ."
  bar = ProgressBar.new(100, :percentage)

100.times do
  sleep 0.01
  bar.increment!
end
  puts " Password Matched and Saved"
  exit_menu = false
else
  puts "Password Does Not Match!"
end
end
end

class Testing
  include CommandLineReporter

def run

header title: 'Arthurs Hell Kitchen', align: 'center', width: 50, color: 'red', bold: true, timestamp: true

  table(border: true) do
    row color: 'white' do
      column('Food', width: 30, color: 'white', align: 'center')

      column('Price', width: 10, color: 'white', align: 'center')

    end # def
    row do # row 1
    column('1.Pho', color: 'cyan')
    column('$10', color: 'yellow')
    end
    row do # row 2
    column('2.Ban Xiao', color: 'cyan')
    column('$12', color: 'yellow')
    end
    row do # row 3
      column('3.Vietnamese Springs Rolls', color: 'cyan')
      column('$14', color: 'yellow')
    end
    row do
    column('4.Pork Roll', color: 'cyan')
    column('$52', color: 'yellow')
    end
    row do
    column('Exit Application', color: 'white')
    column('Press B', color: 'white')
    end
    row do
    column('Print Receipt', color: 'white')
    column('Press P', color: 'white')
    end
end # do
end # do
end # class


def option
puts Rainbow("this is red").red + " and " + Rainbow("this on yellow bg").bg(:red) + " and " + Rainbow("even bright underlined!").underline.bright
end

# - - - - - - - - - - - - - - - - - - - -
def added
    puts Rainbow(" Meal Has Been Added").white
end

  FOOD = { :pho => 0, :ban_xiao => 0, :vietnamese_spring_rolls => 0, :pork_roll => 0 }

  # total = { :pho1 => 0, :ban_xiao1 => 0, :vietnamese_spring_rolls1 => 0, :pork_roll1 => 0 }

def welcome
  sum = 0
  puts Rainbow("Welcome To Arthur's Hell Kithen").red
  sleep(0.5)
  exit_menu = true
  while exit_menu
  puts Rainbow("Please Enter The Food Number").white
  sleep(0.5)
  puts Rainbow("Press E To Exit Application").bg(:brown)
  sleep(0.5)
  print "Add Item Number: "
  item = gets.chomp.capitalize
  if item == "1" || item == "Pho"
    sum1 = 0
    print "Quantity: "
    quantity = gets.to_i
    FOOD[:pho] += quantity
    sum1 = 10 * quantity
    sum += 10 * quantity
    puts "Ordered #{FOOD[:pho]} Pho's for Total of #{sum1}"
    # total[:pho1] += 10
    sleep(0.5)
    bar
    sleep(0.5)
    added
  elsif item == "2" || item == "Ban xiao"
    sum1 = 0
    print "Quantity: "
    quantity = gets.to_i
    FOOD[:ban_xiao] += quantity
    sum1 = 12 * quantity
    sum += 12 * quantity
    puts "Ordered #{FOOD[:ban_xiao]} Ban Xiao's for Total of #{sum1}"
    # total[:ban_xiao1] += 12
    # FOOD[:ban_xiao] += 1
    sleep(0.5)
    bar
    sleep(0.5)
    added
  elsif item == "3" || item == "Vietnamese spring rolls"
    sum1 = 0
    print "Quantity: "
    quantity = gets.to_i
    FOOD[:vietnamese_spring_rolls] += quantity
    sum1 = 14 * quantity
    sum += 14 * quantity
    puts "Ordered #{FOOD[:vietnamese_spring_rolls]} Spring Rolls for Total of #{sum1}"
    # total[:vietnamese_spring_rolls1] += 14
    # FOOD[:vietnamese_spring_rolls] += 1
    sleep(0.5)
    bar
    sleep(0.5)
    added
  elsif item == "4" || item == "Pork roll"
    sum1 = 0
    print "Quantity: "
    quantity = gets.to_i
    FOOD[:pork_roll] += quantity
    sum1 = 52 * quantity
    sum += 52 * quantity
    puts "Ordered #{FOOD[:pork_roll]} Pork Rolls for Total of #{sum1}"
    # total[:pork_roll1] += 52
    # FOOD[:pork_roll] += 1
    sleep(0.5)
    bar
    sleep(0.5)
    added
  elsif item == "E"
    system ('clear') or system ('cls')
    exit_menu = false
  elsif item == "P"
    sleep(1)
    puts Rainbow("Printing . .").white
    bar = ProgressBar.new(100, :counter, :bar)

  100.times do
    sleep 0.01
    bar.increment!
  end
    sleep(0.5)
    puts "You Bought #{FOOD[:pho]} Pho" if FOOD[:pho] != 0 # remember dis
    sleep(0.5)
    puts "You Bought #{FOOD[:ban_xiao]} Ban Xiao" if FOOD[:ban_xiao] != 0 # not equal
    sleep(0.5)
    puts "You Bought #{FOOD[:vietnamese_spring_rolls]} Vietnamese Spring Rolls" if FOOD[:vietnamese_spring_rolls] != 0
    sleep(0.5)
    puts "You Bought #{FOOD[:pork_roll]} Pork Rolls" if FOOD[:pork_roll] != 0
    sleep(0.5)
    puts "Costing a Total Of $#{"%.2f"%sum}"
    sleep(0.5)
    puts Rainbow("We Have Saved Your Receipt").white
    # array.map { |h| h[:amount] }.sum
        File.open("$#{sum}.Kitchen_Receipt.txt",'a') do |f|
        f.puts("You Bought a Total of #{FOOD[:pho]} Pho at $10 Each") if FOOD[:pho] != 0
        f.puts("You Bought a Total of #{FOOD[:ban_xiao]} Ban Xiao at $12 Each") if FOOD[:ban_xiao] != 0
        f.puts("You Bought a Total of #{FOOD[:vietnamese_spring_rolls]} Vietnamese Spring Rolls at $14 Each") if FOOD[:vietnamese_spring_rolls] != 0
        f.puts("You Bought a Total of #{FOOD[:pork_roll]} Pork Roll At $52 Each") if FOOD[:pork_roll] != 0
        f.puts("Costing a Total Of $#{"%.2f"%sum}")
        end
    exit_menu = false
  else
    puts Rainbow("INVALID OPTION\nEnter a Number!").bg(:red)
  end
end
end

testing
Testing.new.run
welcome
