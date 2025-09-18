# frozen_string_literal: true

module Odin
  module TicTacToe
    # Represents the state and behavior of the 3x3 Tic Tac Toe board.
    class Board
      # All possible winning combinations of cell numbers (1-9)
      WINNING_LINES = [
        # Rows
        [1, 2, 3], [4, 5, 6], [7, 8, 9],
        # Columns
        [1, 4, 7], [2, 5, 8], [3, 6, 9],
        # Diagonals
        [1, 5, 9], [3, 5, 7]
      ].freeze

      def initialize
        @grid = Array.new(3) { Array.new(3) } # Creates the 3x3 grid of nils
      end

      def place_token(token, cell)
        assert_cell_is_valid(cell)
        row, col = coordinates_for(cell)
        assert_cell_is_unoccupied(row, col)

        @grid[row][col] = token
      end

      def winner?(token)
        WINNING_LINES.any? do |line|
          line.all? do |cell|
            row, col = coordinates_for(cell)
            @grid[row][col] == token
          end
        end
      end

      def full?
        @grid.flatten.none?(nil)
      end

      # Renders the board as a string for display.
      def to_s
        row_divider = '+---+---+---+'
        board_content =
          (0..2).map do |row_index|
            board_row_content(row_index)
          end.join("\n#{row_divider}\n")
        "#{row_divider}\n#{board_content}\n#{row_divider}"
      end

      private

      def board_row_content(row_index)
        row_content =
          (0..2).map do |column_index|
            move = (row_index * 3) + column_index + 1
            @grid[row_index][column_index] || move
          end.join(' | ')

        "| #{row_content} |"
      end

      def assert_cell_is_valid(cell)
        return if cell.is_a?(Integer) && cell.between?(1, 9)

        raise MoveError, 'Cell must be an integer between 1 and 9.'
      end

      def assert_cell_is_unoccupied(row, column)
        raise MoveError, 'That cell is already occupied.' if @grid[row][column]
      end

      def coordinates_for(cell)
        # Converts a cell number (1-9) to a [row, column] pair (0-indexed).
        row = (cell - 1) / 3
        column = (cell - 1) % 3
        [row, column]
      end
    end
  end
end
