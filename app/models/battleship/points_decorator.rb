class Battleship::PointsDecorator < SimpleDelegator
  def include_point?(*args)
    if args.length == 1
      some_point = args.first
    else
      row = args.first
      col = args[1]
      some_point = Battleship::Point.new(row: row, col: col)
    end

    self.any? {|point| point.has_coords?(some_point.row, some_point.col)}
  end
end
