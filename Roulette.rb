class Roulette
  def initialize(casino_sim)
    @casino_sim = casino_sim
  end

  def play
    puts "\nWelcome to Roulette!"
    display_balance

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

  def display_balance
    puts "Current Balance: $#{@casino_sim.balance}\n"
  end

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
    if amount > @casino_sim.balance
      puts "You can't bet more than your balance!"
      get_bet_amount
    elsif amount < 0
      puts "\nBet can't be negative!"
      get_bet_amount
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
      winnings = bet[:amount] * 35
      puts "Congratulations! You won $#{winnings}!"
      @casino_sim.update_balance(@casino_sim.balance + winnings)
    elsif result[:color] == bet[:color]
      winnings = bet[:amount] * 2
      puts "Congratulations! You won $#{winnings} on #{result[:color]}!"
      @casino_sim.update_balance(@casino_sim.balance + winnings)
    else
      puts "\nBetter luck next time!"
      @casino_sim.update_balance(@casino_sim.balance - bet[:amount])
    end
    display_balance
  end
end
