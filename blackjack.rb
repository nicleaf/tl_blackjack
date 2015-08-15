# Check README.md for pseudo code
# suit: s = spade, h = heart, c = club, d = diamond

require 'pry'

def new_deck
  card_number = ['A','2','3','4','5','6','7','8','9','10','J','Q','K']
  card_suit = ["\u2660","\u2665","\u2666","\u2663"]
  card_number.product(card_suit)
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

def hit_card(who,cards)
  system('clear')
  who << cards.pop
end

def calculate_total(who,cards_in_hand)
#  cards_in_hand = [["A", "c"], ["0", "d"],["Q", "c"], 
#  ["A", "d"],["0", "c"], ["0", "d"]]
#  p cards_in_hand
  total = 0
  ace_count = 0
  cards_in_hand.each do |card|
    if card[0] == 'A'
      total +=11
      ace_count +=1
    elsif card[0] == 'J' || card[0] == 'Q' ||card[0] == 'K'
      total +=10
    else
      total +=card[0].to_i
    end
  end
 if total > 21 && ace_count > 0
    begin
      ace_count.times do |count|
        total -=10
        ace_count -=1
        if total > 21 && ace_count != 0
          next
        else
          break
        end
      end
    end
  end
  return total
end

def print_total(who,total)
  puts "#{who}'s total is #{total}"
  puts ""
end

def burst?(who,total)
  if total > 21
#    puts ""
#    puts "#{who} busted!!!"
    return true
  else
    return nil
  end
end


def blackjack?(who,cards,option_cards=[["0", "0"], ["0", "0"]])
  #p cards = [["A", "d"], ["10", "s"]]
  #p option_cards = [["1", "c"], ["K", "d"]]
  cards.sort
  option_cards.sort
  if ((cards.sort[0][0] == '10') && (cards.sort[1][0] == 'A') || 
    ((cards.sort[0][0] == 'A') && ((cards.sort[1][0] == 'J') || 
      (cards.sort[1][0] == 'Q')|| (cards.sort[1][0] == 'K')))) && 
  ((option_cards.sort[0][0] == '10') && (option_cards.sort[1][0] == 'A') || 
    ((option_cards.sort[0][0] == 'A') && ((option_cards.sort[1][0] == 'J') || 
      (option_cards.sort[1][0] == 'Q')|| (option_cards.sort[1][0] == 'K'))))
#   puts ""
#   puts "Both Blackjack. It is a tie!!!"
    return 'tie'
  elsif (cards.sort[0][0] == '10') && (cards.sort[1][0] == 'A') || 
    ((cards.sort[0][0] == 'A') && ((cards.sort[1][0] == 'J') || 
    (cards.sort[1][0] == 'Q')|| (cards.sort[1][0] == 'K')))
#    winner("#{who}","Blackjack")
    return true
  else
    return nil
  end
end

def winner(who,msg)
  puts ""
  puts "> #{who} won! #{msg}"
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

# main
begin
  decks = []
  player = []
  dealer = []
  decks = new_deck.shuffle
  #game_end = nil
  is_player_bust = nil
  is_dealer_bust = nil
  is_player_blackjack = nil
  is_dealer_blackjack = nil

  puts "\n> Do you want to start blackjack game? \n('y' = start game ; any key to quit!)" 
  continue = gets.chomp.downcase
  if continue == 'y'
#    p decks
    first_draw(player, dealer, decks)
    say("Player's card")
 #   player = [["A", "d"], ["10", "s"]]
#    dealer = [["A", "d"], ["10", "s"]]
    display_card(player)
    player_total = calculate_total("Player",player)
    print_total("Player",player_total)
    dealer_total = calculate_total("Dealer",dealer)
    say("Dealer's card")
    display_card_hide1_card(dealer)
#    display_card(dealer)
#    print_total("Dealer",dealer)
    is_player_blackjack = blackjack?("Player",player,dealer)


    begin
      break if is_player_blackjack
      puts "\nDo you want to 'hit' or 'stay?\n 'h' for hit ; 's' for stay"
      answer = gets.chomp.downcase
      if answer == 'h'
        p decks
        hit_card(player,decks)
        say("Player's card")
        display_card(player)
        player_total = calculate_total("Player",player)
        print_total("Player",player_total)
        say("Dealer's card")
        display_card_hide1_card(dealer)
        is_player_bust = burst?("Player",player_total)
      end
    end until answer == 's' || is_player_bust


#    p decks
    system("clear")
    say("Player's card")
    display_card(player)
    print_total("Player",player_total)
    say("Dealer's card")
    display_card(dealer)
    dealer_total = calculate_total("Dealer",dealer)
    print_total("Dealer",dealer_total)
    is_player_bust = burst?("Player",player_total)
    puts "Player busted!!!\n" if is_player_bust
#    break if is_player_bust
    begin
      is_dealer_blackjack = blackjack?("Dealer",dealer)
      winner("No one","Both blackjack! Too bad!") if is_player_blackjack == 'tie'
      winner("Player","Blackjack") if is_player_blackjack == true
      winner("Dealer","Blackjack") if is_dealer_blackjack && !is_player_bust && !is_player_blackjack
      break if dealer_total >= 17 || is_dealer_blackjack || 
      is_player_bust || is_player_blackjack
      hit_card(dealer,decks)
      say("Player's card")
      display_card(player)
      print_total("Player",player_total)
      say("Dealer's card")
      display_card(dealer)
      dealer_total = calculate_total("Dealer",dealer)
      print_total("Dealer",dealer_total)
      is_dealer_bust = burst?("Dealer",dealer_total)
      puts "Dealer busted!!!\n" if is_dealer_bust
    end until dealer_total >= 17 || is_dealer_bust

 
    if !(is_dealer_bust == true || is_player_bust == true || 
      is_player_blackjack == true || is_dealer_blackjack == true)
      if player_total.to_i == dealer_total.to_i
        winner("No one","Because it's tie! Too bad!")
      elsif player_total.to_i > dealer_total.to_i
        winner("Player","Good job!!")
      else        
        winner("Dealer","No luck!")
      end
    end
  end    
end until continue != 'y'


#check if anyone is blackjack, 
# check is it hard or soft.
# if both blackjack, dealer win, end game.
# elsif player blackjack, player win, end game.
# elsif dealer blackjack, dealer win, end game.
# else do nothing, continue to ask player to hit or stay.
