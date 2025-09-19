# Odin::TicTacToe

A tic-tac-toe game on the command line where two human players can play against each
other. This project was created as part of [The Odin Project's
curriculum](https://www.theodinproject.com/lessons/ruby-tic-tac-toe).

* **Executable**: The command-line script can be found at
  [exe/odin-tic-tac-toe](exe/odin-tic-tac-toe).

* **Source Code**: The main library code is located in
  [lib/odin/tic_tac_toe/](lib/odin/tic_tac_toe/).

  * **CommandLineInterface**: The main entry point for the command line script is the
    [Odin::TicTacToe::CommandLineInterface](lib/odin/tic_tac_toe/command_line_interface.rb)
    class. This class is the interface between the user and the
    [Odin::TicTacToe::Game](lib/odin/tic_tac_toe/game.rb) class.

  * **Game**: The Game class implements the main logic for playing the Tic Tac Toe
    game. Game objects hold a [Odin::TicTacToe::Game](lib/odin/tic_tac_toe/board.rb)
    object to keep track of the board state.

  * **Board**: The Board class keeps the state for the Tic Tac Toe board and knows
    how to determine if the board is full or if there is a winner.

* **Tests**: The project includes a full RSpec test suite with 100% branch coverage,
  which can be found in [spec/odin/tic_tac_toe/](spec/odin/tic_tac_toe/).

## Installation

**NOTE** This project is a demonstration only and its gem has not been published to
rubygems.org.

To install the odin-tic_tac_toe gem, clone the project, run `bin/setup` and then
install the project gem locally:

```shell
git clone https://github.com/jcouball/odin-tic_tac_toe
cd odin-tic_tac_toe
bin/setup
bundle exec rake install
```

## Usage

Once installed, you can run the game using the `odin-tic-tac-toe` command line
script:

```shell
$ odin-tic-tac-toe
Let's Play Tic Tac Toe

+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
Player X, enter a move (1-9):
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake
spec` to run the tests. You can also run `bin/console` for an interactive prompt that
will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/jcouball/odin-tic_tac_toe. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to the
[code of
conduct](https://github.com/jcouball/odin-tic_tac_toe/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the odin-tic_tac_toe project's codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/jcouball/odin-tic_tac_toe/blob/main/CODE_OF_CONDUCT.md).
