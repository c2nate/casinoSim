class CasinoSim
  require_relative 'roulette'
  require_relative 'blackjack'
  def initialize
    @balance = 100
    @roulette = Roulette.new(@balance)
    @blackjack = Blackjack.new(@balance)
  end

  def start
    puts "Welcome to the Casino!"
    loop do
      lobby
      choice = get_game_choice
      case choice
      when "roulette"
        @roulette.play
        @balance = @roulette.balance # Update balance
      when "blackjack"
        @blackjack.play
        @balance = @blackjack.balance # Update balance
      when "exit"
        puts "Thank you for visiting the casino! Goodbye!"
        break
      else
        puts "Invalid choice, please choose 'roulette', 'blackjack' or 'exit'."
      end
      check_balance
    end
  end

  private

  def lobby
    puts "\n----- CASINO LOBBY -----"
    display_balance
    puts "What game would you like to play?"
    puts "1. Roulette"
    puts "2. Blackjack"
    puts "3. Exit"
    puts "\n"
  end

  def get_game_choice
    print "Enter your choice: "
    choice = gets.chomp.downcase
    case choice
    when "1", "roulette", "r"
      "roulette"
    when "2", "blackjack", "b"
      "blackjack"
    when "3", "exit", "e", "0"
      "exit"
    else
      choice
    end
  end

  def display_balance
    puts "Current balance: $#{@balance}"
  end

  def check_balance
    if @balance <= 0
      puts "You are out of money! Game over."
      exit
    end
  end
end


if __FILE__ == $0
  simulator = CasinoSim.new
  simulator.start
end
