module Menu
  def continue_game_menu
    if gets_user_input('Would you like to continue game? (Y/N)') =~ /y/i
      start_game
      main_menu
    else
      bye
    end
  end

  def continue_or_exit?
    table.enought_money? ? continue_game_menu : bye
  end

  def show_game_status
    puts "Money: #{table.user.bank.money}$, Score: #{table.user.hand.score}, GameStake: #{table.bank.money}$"
    blank_line
  end

  def show_winners
    if table.winners.any?
      puts "The Winner of the game: #{table.winners.map(&:name).join(', ')}"
      puts "Winner is getting #{table.bank.money / table.winners.size}$"
      puts 'Congratulation!'
    else
      puts 'No winners, our Casino will get all money.'
    end
  end

  def show_players_score
    table.players.map { |w| puts "Name: #{w.name}, Score: #{w.hand.score}" }
  end

  def show_cards_status
    puts '------------------- TABLE ----------------------'
    puts "       You: #{table.user_cards}   |  Dealer: #{table.dealer_cards}"
    puts '------------------------------------------------'
  end

  def show_menu_items
    puts '1) Take Card'
    puts '2) Take Pass'
    puts '3) Showdown'
  end

  def menu_selector
    show_menu_items

    cmd = read_char
    case cmd
    when '1'
      table.user_turn
      main_menu
    when '2'
      table.dealer_turn
      main_menu
    when '3'
      table.game_over!
      show_game_results
    when "\u0003"
      bye
    else
      not_found
    end
  end

  def read_char
    state = `stty -g`
    begin
      `stty raw -echo cbreak`
      $stdin.getc
    ensure
      `stty #{state}`
    end
  end

  def clear
    system 'clear'
  end

  def blank_line
    puts
  end

  def gets_user_input(greeting)
    begin
      puts greeting
      input = gets.chomp!
    end while input.empty?
    input
  end

  def menu_header(string)
    clear
    puts '================================================'
    puts string.to_s
    puts '================================================'
    blank_line
  end

  def not_found
    puts 'command not found'
  end

  def bye
    menu_header("Good luck! Your prize: #{table.user.bank.money}")
    exit 0
  end
end
