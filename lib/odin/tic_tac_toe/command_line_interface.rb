# frozen_string_literal: true

require_relative 'game'

module Odin
  module TicTacToe
    # The command line interface for Tic Tac Toe
    #
    class CommandLineInterface
      def run
        start_game_banner

        until game.over?
          player_move = input_player_move
          begin
            game.move(player_move.to_i)
            summarize_move
          rescue Odin::TicTacToe::MoveError => e
            output_move_error(player_move, e)
          end
        end
      end

      private

      def start_game_banner
        puts "Let's Play Tic Tac Toe\n\n"
        puts
        puts game.board
      end

      def output_move_error(player_move, error)
        puts "Move '#{player_move}' is not valid: #{error.message}"
        puts "Try again\n\n"
      end

      def input_player_move
        print "Player #{game.current_player}, enter a move (1-9): "
        gets.chomp.tap { puts }
      end

      def game
        @game ||= Odin::TicTacToe::Game.new
      end

      def summarize_move
        puts game.board
        puts "\nGAME OVER" if game.over?
        puts "Player #{game.winner} won!" if game.won?
        puts 'Tie game! Try playing another game' if game.tied?
        puts
      end
    end
  end
end
