# frozen_string_literal: true
require_relative 'lib/bank.rb'
require_relative 'lib/cards.rb'
require_relative 'lib/player.rb'
require_relative 'lib/table.rb'
require 'io/console'

class Main

  attr_reader :user, :diller, :table

  MAIN_MENU =
    { banner: 'BlackJack Game.',
      items: {
        '1': { item: 'Pass turn', cmd: 'pass_turn' },
        '2': { item: 'Take Card', cmd: 'take_card' },
        '3': { item: 'Show Cards', cmd: 'show_cards' },
      } }.freeze

  DEFAULT_ITEMS =
    { "\u0003": { cmd: 'buy' }, 'nf': { cmd: 'not_found' } }.freeze

  def initialize
  #user_name = gets_user_input('Please enter your name')
  #user = Player.new(user_name)
    @user = Player.new('Alex')
    @diller = Player.new('Diller')
    @table = Table.new(Player.all)
  end

  def welcome
    display_menu(MAIN_MENU)
  end

  def game_status
    format('You bank: %d, Score: %d, GameBank: %d', user.bank.money, user.score, table.bank.money)
  end

  def cards_status(hide = true)
    "Your cards: #{table.player_cards(user)}, Diller cards: #{table.player_cards(diller, hide)}"
  end

  def game_result

  end

  def show_cards
    header_greeting("Show cards. Game results.")
    puts cards_status(false)
    puts game_status
    puts game_result
  end

  private

  def display_menu(items)
    header_greeting(items[:banner])
    puts cards_status
    blank_line
    items[:items].each { |k, v| puts "#{k}) #{v[:item]}" }
    blank_line
    puts game_status
    blank_line
    loop { menu_selector(items) }
  end

  def menu_selector(items)
    c = read_char
    items = DEFAULT_ITEMS.merge(items[:items])
    cmd = items.fetch(c.to_sym).fetch(:cmd)
    case cmd
    when 'take_card'
      table.method(cmd).call(user)
      table.update_score
      clear
      welcome
    when 'pass_turn'
      table.method(cmd).call(diller)
      table.update_score
      clear
      welcome
    when 'show_cards'
      clear
      method(cmd).call
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

  def not_found
    puts 'CMD not found'
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

  def exit_greeting
    puts 'CTRL+C to Exit'
  end
end

Main.new.welcome
