# frozen_string_literal: true

require_relative("game_manager")

game_manager = Hangman::GameManager.new
game_manager.start_game
