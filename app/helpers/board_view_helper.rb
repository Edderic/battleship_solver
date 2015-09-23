module BoardViewHelper
  class Board
    def initialize(board)
      @board = board
      @best_targets = board.best_targets
      @max_abs_freq = @best_targets.first.abs_freq
    end

    def background_color_at(row,col)
      point = Battleship::Point.new(row: row, col: col)
      bgc_point = BoardViewHelper::BackgroundColor.new(point, @board, @max_abs_freq)
      "rgb(#{bgc_point.red}, #{bgc_point.green}, #{bgc_point.blue});"
    end

    def status_at(row,col)
      point = @board.point_at(row,col)
      if point.sunk?
        "sunk"
      elsif point.hit?
        "hit"
      elsif point.missed?
        "missed"
      else
        "untried"
      end
    end

    def target_at(row,col)
      point = @board.point_at(row,col)
      point.abs_freq == @max_abs_freq
    end
  end

  class BackgroundColor
    def initialize(point, board, max_abs_freq)
      @point = point
      @board = board
      @max_abs_freq = max_abs_freq
    end

    def normalized_freq
      freq = @board.point_at(@point).abs_freq
      freq.to_f / @max_abs_freq
    end

    def red
      (-255.0*(normalized_freq) + 255).to_i
    end

    def green
      (-255.0*(normalized_freq) + 255).to_i
    end

    def blue
      (-255.0*(normalized_freq) + 255).to_i
    end
  end
end
