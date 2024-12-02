class Blackjack
  attr_reader :balance

  SUITS = {
    'Hearts' => '♥',
    'Diamonds' => '♦',
    'Clubs' => '♣',
    'Spades' => '♠'
  }

  def initialize(balance)
    @balance = balance
  end

  def play
    puts "\nWelcome to Blackjack!"
    loop do
      bet = get_bet_amount
      break if bet == 0
      play_round(bet)
    end
  end

  private

  def get_bet_amount
    print "\nEnter your bet amount (or 0 to skip): $"
    amount = gets.chomp.to_i
    if amount > @balance
      puts "\nYou can't bet more than your balance!"
      get_bet_amount
    elsif amount < 0
      puts "\nBet can't be negative!"
      get_bet_amount
    else
      amount
    end
  end

  def play_round(bet)
    deck = generate_deck
    player_hand, dealer_hand = deal_initial_cards(deck)

    if can_split?(player_hand)
      print "\nYou were dealt a pair! Would you like to split your hand? (y/n): "
      if gets.chomp.downcase == 'y'
        split_hand(deck, player_hand, dealer_hand, bet)
        return
      end
    end

    puts "\nYour hand: #{display_hand(player_hand)} (Total: #{hand_total(player_hand)})"
    puts "Dealer's visible card: #{dealer_hand.first}"

    result = player_turn(deck, player_hand)
    if result == :lose
      @balance -= bet
      puts "You lost $#{bet}. Current balance: $#{@balance}"
      return
    end

    dealer_turn(deck, dealer_hand)
    resolve_game(player_hand, dealer_hand, bet)
  end

  def generate_deck
    ranks = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace]
    suits = SUITS.values
    deck = ranks.product(suits).map { |rank, suit| "#{rank} #{suit}" }
    deck.shuffle
  end

  def deal_initial_cards(deck)
    player_hand = [deck.pop, deck.pop]
    dealer_hand = [deck.pop, deck.pop]
    [player_hand, dealer_hand]
  end

  def display_hand(hand)
    hand.join(', ')
  end

  def hand_total(hand)
    values = hand.map do |card|
      rank = card.split.first
      case rank
      when 'Ace' then 11
      when 'King', 'Queen', 'Jack' then 10
      else rank.to_i
      end
    end

    total = values.sum
    values.count(11).times { total -= 10 if total > 21 }
    total
  end

  def player_turn(deck, hand)
    loop do
      puts "\nYour hand: #{display_hand(hand)} (Total: #{hand_total(hand)})"
      print "Would you like to hit or stand? (h/s): "
      choice = gets.chomp.downcase
  
      if choice == 'h'
        hand << deck.pop
        puts "\nYou drew: #{hand.last}"
        if hand_total(hand) > 21
          puts "\nYou busted!"
          return :lose
        end
      elsif choice == 's'
        puts "\nYou chose to stand."
        return :stand
      else
        puts "\nInvalid choice. Please enter 'h' to hit or 's' to stand."
      end
    end
  end

  def dealer_turn(deck, hand)
    puts "\nDealer's turn..."
    while hand_total(hand) < 17
      hand << deck.pop
      puts "Dealer drew: #{hand.last}"
    end
    puts "Dealer's hand: #{display_hand(hand)} (Total: #{hand_total(hand)})"
  end

  def resolve_game(player_hand, dealer_hand, bet)
    player_total = hand_total(player_hand)
    dealer_total = hand_total(dealer_hand)

    if dealer_total > 21 || player_total > dealer_total
      puts "\nCongratulations! You won $#{bet}!"
      @balance += bet
    elsif dealer_total > player_total
      puts "\nDealer wins with #{dealer_total}. You lose $#{bet}."
      @balance -= bet
    else
      puts "\nIt's a tie! Your bet is returned."
    end
    puts "Current balance: $#{@balance}"
  end

  def can_split?(hand)
    hand.size == 2 && hand.map { |card| card.split.first }.uniq.size == 1
  end

  def split_hand(deck, player_hand, dealer_hand, bet)
    puts "\nSplitting your hand into two hands..."
    hand1 = [player_hand[0], deck.pop]
    hand2 = [player_hand[1], deck.pop]
    puts "\nFirst hand: #{display_hand(hand1)}"
    puts "Second hand: #{display_hand(hand2)}"

    [hand1, hand2].each_with_index do |hand, index|
      puts "\nPlaying Hand #{index + 1}:"
      result = player_turn(deck, hand)
      if result == :lose
        puts "\nHand #{index + 1} busted! You lose $#{bet}."
        @balance -= bet
      else
        dealer_turn(deck, dealer_hand)
        resolve_game(hand, dealer_hand, bet)
      end
    end
  end
end
