# frozen_string_literal: true

RSpec.describe Odin::TicTacToe::Game do
  let(:game) { described_class.new }

  describe '.new' do
    subject { game }

    it 'should initialize its state correctly' do
      expect(subject).to(
        have_attributes(
          current_player: 'X',
          winner: nil
        )
      )
    end

    it 'should return an empty board' do
      expect(subject).to(
        have_attributes(board: <<~BOARD.chomp)
          +---+---+---+
          | 1 | 2 | 3 |
          +---+---+---+
          | 4 | 5 | 6 |
          +---+---+---+
          | 7 | 8 | 9 |
          +---+---+---+
        BOARD
      )
    end
  end

  describe '#move' do
    subject { game.move(cell) }

    context 'first move' do
      context 'move is not an integer' do
        let(:cell) { 'bad_move' }
        it 'should raise a Odin::TicTacToe::MoveError' do
          expect { subject }.to raise_error(Odin::TicTacToe::MoveError, 'Cell must be an integer between 1 and 9.')
        end
      end

      context 'move is < 1' do
        let(:cell) { 0 }
        it 'should raise a Odin::TicTacToe::MoveError' do
          expect { subject }.to raise_error(Odin::TicTacToe::MoveError, 'Cell must be an integer between 1 and 9.')
        end
      end

      context 'move is > 9' do
        let(:cell) { 10 }
        it 'should raise a Odin::TicTacToe::MoveError' do
          expect { subject }.to raise_error(Odin::TicTacToe::MoveError, 'Cell must be an integer between 1 and 9.')
        end
      end

      context 'move is 1' do
        let(:cell) { 1 }
        it 'should place a token for the current player in the given cell' do
          subject
          expect(game.board).to eq(<<~BOARD.chomp)
            +---+---+---+
            | X | 2 | 3 |
            +---+---+---+
            | 4 | 5 | 6 |
            +---+---+---+
            | 7 | 8 | 9 |
            +---+---+---+
          BOARD
        end
      end

      context 'move is 5' do
        let(:cell) { 5 }
        it 'should place a token for the current player in the given cell' do
          subject
          expect(game.board).to eq(<<~BOARD.chomp)
            +---+---+---+
            | 1 | 2 | 3 |
            +---+---+---+
            | 4 | X | 6 |
            +---+---+---+
            | 7 | 8 | 9 |
            +---+---+---+
          BOARD
        end
      end

      context 'move is 9' do
        let(:cell) { 9 }
        it 'should place a token for the current player in the given cell' do
          subject
          expect(game.board).to eq(<<~BOARD.chomp)
            +---+---+---+
            | 1 | 2 | 3 |
            +---+---+---+
            | 4 | 5 | 6 |
            +---+---+---+
            | 7 | 8 | X |
            +---+---+---+
          BOARD
        end
      end
    end

    context 'second move' do
      # Fist move is to cell 1
      before { game.move(1) }

      context 'move on an occupied cell' do
        let(:cell) { 1 }

        it 'should raise a MoveError' do
          expect { subject }.to raise_error Odin::TicTacToe::MoveError, 'That cell is already occupied.'
        end
      end

      context 'move to an unoccupied cell' do
        let(:cell) { 5 }

        it 'should place a token for the current player the given cell' do
          subject
          expect(game.board).to eq(<<~BOARD.chomp)
            +---+---+---+
            | X | 2 | 3 |
            +---+---+---+
            | 4 | O | 6 |
            +---+---+---+
            | 7 | 8 | 9 |
            +---+---+---+
          BOARD
        end
      end
    end

    context 'winning move' do
      let(:cell) { 3 }

      before do
        game.move(1)
        game.move(4)
        game.move(2)
        game.move(5)
      end

      it 'should not allow any further moves' do
        subject
        expect { game.move(6) }.to raise_error Odin::TicTacToe::MoveError, 'The game has already been won by X!'
      end
    end

    context 'no more moves' do
      let(:cell) { 1 }
      before do
        game.move(1)
        game.move(3)
        game.move(2)
        game.move(4)
        game.move(6)
        game.move(5)
        game.move(7)
        game.move(9)
        game.move(8)
      end

      it 'should not allow any further moves' do
        expect { subject }.to raise_error Odin::TicTacToe::MoveError, 'The game has already ended in a tie.'
      end
    end
  end

  describe '#winner' do
    subject { game.winner }

    context 'when there is no winner' do
      it 'should be nil' do
        expect(subject).to be_nil
      end
    end

    context 'when "X" wins' do
      before do
        game.move(1)
        game.move(4)
        game.move(2)
        game.move(5)
        game.move(3)
      end

      it { is_expected.to eq('X') }
    end

    context 'when "O" wins' do
      before do
        game.move(4)
        game.move(1)
        game.move(5)
        game.move(2)
        game.move(7)
        game.move(3)
      end

      it { is_expected.to eq('O') }
    end
  end

  describe '#who_won' do
  end

  describe '#more_moves?' do
  end
end
