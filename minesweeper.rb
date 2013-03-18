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

  end

  def setup_board(w)
    @board = []
    1.times(w) do |i|
      row = []
      1.times(w) do |j|
        row << :*
      end
      @board << row
    end
  end

  def display
    print "\n---------------------------------------------------\n"
    print " "

    0.upto(@board.length - 1) {|col_num| print "#{col_num}"}
    print "\n"

    @board.each_with_index do |row,row_num|

    end

  end

  def set_flag(x,y)

  end

  def uncover(x,y)

  end

  def set_mines(number_of_mines, w )

    while @mines.length < number_of_mines
      mine_location = [rand(w),rand(w)]
      @mines << mine_location unless @mines.include?(mine_location)
    end

  end

end



