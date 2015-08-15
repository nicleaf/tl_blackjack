# README #
## TL - Lesson 1 - Assignment - Blackjack Game ##

Started: 13 Aug 2015  
Status: In progress  

Pseudo code:   
Create deck of card - 52/set   
Ask if player want to start game
First draw for both player & dealer - 2 cards each
Calculate total in hand
check if anyone is blackjack, 
 if both blackjack, dealer win, end game.
 elsif player blackjack, player win, end game.
 elsif dealer blackjack, dealer win, end game.
 else do nothing, continue to ask player to hit or stay.
Check dealer only. Check if soft 17, else hard 17.
Show the total to player.
Show dealer total - hide it first.
loop: Ask if player want to hit or stay
  if hit, random pick available balance card from the deck, show the card, calculate total. 
    if player == 21, stay, dealer turn.
    elsif player > 21, busted, exit, end game. result: lost.
    else (< 21)
     return back to loop. 
  else, (stay)
  	dealer turn.

if player stay, it's dealer turn. 
 if > 21, dealer busted, player win. end games.
 elsif 21, dealer win. end game.
 elsif > 17, dealer stay, go to compare result.
 elsif = 17, 
   if it soft 17, hit, calculate total, repeat.
   else stay.
 elsif total < 17, hit. calculate total, repeat
 else stay. end

compare result,
 player win, if player total > dealer total.
 else, dealer win.

NOTE:
 hit means: auto pick random available card from deck, show the card, calculate total.
