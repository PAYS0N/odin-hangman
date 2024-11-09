# frozen_string_literal: true

module Hangman
  # class that stores a game state
  class Game
    # starts the hangman game. returns "new" to play another, "saveexit" to save the current game and exit,
    # "save" to save and continue playing, "exit" to leave, "error" if error
    def play_game
      puts "Game Played"
      "exit"
    end
  end
end
