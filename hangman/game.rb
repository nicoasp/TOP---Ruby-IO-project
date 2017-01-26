require 'yaml'

class Game

	attr_accessor :solution
	attr_reader :name, :time

	def initialize
		@time = Time.now
		@paused = false
		@dictionary = File.readlines("5desk.txt")
		@hint = ""
		clean_dictionary
		create_random_solution
		@guesses_left = 10
		@incorrect_letters = []
		@guess = ""
		puts "Welcome? What's your name?"
		@name = gets.chomp
	end

	def clean_dictionary
		@dictionary.map! do |word|
			word.strip
		end
		@dictionary.select! do |word|
			(word.length >= 5) && (word.length <= 12) && (word[0].upcase != word[0])
		end
	end

	def create_random_solution
		size = @dictionary.length
		@solution = @dictionary[rand(size)]
		@solution.each_char do |char|
			@hint << "_"
		end
	end

	def check_answer
		if @guess == @solution
			@hint = @solution
		else
			@guesses_left -= 1
			puts "wrong answer!"
		end
	end	

	def check_letter
		if @solution.include?(@guess)
			count = 0
			index = 0
			while index
				index = @solution.index(@guess, count)
				@hint[index] = @guess if index
				count = index + 1 if index
			end
		else
			@incorrect_letters << @guess
			@guesses_left -= 1
		end
	end

	def save_game
		Dir.mkdir("games") unless Dir.exists? "games"
		filename = "Player_#{@name}_Started_#{@time.day}-#{@time.month},#{@time.hour}:#{@time.min}"
		
		yaml = YAML::dump(self)

		File.open("games/#{filename}", "w") do |file|
			file.puts yaml
		end
		@paused = true
	end

	def display_game_state
		puts "This is the current game state"
		puts "Board: " + @hint + "   -   Wrong letters: " + @incorrect_letters.join(", ")
		puts "Guesses remaining: " + @guesses_left.to_s
	end

	def turn
		display_game_state
		puts "Make a guess or type 'save' to save game"
		@guess = gets.chomp
		if @guess == "save"
			save_game
		elsif @guess.length == 1
			check_letter
		else
			check_answer
		end
	end

	def won?
		@hint == @solution
	end

	def lost?
		@guesses_left <= 0
	end

	def game_over?
		won? || lost?
	end

	def game_paused?
		@paused
	end

end










