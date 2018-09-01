# frozen_string_literal: true
class Hand
  attr_accessor :score, :hide
  attr_reader :cards

  def initialize
    @cards = []
    @score = 0
    @hide = true
  end

  def cards=(card)
    cards << card if cards.size < 3
    update_score
  end

  def show_cards
    hide ? [].fill('🂠', 0..(cards.size - 1)).join(' ') : cards.join(' ')
  end

  def unhide_cards
    self.hide = false
  end

  private

  def card
    @card ||= Card.new
  end

  def update_score(values = [])
    card.value(cards) { |card| values << card }

    if values.include?(nil) && values.size == 1 # A
      values.compact! << 11
    elsif values.include?(nil) && values.compact.size.zero? # A & A
      values.compact! << 22
    elsif values.include?(nil) && values.compact.size.nonzero? # A & any
      values.compact! << (values.compact.inject(&:+) >= 11 ? 1 : 11)
    end
    self.score = values.inject(&:+)
  end
end
