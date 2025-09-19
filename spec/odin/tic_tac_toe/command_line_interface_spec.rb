# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Odin::TicTacToe::CommandLineInterface do
  let(:cli) { described_class.new }
  let(:output) { StringIO.new }

  before do
    # Redirect standard output to a StringIO object to capture it
    $stdout = output
    # Stub `gets` to simulate user input
    allow(cli).to receive(:gets)
  end

  after do
    # Restore standard output after each test
    $stdout = STDOUT
  end

  describe '#run' do
    subject(:run_cli) { cli.run }

    context "when a game is won by player 'X'" do
      before do
        # Simulate the exact sequence of user inputs for a 5-move game win
        allow(cli).to receive(:gets).and_return("1\n", "4\n", "2\n", "5\n", "3\n")
      end

      it 'plays a full game until a winner is declared' do
        run_cli
        expect(output.string).to include('GAME OVER: Player X won!')
      end

      it 'shows the correct prompts and board states' do
        run_cli
        full_output = output.string

        # Check that the initial banner and empty board are displayed
        expect(full_output).to include("Let's Play Tic Tac Toe")
        expect(full_output).to include(<<~BOARD)
          +---+---+---+
          | 1 | 2 | 3 |
          +---+---+---+
          | 4 | 5 | 6 |
          +---+---+---+
          | 7 | 8 | 9 |
          +---+---+---+
        BOARD

        # Check that the prompts for both players appeared
        expect(full_output).to include('Player X, enter a move (1-9):')
        expect(full_output).to include('Player O, enter a move (1-9):')

        # Check that the final board state is printed correctly
        expect(full_output).to include(<<~BOARD)
          +---+---+---+
          | X | X | X |
          +---+---+---+
          | O | O | 6 |
          +---+---+---+
          | 7 | 8 | 9 |
          +---+---+---+
        BOARD
      end
    end

    context 'when the game ends in a tie' do
      before do
        # Simulate a full 9-move game resulting in a tie
        inputs = %w[1 5 2 3 7 4 6 8 9].map { |move| "#{move}\n" }
        allow(cli).to receive(:gets).and_return(*inputs)
      end

      it 'prints the tie game message' do
        run_cli
        expect(output.string).to include('GAME OVER: Tie game! Try again.')
      end
    end

    context 'when an invalid move is entered' do
      before do
        # Simulate player O entering an occupied cell (1), then a valid cell (2),
        # followed by the rest of the moves for a quick game.
        inputs = %w[1 1 2 4 3 7].map { |move| "#{move}\n" }
        allow(cli).to receive(:gets).and_return(*inputs)
      end

      it 'prints an error message and re-prompts the same player' do
        run_cli

        # Verify the error message
        expect(output.string).to include("Move '1' is not valid: That cell is already occupied.")
        expect(output.string).to include("Try again\n\n")

        # By checking the sequence of prompts, we can verify the same player was re-prompted.
        # Player O should be prompted twice in a row for their first move.
        prompts = output.string.scan(/Player \w, enter a move/)
        expect(prompts).to eq(
          [
            'Player X, enter a move',
            'Player O, enter a move',
            'Player O, enter a move',
            'Player X, enter a move',
            'Player O, enter a move',
            'Player X, enter a move'
          ]
        )
      end
    end
  end
end
