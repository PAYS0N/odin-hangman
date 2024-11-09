# frozen_string_literal: true

require("yaml")
require_relative("game")

module Hangman
  # manages the hangman game
  class GameManager
    def start_game
      response = ask_response
      exit = begin_game(response)
      end_game(exit)
    end

    private

    # based on user input, choose what instance of hangman to start. return what the manager should do next
    def begin_game(response)
      if response == "N"
        @game_playing = Hangman::Game.new(find_word, [], 7)
        @game_playing.play_game
      elsif response == "L"
        load_game
      else
        "error"
      end
    end

    def find_word
      word_index = rand(1..7557)
      word = ""
      File.open("cleaned_words.txt", "r") do |file|
        word_index.times do
          word = file.gets.chomp
        end
      end
      word
    end

    # return "N" for new game or "L" for load
    def ask_response
      input = ""
      until %w[N L].include?(input)
        puts "Would you like to start a new game or load a saved game? (N/L)"
        input = gets.chomp
      end
      input
    end

    def end_game(exit)
      case exit
      when "new"
        start_game
      when "saveexit"
        save_game
        end_game("exit")
      when "save"
        save_game
        start_game
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
      saves = open_saves
      display_saves(saves)
      game_num = ask_load(saves.length) - 1
      return exit_game if game_num == -2

      @game_playing = Hangman::Game.from_yaml(saves[game_num])
      saves.delete_at(game_num)
      write_saves(saves)
      @game_playing.display_game_state
      @game_playing.play_game
    end

    def display_saves(saves)
      saves.each_with_index do |save, i|
        print "#{i + 1}. "
        Hangman::Game.from_yaml(save).display_game_state
      end
    end

    def ask_load(length)
      puts "What game would you like to load? Enter the number next to the game or \"-1\" to quit."
      input = 0
      input = gets.chomp.to_i until input.between?(1, length + 1) || input == -1
      input
    end

    def save_game
      saves = open_saves
      saves.push(@game_playing.to_yaml)
      write_saves(saves)
    end

    def open_saves
      data = YAML.load_file("saved_games.yml")
      return [] if data.nil?

      data[:saves]
    end

    def write_saves(saves)
      f = File.open("saved_games.yml", "w")
      f.puts YAML.dump({ saves: saves })
      f.close
    end
  end
end
