# blackjack 00

class Deck
  attr_accessor :cards

  def initialize
    card_number = ['A','2','3','4','5','6','7','8','9','10','J','Q','K']
    card_suit = ["\u2660","\u2665","\u2666","\u2663"]
    @cards = card_number.product(card_suit)
    shuffle!
  end

  def shuffle!
    cards.shuffle!
  end

  def deal_card
    system('clear')
    cards.pop
  end
end

module Hand
  def display_card
    display_title
    cards.each do |card|
      print "| #{card[0]}#{card[1]} | "
    end
    puts ""
  end

  def display_title
    puts "<< #{name}'s card >>"
  end

  def total
    total = 0
    ace_count = 0
    cards.each do |card|
      if card[0] == 'A'
        total +=11
        ace_count +=1
      elsif card[0] == 'J' || card[0] == 'Q' ||card[0] == 'K'
        total +=10
      else
        total +=card[0].to_i
      end
    end
    ace_count.times { total -=10 if total > 21 }
    return total
  end

  def display_total
    puts "#{name}'s total is #{total}"
    puts ""
  end    

  def display_card_n_total
    display_card
    display_total
  end

  def add_card(new_card)
    cards << new_card
  end

  def burst?
    total > 21
  end

  def is_blackjack?
    cards.sort
    if ((cards.sort[0][0] == '10') && (cards.sort[1][0] == 'A') || 
      ((cards.sort[0][0] == 'A') && ((cards.sort[1][0] == 'J') || 
        (cards.sort[1][0] == 'Q')|| (cards.sort[1][0] == 'K'))))
      true
    else
      false
    end
  end
end


class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end
end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Chris the Dealer"
    @cards = []
  end

  def display_card_hide1_card
    display_title
    cards.each do |card|
      print "| #{card[0]} #{card[1]} | "
      break
    end
    print "| < Hide > | "
    puts ""
  end
end

class Game
  attr_accessor :player, :deck, :is_player_blackjack
  attr_accessor :is_dealer_blackjack, :is_player_bust, :is_dealer_bust
  attr_reader :dealer

  def initialize
    display_welcome_start_game_message
    puts "Enter your name: "
    player_name = gets.chomp
    @player = Player.new(player_name)
    @dealer = Dealer.new
  end

  def first_2_draw_player_dealer
    player.add_card(deck.deal_card)
    dealer.add_card(deck.deal_card)
    player.add_card(deck.deal_card)
    dealer.add_card(deck.deal_card)
  end

  def display_welcome_start_game_message
    system('clear')
    puts "Welcome to BLACKJACK game!"
    puts "Start game!"
  end

  def reset
    @is_player_bust = false
    @is_dealer_bust = false
    @is_player_blackjack = false
    @is_dealer_blackjack = false
    @deck = Deck.new
    player.cards = []
    dealer.cards = []
  end

  def display_card_n_total
    player.display_card
    player.print_total
  end

  def player_turn
    @is_player_blackjack = player.is_blackjack?
    begin
      break if is_player_blackjack
      puts "\nDo you want to 'hit' or 'stay?\n 'h' for hit ; 's' for stay"
      answer = gets.chomp.downcase
      if answer == 'h'
        player.add_card(deck.deal_card)
        player.display_card_n_total
        dealer.display_card_hide1_card
        @is_player_bust = player.burst?
        puts "#{player.name} busted!!!\n" if is_player_bust
      end
    end until answer == 's' || is_player_bust
  end

  def show_dealer_card
    system('clear')
    player.display_card_n_total
    dealer.display_card_n_total
    @is_dealer_blackjack = dealer.is_blackjack?
  end

  def print_winner(who,msg)
    puts ""
    puts "> #{who} won! #{msg}"
  end


  def any_blackjack_winner_or_player_bursted?
    if is_player_bust
      puts "#{player.name} busted!!!\n" if is_player_bust
    elsif is_player_blackjack && is_dealer_blackjack
      print_winner("No one","Both blackjack! Too bad!")
    elsif is_player_blackjack
      print_winner("Player","Blackjack")
    elsif is_dealer_blackjack
      print_winner("Dealer","Blackjack")
    end
  end

  def dealer_turn
    begin
      break if dealer.total >=17 || is_dealer_blackjack || is_player_bust || is_player_blackjack
      dealer.add_card(deck.deal_card)
      player.display_card_n_total
      dealer.display_card_n_total
      @is_dealer_bust = dealer.burst?
      puts "#{dealer.name} busted!!!\n" if is_dealer_bust
   end until dealer.total >=17 || is_dealer_bust
  end

  def who_won? 
    if !(is_dealer_bust || is_player_bust || 
      is_player_blackjack || is_dealer_blackjack)
      if player.total.to_i == dealer.total.to_i
        print_winner("No one","Because it's tie! Too bad!")
      elsif player.total.to_i > dealer.total.to_i
        print_winner("Player","Good job!!")
      else        
        print_winner("Dealer","No luck!")
      end
    end
  end

  def play
    loop do
      reset
      first_2_draw_player_dealer
      player.display_card_n_total
      dealer.display_card_hide1_card
      player_turn
      show_dealer_card
      any_blackjack_winner_or_player_bursted?
      dealer_turn
      who_won?
      puts "Type 'y' to replay again."
      break if gets.chomp.downcase != 'y'
    end
  end
end

Game.new.play

