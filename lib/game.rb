# frozen_string_literal: true

require("yaml")

module Hangman
  # class that stores a game state
  class Game
    def initialize(word, letters_guessed, guesses_remaining)
      @game_running = true
      @word = word
      @letters_guessed = letters_guessed
      @guesses_remaining = guesses_remaining
      @exit_type = "check_exit"
    end

    # starts the hangman game. returns "new" to play another, "saveexit" to save the current game and exit,
    # "save" to save and continue playing, "exit" to leave, "error" if error
    def play_game
      play_round while @guesses_remaining.positive? && @game_running
      end_game
    end

    def to_yaml
      YAML.dump({
                  word: @word,
                  letters: @letters_guessed,
                  guesses: @guesses_remaining
                })
    end

    def self.from_yaml(string)
      data = YAML.load string
      new(data[:word], data[:letters], data[:guesses])
    end

    def display_game_state
      @game_running = false
      puts ""
      display_word
      puts "Letters guessed: #{@letters_guessed.sort.join}"
      puts "Wrong guesses remaining: #{@guesses_remaining}"
      puts ""
    end

    private

    def display_word
      @word.each_char do |char|
        if @letters_guessed.include?(char)
          print char
        else
          @game_running = true
          print "_"
        end
      end
      puts ""
    end

    def play_round
      exiting, input = ask_input
      if exiting
        define_exit(input)
      else
        update_game_state(input)
        display_game_state
      end
    end

    def update_game_state(char)
      @letters_guessed.push(char)
      @guesses_remaining -= 1 unless @word.chars.include?(char)
    end

    # ask for guess that is a character that has not been guessed, or a code for exiting/saving the game
    def ask_input
      puts "What letter do you guess? Alternatively, you can save and exit, save and play again, or quit without saving. (SE, PA, QW)"
      input = ""
      input = gets.chomp until %w[SE PA QW].include?(input) || (input.length == 1 && !@letters_guessed.include?(input))
      return [true, input] if %w[SE PA QW].include?(input)

      [false, input]
    end

    def define_exit(input)
      @game_running = false
      case input
      when "SE"
        @exit_type = "saveexit"
      when "PA"
        @exit_type = "save"
      end
    end

    def end_game
      ask_continuation if @exit_type == "check_exit"
      print_end_of_game
      @exit_type
    end

    def print_end_of_game
      case @exit_type
      when "saveexit"
        puts "Saving and exiting"
      when "save"
        puts "Saving"
      when "exit"
        puts "Exiting"
      when "new"
        puts "Starting new game"
      end
    end

    def ask_continuation
      puts "Would you like to play again? (Y/N)"
      @exit_type = if gets.chomp == "Y"
                     "new"
                   else
                     "exit"
                   end
    end
  end
end
