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
      subject
      expect(subject.board.to_s).to eq(<<~BOARD.chomp)
        +---+---+---+
        | 1 | 2 | 3 |
        +---+---+---+
        | 4 | 5 | 6 |
        +---+---+---+
        | 7 | 8 | 9 |
        +---+---+---+
      BOARD
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
          expect(game.board.to_s).to eq(<<~BOARD.chomp)
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
          expect(game.board.to_s).to eq(<<~BOARD.chomp)
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
          expect(game.board.to_s).to eq(<<~BOARD.chomp)
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
          expect(game.board.to_s).to eq(<<~BOARD.chomp)
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

  describe '#over?' do
    subject { game.over? }

    context 'game has not ended in a tie and no one has won' do
      it { is_expected.to eq(false) }
    end

    context 'game ended in a tie' do
      before { [1, 3, 2, 4, 6, 5, 7, 9, 8].each { |cell| game.move(cell) } }
      it { is_expected.to eq(true) }
    end

    context 'player X has won' do
      before { [1, 4, 2, 5, 3].each { |cell| game.move(cell) } }
      it { is_expected.to eq(true) }
    end

    context 'player O has won' do
      before { [4, 1, 5, 2, 7, 3].each { |cell| game.move(cell) } }
      it { is_expected.to eq(true) }
    end
  end

  describe '#winner' do
    subject { game.winner }
    context 'X wins' do
      context 'row 1 win' do
        before { [1, 4, 2, 5, 3].each { |cell| game.move(cell) } }
        it { is_expected.to eq('X') }
      end

      context 'row 2 win' do
        before { [4, 1, 5, 2, 6].each { |cell| game.move(cell) } }
        it { is_expected.to eq('X') }
      end

      context 'row 3 win' do
        before { [7, 4, 8, 5, 9].each { |cell| game.move(cell) } }
        it { is_expected.to eq('X') }
      end

      context 'column 1 win' do
        before { [1, 2, 4, 5, 7].each { |cell| game.move(cell) } }
        it { is_expected.to eq('X') }
      end

      context 'column 2 win' do
        before { [2, 1, 5, 4, 8].each { |cell| game.move(cell) } }
        it { is_expected.to eq('X') }
      end

      context 'column 3 win' do
        before { [3, 1, 6, 4, 9].each { |cell| game.move(cell) } }
        it { is_expected.to eq('X') }
      end

      context 'diagonal north-west win' do
        before { [1, 2, 5, 4, 9].each { |cell| game.move(cell) } }
        it { is_expected.to eq('X') }
      end

      context 'diagonal north-east win' do
        before { [3, 1, 5, 4, 7].each { |cell| game.move(cell) } }
        it { is_expected.to eq('X') }
      end
    end
  end
end
