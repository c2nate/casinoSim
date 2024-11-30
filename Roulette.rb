class Roulette
  attr_reader :balance

  def initialize(balance)
    @balance = balance
  end

  def play
    puts "\nWelcome to Roulette!"
    loop do
      print "Would you like to place a bet or exit? (bet/exit): "
      choice = gets.chomp.downcase
      case choice
      when "exit", "e", "0"
        puts "Returning to lobby..."
        break
      when "bet", "b"
        bet = place_bet
        next if bet.nil?

        result = spin_roulette
        puts "\n\nThe roulette wheel spun to: #{result[:number]} (#{result[:color]})\n"
        calculate_roulette_result(bet, result)
      else
        puts "Invalid choice! Please enter 'bet' to place a bet or 'exit' to leave."
      end
    end
  end

  private

  def place_bet
    bet = get_bet_amount
    return nil if bet == 0

    print "\nWould you like to bet on a number or color? (n/c): "
    choice = gets.chomp.downcase
    case choice
    when 'n'
      print "\nEnter the number (0-36) you'd like to bet on: "
      number = gets.chomp.to_i
      return nil unless number.between?(0, 36)
      { amount: bet, number: number, color: nil }
    when 'c'
      print "Enter the color you'd like to bet on (red/black): "
      color = gets.chomp.downcase
      return nil unless %w[red black].include?(color)
      { amount: bet, number: nil, color: color }
    else
      nil
    end
  end

  def get_bet_amount
    print "\nEnter your bet amount (or 0 to skip): $"
    amount = gets.chomp.to_i
    if amount > @balance
      puts "You can't bet more than your balance!"
      get_bet_amount
    elsif amount < 0
      puts "\nBet can't be negative!"
      get_bet_amount
      puts "\n"
    else
      amount
    end
  end

  def spin_roulette
    number = rand(37)
    color = determine_color(number)
    { number: number, color: color }
  end

  def determine_color(number)
    return 'green' if number == 0
    red_numbers = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
    red_numbers.include?(number) ? 'red' : 'black'
  end

  def calculate_roulette_result(bet, result)
    if result[:number] == bet[:number]
      puts "Congratulations! You won!"
      @balance += bet[:amount] * 35
    elsif result[:color] == bet[:color]
      puts "Congratulations! You won on " + result[:color] + "!"
      @balance += bet[:amount] * 2
    else
      puts "\nBetter luck next time!"
      @balance -= bet[:amount]
    end
    puts "\nCurrent balance: $#{@balance}"
    puts "\n"
  end
end
