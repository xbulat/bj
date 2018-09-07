# frozen_string_literal: true
class Table
  attr_reader :user, :dealer, :card_deck, :bank
  attr_accessor :game_over

  BET = 10
  def initialize(username)
    @user   = Player.new(username)
    @dealer = Player.new('dealer')
    @bank = Bank.new
    create_card_deck
    game
  end

  def enought_money?
    players.map { |player| player.bank.money >= BET }.all?
  end

  def game_complete?
    players.map { |player| player.hand.cards }.flatten.size == 6
  end

  def game_over!
    self.game_over = true
    dealer.hand.unhide_cards
    return_bets
    flush_stack
  end

  def game
    self.game_over = false
    flush_cards
    create_card_deck
    ensure_game
  end

  def user_turn
    user.hand.cards = card_deck.give_card
    game_complete? ? game_over! : dealer_turn
  end

  def dealer_turn
    dealer.hand.cards = card_deck.give_card if dealer.hand.score < 17
    game_over! if game_complete?
  end

  def user_cards
    user.hand.unhide_cards
    user.hand.show_cards
  end

  def dealer_cards
    dealer.hand.show_cards
  end

  def winners
    max_score.nil? ? [] : players.select(&select_winner)
  end

  def players
    @players ||= Player.all
  end

  private

  attr_writer :cards, :bank

  def create_card_deck
    @card_deck = CardDeck.new
  end

  def max_score
    players.collect(&valid_scores).compact.max
  end

  def valid_scores
    ->(player) { player.hand.score if player.hand.score < 22 }
  end

  def select_winner
    ->(player) { player.hand.score < 22 && player.hand.score >= max_score }
  end

  def return_bets
    winners.each { |player| player.bank.add_money(bank.money / winners.size) } if winners.any?
  end

  def make_bet(player)
    player.bank.take_money(BET)
  end

  def flush_cards
    players.map { |player| player.instance_variable_set(:@hand, Hand.new) }
  end

  def flush_stack
    self.bank.money = 0
  end

  def ensure_game
    players.each do |player|
      2.times { player.hand.cards = card_deck.give_card }
      bank.add_money(BET)
      make_bet(player)
    end
  end
end
