class Card
  attr_reader :suit, :value

  def initialize(card)
    @suit = card
    @value = fetch_value(card)
  end

  private

  def fetch_value(card)
    values = { '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9,
               '10': 10, K: 10, Q: 10, J: 10, A: nil }.freeze
    values.fetch(card.match(/\w+/)[0].to_sym)
  end
end
