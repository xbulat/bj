# frozen_string_literal: true
class Bank
  attr_accessor :money

  def initialize(money = 0)
    @money = money.to_i
  end

  def add_money(m)
    self.money += m
  end

  def take_money(m)
    self.money -= m if (money - m) >= 0
  end
end
