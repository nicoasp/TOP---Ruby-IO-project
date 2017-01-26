require './game.rb'
require 'yaml'

class Program

	attr_reader :game, :quit

	def initialize
		@dir = Dir.new("games")
		@quit = false
		create_saved_games_array
	end

	def choose_game
		puts %q{Type one of these options: 
			N to start a NEW game, 
			R to RESUME an unfinished game
			Q to quit the program
		}
		choice = gets.chomp.upcase
		case choice
		when "N"
			new_game
		when "R"
			puts "Choose the number of the game you want to resume:"
			sleep 3
			display_saved_games
			game_index = gets.chomp.to_i - 1
			@game_name = @saved_games[game_index]
			load_game("games/#{@game_name}")
		when "Q"
			puts "Thanks for playing! See you next time!"
			@quit = true
			return
		end
	end

	def create_saved_games_array
		@saved_games = []		
		@dir.each do |filename|
			@saved_games << filename unless filename[0] == "."
		end
	end		

	def display_saved_games
		@saved_games.each_with_index do |filename, index|
			puts "#{index + 1}: #{filename}"
		end
	end

	def new_game
		@game = Game.new
	end

	def load_game(filename)
		yaml = File.read(filename)
		@game = YAML::load(yaml)
	end

	def delete_finished_game
		File.delete("games/#{@game_name}")
	end

end


program = Program.new
program.choose_game

unless program.quit
	until program.game.game_over? || program.game.game_paused?
		program.game.turn
	end

	if program.game.won?
		puts "That's right, '#{program.game.solution}'! Congratulations, you guessed the word!"
		sleep 3
		program.delete_finished_game
		program.choose_game
	elsif program.game.lost?
		puts "You are out of guesses! The secret word was '#{program.game.solution}'"
		sleep 3
		program.delete_finished_game
		program.choose_game
	elsif program.game.game_paused?
		puts "Your game has been saved"
		sleep 3
		program.choose_game
	end
end

