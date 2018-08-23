# frozen_string_literal: true
require_relative 'lib/bank.rb'
require_relative 'lib/cards.rb'
require_relative 'lib/player.rb'
require_relative 'lib/table.rb'

def gets_user_input(greeting)
  begin
    puts greeting
    input = gets.chomp!
  end while input.empty?
  input
end

Player.new(gets_user_input('Please enter your name'))
#Player.new('Alex')
Player.new('Diller')

t = Table.new(Player.all)

pry.binding
