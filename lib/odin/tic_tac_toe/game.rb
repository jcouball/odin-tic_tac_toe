# frozen_string_literal: true

module Odin
  module TicTacToe
    # The main game driver for Tic Tac Toe
    class Game
      attr_reader :current_player

      def initialize
        @current_player = 'X'
        @board = [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]
      end

      def empty_cells?
        cells_remaining = @board.reduce(0) { |subtotal, row| subtotal + row.count(nil) }
        cells_remaining.positive?
      end

      def tied?
        !empty_cells?
      end

      def won?
        !winner.nil?
      end

      def over?
        tied? || won?
      end

      def won_row?(player, row_index)
        @board[row_index].all?(player)
      end

      def won_column?(player, column_index)
        (0..2).map do |row_index|
          @board[row_index][column_index]
        end.all?(player)
      end

      def won_diagonal?(player)
        (0..2).map { |row_index| @board[row_index][row_index] }.all?(player) ||
          (0..2).map { |row_index| @board[row_index][2 - row_index] }.all?(player)
      end

      def winner?(player)
        (0..2).each do |index|
          return true if won_row?(player, index)
          return true if won_column?(player, index)
        end
        won_diagonal?(player)
      end

      def winner
        return 'X' if winner?('X')
        return 'O' if winner?('O')

        nil
      end

      def board_row_content(row_index)
        column_divider = '|'
        row_content =
          (0..2).map do |column_index|
            move = (row_index * 3) + column_index + 1
            @board[row_index][column_index] || move
          end.join(" #{column_divider} ")

        "#{column_divider} #{row_content} #{column_divider}"
      end

      def board
        row_divider = '+---+---+---+'
        board_content =
          (0..2).map do |row_index|
            board_row_content(row_index)
          end.join("\n#{row_divider}\n")
        "#{row_divider}\n#{board_content}\n#{row_divider}"
      end

      def move(cell)
        assert_game_not_over
        assert_cell_is_valid(cell)
        assert_cell_is_unoccupied(cell)
        place_token_on_board(cell, current_player)
        next_player
      end

      private

      def assert_game_not_over
        raise Odin::TicTacToe::MoveError, 'The game has already ended in a tie.' if tied?
        raise Odin::TicTacToe::MoveError, "The game has already been won by #{winner}!" if won?
      end

      def assert_cell_is_valid(cell)
        return unless !cell.is_a?(Integer) || cell < 1 || cell > 9

        raise Odin::TicTacToe::MoveError, 'Cell must be an integer between 1 and 9.'
      end

      def assert_cell_is_unoccupied(cell)
        row = (cell - 1) / 3
        column = (cell - 1) % 3

        raise Odin::TicTacToe::MoveError, 'That cell is already occupied.' if @board[row][column]
      end

      def place_token_on_board(cell, token)
        row = (cell - 1) / 3
        column = (cell - 1) % 3

        @board[row][column] = token
      end

      def next_player
        @current_player = current_player == 'X' ? 'O' : 'X'
      end
    end
  end
end
