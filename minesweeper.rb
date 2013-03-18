#mine - 1
class Map


  def initialize(w)
    @mines = []
    case w
      when 9
        set_mines(10,w)
      when 16
        set_mines(40,w)
      end
    setup_board(w)
    @flag = []
    @won = false
  end

  def win?
    @won
  end

  def setup_board(w)
    @board = []
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
    flag << coord
  end

  def uncover(coord)
    if @mines.include?(coord)
      return -1
    end
    zero_mine(coord[0],coord[1])
    return 0
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
        pos = [x+i,y+j] unless (x+i).between?(0,w-1) && (y+j).between?(0,w-1)
        possible_moves << pos
      end
    end
    possible_moves
  end

  def contains_mine(tiles)
    count = 0
    tiles.each do |location|
      count += if @mines.include?(location)
    end
    count
  end

  def zero_mine(x,y)
    possible = possible_moves(x,y)
    surrounding = contains_mine(possible)
    if @mines.include([x,y])
      return
    elsif @board[y][x] != :*
    elsif surrounding != 0
      @board[y][x] = surrounding
    else
      @board[y][x] = :_
      possible.each {|location| zero_mine(location[0],location[1])}
    end
  end


end

class UI

  def initialize()
    puts "What board size would you like to play 9 or 16"
    option = get.chomp.to_i

    case option
    when 16
      @map =  Map.new(16)
    else
      @map = Map.new(9)
    end

  end

  def menu
    puts "1: uncover square"
    puts "2: place flag"
    puts "3: save"
  end

  def set_cord
    puts "Enter x cordinates"
    x=gets.chomp.to_i
    puts "Enter y cordinates"
    y=gets.chomp.to_i

    [x,y]
  end

  def user_input
    option = gets.chomp.to_i


    case option
    when 1
      if uncover(set_cord) == -1
        puts "You lose!"
        exit
      end
    when 2
      set_flag(set_cord)
    when 3
    else
      puts "Invalid option"
    end
  end

  def play

  end

end

m = Map.new(16)
m.display

