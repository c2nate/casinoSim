class RouletteGame
  def initialize
    @balance = 100 # Starting balance
    @red_numbers = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
    @black_numbers = [2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35]
  end

  def start_game
    puts "Welcome to Roulette!"
    while true
      display_balance
      print "Would you like to place a bet or exit? (bet/exit): "
      choice = gets.chomp.downcase
      if choice == "exit"
        puts "Thank you for playing! Goodbye!"
        break
      elsif choice == "bet"
        bet = get_bet
        if bet[:amount] == 0
          puts "No bet placed, skipping round."
          next
        end
        result = spin_roulette
        puts "The roulette spun to: #{result[:number]} (#{result[:color]})"
        if result[:number] == bet[:number]
          puts "Congratulations! You won!"
          @balance += bet[:amount] * 35 # Payout for a correct number bet (35:1)
        elsif result[:color] == bet[:color]
          puts "Congratulations! You won on color!"
          @balance += bet[:amount] * 2 # Payout for a correct color bet (2:1)
        else
          puts "Better luck next time!"
          @balance -= bet[:amount]
        end
        check_balance
      else
        puts "Invalid choice! Please enter 'bet' to place a bet or 'exit' to leave."
      end
    end
  end

  private

  def display_balance
    puts "Current balance: $#{@balance}"
  end

  def get_bet
    print "Enter your bet amount (or 0 to skip): $"
    amount = gets.chomp.to_i
    return { amount: 0 } if amount == 0
    if amount > @balance
      puts "You can't bet more than your balance!"
      return get_bet
    elsif amount < 0
      puts "Bet can't be negative!"
      return get_bet
    end

    print "Would you like to bet on a number or color? (n/c): "
    choice = gets.chomp.downcase
    case choice
    when 'n'
      print "Enter the number (0-36) you'd like to bet on: "
      number = gets.chomp.to_i
      if number < 0 || number > 36
        puts "Invalid number! Must be between 0 and 36."
        return get_bet
      end
      return { amount: amount, number: number, color: nil }
    when 'c'
      print "Enter the color you'd like to bet on (red/black): "
      color = gets.chomp.downcase
      if color != 'red' && color != 'black'
        puts "Invalid color! Choose 'red' or 'black'."
        return get_bet
      end
      return { amount: amount, number: nil, color: color }
    else
      puts "Invalid choice! Please choose 'n' for number or 'c' for color."
      return get_bet
    end
  end

  def spin_roulette
    number = rand(37)
    color = determine_color(number)
    { number: number, color: color }
  end

  def determine_color(number)
    return 'green' if number == 0
    @red_numbers.include?(number) ? 'red' : 'black'
  end

  def check_balance
    if @balance <= 0
      puts "You are out of money! Game over."
      exit
    end
  end
end

# Create a new game instance and start the game
game = RouletteGame.new
game.start_game
