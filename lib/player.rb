# frozen_string_literal: true
class Player
  @@players = {}
    
  attr_accessor :name, :bank, :cards, :score

  def self.all
    @@players.values
  end

  def self.find(name)
    @@players.fetch(name, nil)
  end

  def initialize(name)
    @name = name
    @cards = []
    @score = 0
    @@players[name] = self
  end

  def bank=(b)
    @bank = b
  end

  def cards=(c)
    self.cards << c
  end
end
