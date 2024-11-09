# frozen_string_literal: true

require "yaml"
require_relative("game")

module Hangman
  # manages the hangman game
  class GameManager
    def start_game
      puts "Would you like to start a new game or load a saved game? (N/L)"
      response = ask_response
      exit = begin_game(response)
      end_game(exit)
    end

    private

    # based on user input, choose what instance of hangman to start. return what the manager should do next
    def begin_game(response)
      if response == "N"
        @game_playing = Hangman::Game.new
        @game_playing.play_game
      elsif response == "L"
        load_game
      else
        "error"
      end
    end

    # return "N" for new game or "L" for load
    def ask_response
      gets.chomp
    end

    def end_game(exit)
      case exit
      when "new"
        start_game
      when "save"
        save_game
      when "leave"
        exit_game
      when "error"
        exit_game("error")
      end
    end

    def exit_game(status = "ok")
      puts "There was an error" if status == "error"
    end

    def load_game
      puts "load"
      "exit"
    end

    def save_game
      puts "save"
    end
  end
end
