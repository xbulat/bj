# frozen_string_literal: true
require_relative 'lib/bank.rb'
require_relative 'lib/card_deck.rb'
require_relative 'lib/player.rb'
require_relative 'lib/table.rb'
require_relative 'lib/menu.rb'

class Main
  include Menu
  attr_reader :table

  def initialize
    invite_players
    start_game
  end

  def invite_players
    @user   = Player.new(gets_user_input('Introduce yourself'))
    @diller = Player.new('Diller')
  end

  def start_game
    @table = Table.new(@user, @diller)
  end

  def continue_game
    if gets_user_input('Would you like to continue game? (Y/N)') =~ /y/i
      start_game
      welcome
    else
      bye
    end
  end

  def welcome
    header_greeting('Casion 777. BlackJack Game')
    puts cards_status
    puts game_status
    blank_line
    puts '1) Take Card'
    puts '2) Take Pass'
    puts '3) Showdown'
    table.game_complete? ? show_cards : loop { menu_selector }
  end

  def game_status
    "Money: #{table.user.bank.money}$, Score: #{table.user.score}, GameBank: #{table.bank.money}$"
  end

  def cards_status(hide = true)
    puts '------------------- TABLE ----------------------'
    puts "You: #{table.user_cards} |  Diller: #{table.diller_cards(hide)}"
    puts '------------------------------------------------'
  end

  def game_result
    table.players.map { |w| puts "Name: #{w.name}, Score: #{w.score}" }
    if table.winner.any?
      puts "The Winner of the game: #{table.winner.map(&:name).join(', ')}"
      puts "Winner is getting #{table.bank.money / table.winner.size}$"
      puts 'Congratulation!'
    else
      puts 'No winners, our Casino will get all money.'
    end
  end

  def show_cards
    header_greeting('Show cards and Results')
    puts cards_status(false)
    puts game_status
    puts game_result
    table.return_bets
    blank_line
    table.enought_money? ? continue_game : bye
  end
end

Main.new.welcome
