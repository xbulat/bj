# frozen_string_literal: true
require_relative 'lib/bank.rb'
require_relative 'lib/cards.rb'
require_relative 'lib/player.rb'
require_relative 'lib/table.rb'
require 'io/console'

class Main
  attr_reader :user, :diller, :table

  def initialize
    invite_players
    start_game
  end

  def invite_players
    @user   = Player.new(gets_user_input('Introduce yourself'))
    @diller = Player.new('Diller')
  end

  def start_game
    @table = Table.new(Player.all)
  end

  def continue_game
    if gets_user_input('Would you like to continue game? (Y/N)') =~ /y/i
      table.flush_cards
      start_game
      welcome
    else
      buy
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
    "Money: #{user.bank.money}$, Score: #{user.score}, GameBank: #{table.bank.money}$"
  end

  def cards_status(hide = true) 
    puts '------------------- TABLE ----------------------'
    puts "You: #{table.player_cards(user)} |  Diller: #{table.player_cards(diller, hide)}"
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
    table.return_bets(table.winner)
    blank_line
    table.enought_money? ? continue_game : buy
  end

  private

  def menu_selector
    cmd = read_char
    case cmd
    when '1'
      table.take_card(user)
      table.pass_turn(diller)
      welcome
    when '2'
      table.pass_turn(diller)
      welcome
    when '3'
      show_cards
    when "\u0003"
      buy
    else
      not_found
    end
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e"
      begin
        input << STDIN.read_nonblock(3)
      rescue
        nil
      end

      begin
        input << STDIN.read_nonblock(2)
      rescue
        nil
      end
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input.to_s
  end

  def clear
    system 'clear'
  end

  def blank_line
    puts
  end

  def gets_user_input(greeting)
    begin
      puts greeting
      input = gets.chomp!
    end while input.empty?
    input
  end

  def header_greeting(string)
    clear
    puts '================================================'
    puts string.to_s
    puts '================================================'
    blank_line
  end

  def not_found
    puts 'command not found'
  end

  def buy
    header_greeting("Good luck! Your prize: #{user.bank.money}")
    exit 0
  end
end

Main.new.welcome
