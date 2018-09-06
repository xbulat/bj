# frozen_string_literal: true
require_relative 'lib/bank.rb'
require_relative 'lib/card_deck.rb'
require_relative 'lib/card.rb'
require_relative 'lib/hand.rb'
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
    @dealer = Player.new('dealer')
  end

  def start_game
    @table = Table.new(@user, @dealer)
  end

  def main_menu
    menu_header('Casion 777. BlackJack Game')
    game_status

    table.game_complete? ? show_game_results : loop { menu_selector }
  end

  def show_game_results
    menu_header('Show cards and Results')
    game_status
    game_results

    continue_or_exit?
  end

  def game_results
    show_players_score
    show_winners
  end

  def game_status
    show_cards_status
    show_game_status
  end
end

Main.new.main_menu
