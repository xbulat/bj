# frozen_string_literal: true
class Table
  attr_accessor :cards, :players, :bank

  BET = 10
  BANK = 100

  def initialize(players)
    @players = players
    @cards = CardDeck.new
    @bank = Bank.new
    ensure_game
    update_score
  end

  def take_card(player)
    player.cards = cards.give_card if player.cards.size < 3
  end

  def make_bet(player)
    player.bank.take_money(BET)
  end

  def pass_turn(player)
    take_card(player) if player.score < 17
  end

  def player_cards(player, hide = false)
    hide ? Array.new(player.cards.size, '🂠').join(" ") : player.cards.join(" ")
  end

  def game_complete?
    each_player { |player| }.map { |player| player.cards }.flatten.size == 6
  end

  #private
  def each_player(&block)
    players.each { |player| yield(player) }
  end

  def update_score
    each_player { |player| player.score = count_score(player.cards) }
  end

  def ensure_game
    each_player do |player|
      2.times { take_card(player) }
      player.bank = Bank.new(BANK) if player.bank.nil?
      bank.add_money(BET) if make_bet(player).positive?
    end
  end

  def card_value(cards, &block)
    values = { '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9,
               '10': 10, K: 10, D: 10, J: 10, T: nil }.freeze

    cards.each { |c| yield(values.fetch(c.match(/\w+/)[0].to_sym)) }
  end

  def count_score(cards)
    values = []
    card_value(cards) { |card| values << card }
    if values.include?(nil)
      values.compact.inject(&:+) >= 11 ? values.compact! << 1 : values.compact! << 11
    end
    values.inject(&:+)
  end

  def buy
    puts 'Buy. Please follow the rules!'
    exit 0
  end

end
