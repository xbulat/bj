# frozen_string_literal: true
class Table
  attr_reader :user, :dealer, :card_deck, :bank
  attr_accessor :game_over

  BET = 10
  BANK = 100

  def initialize(user, dealer)
    @user   = user
    @dealer = dealer
    @card_deck = CardDeck.new
    @bank = Bank.new
    @game_over = false
    flush_cards
    ensure_game
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

  def valid_scores
    lambda { |player| player.hand.score if player.hand.score < 22 }
  end

  def select_winner
    lambda { |player| player.hand.score < 22 && player.hand.score >= max_score }
  end

  def max_score
    players.collect(&valid_scores).compact.max
  end

  def winners
    max_score.nil? ? [] : players.select(&select_winner)
  end

  def players
    @players ||= Player.all
  end

  private

  attr_writer :cards, :bank

  def return_bets
    winners.each { |player| player.bank.add_money(bank.money / winners.size) } if winners.any?
  end

  def make_bet(player)
    player.bank.take_money(BET)
  end

  def flush_cards
    players.map { |player| player.instance_variable_set(:@hand, Hand.new) }
  end

  def ensure_game
    players.each do |player|
      2.times { player.hand.cards = card_deck.give_card }
      player.bank = Bank.new(BANK) if player.bank.nil?
      bank.add_money(BET) if make_bet(player).positive?
    end
  end
end
