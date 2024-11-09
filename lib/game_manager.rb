# frozen_string_literal: true

require_relative("game")

module Hangman
  # manages the hangman game
  class GameManager
    def start_game
      puts "Would you like to start a new game or load a saved game? (N/L)"
      response = ask_response
      if response == "N"
        game = Hangman::Game.new
        game.play_game
      elsif response == "L"
        load_game
      else
        puts "error"
      end
    end

    # return "N" for new game or "L" for load
    def ask_response
      gets.chomp
    end

    def load_game
      puts "load"
    end
  end
end
