# frozen_string_literal: true
class Player
  @@players = {}

  BANK = 100

  attr_accessor :name, :bank, :hand

  def self.all
    @@players.values
  end

  def self.find(name)
    @@players.fetch(name, nil)
  end

  def initialize(name)
    @name = name.capitalize
    @hand = Hand.new
    @bank = Bank.new(BANK)
    @@players[name] = self
  end
end
