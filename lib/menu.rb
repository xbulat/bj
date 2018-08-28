module Menu
  def menu_selector
    cmd = read_char
    case cmd
    when '1'
      table.user_turn
      welcome
    when '2'
      table.diller_turn
      welcome
    when '3'
      show_cards
    when "\u0003"
      buy
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

  def header_greeting(string)
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
    header_greeting("Good luck! Your prize: #{table.user.bank.money}")
    exit 0
  end
end
