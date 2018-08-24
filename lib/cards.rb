# frozen_string_literal: true
class CardDeck
  attr_reader :deck

  def initialize
    @deck = []
    shuffle_deck
  end

  def give_card
    deck.pop
  end

  private

  attr_writer :deck

  def shuffle_deck
    %w(♠ ♥ ♣ ♦).each do |m|
      (2..10).each { |s| deck << s.to_s+m }
      %w(K D J T).each { |s| deck << s.to_s+m }
    end
    deck.shuffle!
  end
end
