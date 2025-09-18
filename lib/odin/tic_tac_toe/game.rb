# frozen_string_literal: true

require_relative 'board'

module Odin
  module TicTacToe
    # The main game driver for Tic Tac Toe
    class Game
      attr_reader :current_player, :board

      def initialize
        @board = Board.new
        @current_player = 'X'
      end

      def move(cell)
        raise MoveError, "The game has already been won by #{winner}!" if won?
        raise MoveError, 'The game has already ended in a tie.' if tied?

        board.place_token(current_player, cell)
        next_player
      end

      def over?
        tied? || won?
      end

      def tied?
        !won? && board.full?
      end

      def won?
        !winner.nil?
      end

      def winner
        return 'X' if board.winner?('X')
        return 'O' if board.winner?('O')

        nil
      end

      private

      def next_player
        @current_player = current_player == 'X' ? 'O' : 'X'
      end
    end
  end
end
