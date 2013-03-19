require 'yaml'
#REV: nice this code looks really clean
class Map


  def initialize(w)
    @mines = []
    @board = []
    @flags = []
    @won = 0

    case w
      when 9
        set_mines(10,w)
      when 16
        set_mines(40,w)
    end

    p @mines
    setup_board(w)

  end


  def win
    board_clear
    if find_flag_mine_match && @mines.length == @flags.length && board_clear
      @won=1
      puts "You Win!"
    end

    @won
  end


  def board_clear
    @board.each do |row|
      return false if row.include?(:*)
    end

    true
  end


  def find_flag_mine_match
    @mines.each do |mine|
      return false unless @flags.include?(mine)
    end

    true
  end


  def setup_board(w)

    w.times do |i|
      row = []
      w.times do |j|
        row << :*
      end
      @board << row
    end
  end


  def display
    print "\n-----------------------------------------------------------------\n"
    print " "
    col_nums = []
    0.upto(@board.length - 1) {|col_num| col_nums << col_num}
    @board.each_with_index do |row,row_num|
      print "#{row_num}"
      p row

    end
  end

  def set_flag(coord)
    @board[coord[1]][coord[0]] = "F"
    @flags << coord
  end

  def uncover(coord)
    if @mines.include?(coord)
      @won = -1
      return -1
    end
    zero_mine(coord[0],coord[1])
    return 0
  end

  def zero_mine(x,y)
    possible = possible_moves(x,y)
    surrounding = contains_mine(possible)
    if @mines.include?([x,y])
      return
    elsif @board[y][x] != :*

    elsif surrounding != 0
      @board[y][x] = surrounding
    else
      @board[y][x] = :_
      possible.each {|location| zero_mine(location[0],location[1])}
    end
  end

  def set_mines(number_of_mines, w )
    while @mines.length < number_of_mines
      mine_location = [rand(w),rand(w)]
      @mines << mine_location unless @mines.include?(mine_location)
    end
  end



  def possible_moves(x,y)
    w = @board.length
    possible_moves = []
    -1.upto(1) do |i|
      -1.upto(1) do |j|
        possible_moves << [x+i,y+j] if dual_range_check(x+i,y+j)
      end
    end
    possible_moves.delete([x,y])
    possible_moves
  end

  def dual_range_check(x,y)
    return range_check(x) && range_check(y)
  end

  def range_check(num)
    return false unless num.between?(0, @board.length-1)
    return false if num < 0
    true
  end

  def contains_mine(tiles)
    count = 0

    tiles.each do |location|
      count += 1 if @mines.include?(location)
    end
    count
  end

end

class UI

  def initialize(file = nil)

   if file.nil?
      puts "What board size would you like to play 9 or 16"
      option = gets.chomp.to_i

      case option
      when 16
        @map =  Map.new(16)
      else
        @map = Map.new(9)
      end
    else
      @map = YAML.load_file( file )
      @map.display
    end
    @start = Time.now
  end

  def menu
    puts "1: uncover square"
    puts "2: place flag"
    puts "3: save"
    puts "4: view high scores"
  end

  def set_cord
    puts "Enter x cordinates"
    x=gets.chomp.to_i
    puts "Enter y cordinates"
    y=gets.chomp.to_i

    [x,y]
  end


  def sav_game
    serial = @map.to_yaml
    puts "Name your save file"
    file_name = gets.chomp
    f = File.open(file_name, 'w')
    f.write(serial)
    f.close
  end


  def user_input
    option = gets.chomp.to_i
    case option
    when 1
      if @map.uncover(set_cord) == -1
        puts "You lose!"
        exit
      end
    when 2
      @map.set_flag(set_cord)
    when 3
      sav_game
    when 4
      load_high_scores
    else
      puts "Invalid option"
    end
  end

  def load_high_scores
    scores=[]
    scores=File.readlines("highscore")
    system("clear")
    puts scores

  end

  def play

    while @map.win == 0
      @map.board_clear
      system("clear")
      @map.display
      menu
      user_input
    end
    final = Time.now - @start
    puts "#{final.min}:#{final.sec}:#{final.usec} (min/sec/usec)"
  end
end


m = UI.new(ARGV.pop)

m.play

