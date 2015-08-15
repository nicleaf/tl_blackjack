# Check README.md for pseudo code
# suit: s = spade, h = heart, c = club, d = diamond

require 'pry'

def new_deck
  card_number = ['A','2','3','4','5','6','7','8','9','10','J','Q','K']
  card_suit = ["\u2660","\u2665","\u2666","\u2663"]
  card_number.product(card_suit)
end

def blackjack_combo
  card_ace = ['a']
  card_jqk = ['j','q','k']
  card_ace.product(card_jqk)
end


def say(msg)
  puts "<< #{msg} >>"
end

def first_draw(player,dealer,cards)
  system('clear')
  2.times do |number|
    player << cards.pop
    dealer << cards.pop
  end
end

def print_total(who,cards_in_hand)
  total = 0
  cards_in_hand.each do |card|
    if card[0] == 'A'
      total = total + 11
    elsif card[0] == 'J' || card[0] == 'Q' ||card[0] == 'K'
      total = total + 10
    else
      total = total + card[0].to_i
    end
  end
  puts "#{who}'s total is #{total}"
  puts ""
end

def is_blackjack?(player,dealer)
  #p cards = [["a", "d"], ["10", "s"]]
  #p cards = [["a", "c"], ["9", "d"]]
  player.sort
  if (player.sort[0][0] == '10') && (player.sort[1][0] == 'A')
    return 'blackjack'
  elsif (player.sort[0][0] == 'A') && ((player.sort[1][0] == 'J') || 
    (player.sort[1][0] == 'Q')|| (player.sort[1][0] == 'K'))
    return 'blackjack'
  else
    return 'no blackjack'
  end
end

def winner(who,msg)
  puts "=> #{who} won! It's #{msg}"
end

def display_card(cards)
  cards.each do |card|
    print "| #{card[0]}#{card[1]} | "
  end
  puts ""
end

def display_card_hide1_card(cards)
  cards.each do |card|
    print "| #{card[0]} #{card[1]} | "
    break
  end
    print "| < Hide > | "
  puts ""
end


decks = []
player = []
dealer = []
first_time = nil

decks = new_deck.shuffle

begin
  puts "=> Do you want to start blackjack game? (y/n)"
  continue = gets.chomp.downcase
  if continue == 'y'
    if !first_time
      first_draw(player, dealer, decks)
      say("Player's card")
      display_card(player)
      print_total("Player",player)
      say("Dealer's card")
      display_card_hide1_card(dealer) if !first_time
      display_card(dealer) if first_time
      print_total("Dealer",dealer) if first_time
      if is_blackjack?(player,dealer) == 'blackjack'
        winner("Player","Blackjack")
        say ("Game end!")
        next
      elsif is_blackjack?(dealer,player) == 'blackjack'
        winner("Dealer","Blackjack")
        say ("Game end!")
        next
      end
    first_time = 1
    end
    puts "second time"
    p is_blackjack?(player,dealer)
  end
end until continue == 'n'


#check if anyone is blackjack, 
# check is it hard or soft.
# if both blackjack, dealer win, end game.
# elsif player blackjack, player win, end game.
# elsif dealer blackjack, dealer win, end game.
# else do nothing, continue to ask player to hit or stay.
