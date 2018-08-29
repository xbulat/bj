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
    @name = name.capitalize
    @cards = []
    @score = 0
    @@players[name] = self
  end

  def cards=(c)
    @cards << c
  end
end
