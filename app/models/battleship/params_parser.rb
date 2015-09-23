class Battleship::ParamsParser
  attr_reader :misses, :sunken_points, :hits

  def initialize(params)
    @statuses = params.fetch(:statuses) {[]}
    @sunken_points = []
    @misses = []
    @hits = []
    @statuses.each_with_index do |status, index|
      point = Battleship::Point.new(row: row(index), col: col(index))
      case status
      when 'missed'
        @misses << point
      when 'sunk'
        @sunken_points << point
      when 'hit'
        @hits << point
      end
    end
  end

  def parsed
    { sunken_points: sunken_points, hits: hits, misses: misses }
  end

  private

  def row(index)
    (index / 10) + 1
  end

  def col(index)
    (index % 10) + 1
  end
end
