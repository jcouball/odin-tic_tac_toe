# frozen_string_literal: true

require_relative 'game'

module Odin
  module TicTacToe
    # The command line interface for Tic Tac Toe
    #
    class CommandLineInterface
      def run
        start_game
        player_move_loop
        summarize_result
      end

      private

      def start_game
        puts
        puts "Let's Play Tic Tac Toe"
        puts
      end

      def player_move_loop
        until game.over?
          player_move = input_player_move
          begin
            game.move(player_move.to_i)
          rescue Odin::TicTacToe::MoveError => e
            output_move_error(player_move, e)
          end
        end
      end

      def summarize_result
        puts game.board
        puts
        print 'GAME OVER: '
        puts "Player #{game.winner} won!" if game.won?
        puts 'Tie game! Try again.' if game.tied?
      end

      def output_move_error(player_move, error)
        puts "Move '#{player_move}' is not valid: #{error.message}"
        puts "Try again\n\n"
      end

      def input_player_move
        puts game.board
        puts
        print "Player #{game.current_player}, enter a move (1-9): "
        gets.chomp.tap { puts }
      end

      def game
        @game ||= Odin::TicTacToe::Game.new
      end
    end
  end
end
