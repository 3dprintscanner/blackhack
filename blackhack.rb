# program to play blackjack,
# how does blackjack work????? First player to get to 21 wins, get over 21 and you lose, the house is obliged to play until a value.


# one object for cards, each card has a suit and a value. 
# the cards are stored in a deck. 
# The game has a player and a house
# The game should let you draw cards, and have high and low scores.



class Card

	attr_accessor :suit, :value
	attr_reader :default_suits, :default_values

	@@default_suits = ['heart','club','diamond','spade']
	@@default_values = [2,3,4,5,6,7,8,9,10,'jack','king','queen','ace']
	# @@card_value_lookup = {2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9, 10 => 10,  'jack'=>10,  'queen'=> 10,  'king'=> 10,  'ace'=> [11,1]}
	@@card_value_lookup = {2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9, 10 => 10,  'jack'=>10,  'queen'=> 10,  'king'=> 10,  'ace'=> 1}




	def initialize(suit,value)
		@suit = suit #||= @@default_suits(rand(1..@@default_suits.length))
		@value = value #||= @@default_values(rand(1..@@default_values.length))
	end

	def self.default_suits
		@@default_suits
	end

	def self.card_value_lookup
		@@card_value_lookup
	end

	def self.default_values
		@@default_values
	end

	def show
		puts "This card is the #{@value} of #{@suit}s"
	end

end

class Deck
	# A deck contains a full set of cards, it can create a new deck, it can shuffle the current deck, it can take a card from the deck.
	attr_accessor :cards
	def initialize
# create a new deck of cards
		total = Card.default_suits.length*Card.default_values.length
		@cards =[]
		Card.default_suits.each do |suit|
			Card.default_values.each do |value|
				newcard = Card.new(suit,value)
				@cards.push(newcard)
			end
		end
	end
	def shuffle
		@cards.shuffle!
	end

	def draw
		#select a random card, return the value of the card and delete than card from the cards array
		selected_card_index = rand(@cards.length)
		return_card = @cards[selected_card_index]
		@cards.delete_at(selected_card_index)
		return return_card
	end
end

class Player
	attr_accessor :hand
	attr_accessor :balance
	attr_accessor :name

	def initialize(name,balance)
		@name = name
		@balance = balance
		@hand = []
	end

	def add_to_hand(card)
		@hand.push(card)
	end
end


class Game 

	attr_accessor :gamedeck
	def initialize 	
		puts 'welcome to the blackjack game, please enter your name, player'
		name = gets.chomp
		puts "hello #{name}, welcome to the game"
		@gamedeck = Deck.new
		@gamedeck.shuffle
		@player1 = Player.new(name,100)
	end

	#main loop
	def show_hand
		@player1.hand.each do |card|
			puts card.show
		end
	end

	def current_score
		@score=0 
		@player1.hand.each do |card|
			@score = @score+Card.card_value_lookup.fetch(card.value)
		end
		@score
		#if there is an array, how do we present a choice of scores?
	end

	def opening_deal
		@player1.add_to_hand(@gamedeck.draw)
		@player1.add_to_hand(@gamedeck.draw)
	end

	def stick(player)

	end

	def twist
		@player1.add_to_hand(@gamedeck.draw)
	end

	def bust
		puts "Your score is #{current_score} and you have gone bust"
	end

	def win

	end
end

class AI

	def initialize
		aigame = Game.new
		aigame.opening_deal
		aigame.show_hand
		puts "this is the opening hand with a score of #{aigame.current_score}"
		while true
			if aigame.current_score <= 17
				puts "lets twist"
				aigame.twist
				aigame.show_hand
			elsif  (aigame.current_score >= 18) && (aigame.current_score < $new_game.current_score)
				aigame.twist
				if aigame.current_score > 21
					puts 'bust AI'
					break
				end
			elsif (aigame.current_score <=21) && (aigame.current_score > $new_game.current_score)
				puts "AI wins"
				break	
			elsif aigame.current_score == 21
				puts "The house score is#{aigame.current_score}"
				if aigame.current_score > $new_game.current_score
					puts "AI Wins"
					break
				end
				break
			elsif aigame.current_score >= 22
				puts "bust, player wins"
				break
			end
		end
	end

end

def newgame
	puts 'new game'
	$new_game = Game.new
	$new_game.opening_deal
	$new_game.show_hand
	while true
		puts "Your score is #{$new_game.current_score}"
		puts 'Would you like another card, Y or N ?'
		input = gets.chomp.upcase
		if input == 'Y'
			$new_game.twist
			$new_game.show_hand
			puts "your score is #{$new_game.current_score}"
		elsif input == 'N'
			puts "your score is #{$new_game.current_score}"
			#start computer AI here
			AI.new
			break
		end
		if $new_game.current_score > 21
				$new_game.bust
				break

		elsif $new_game.current_score == 21 
			puts '21 Reached !!!!'
			break
		end
	end			
end


newgame
#let the player start a game and draw two cards to begin...

