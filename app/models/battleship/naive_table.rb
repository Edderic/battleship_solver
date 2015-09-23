class Battleship::NaiveTable
  include Battleship::TableHelper
  include Enumerable

  attr_reader :num_total_configurations

  def abs_freq!
    each do |point|
      unsunk_ships.each do |ship|
        ship.start_at(point)
        ship.naive_abs_freq! { @num_total_configurations += 1}
      end
    end
  end

  def occupied_points_by_sink_pairs
    points = sink_pairs.map do |sink_pair|
      inject([]) do |accum, point|
        sink_pair.start_at(point)
        accum << sink_pair.occupied_points
        accum
      end
    end.flatten

    Battleship::PointsDecorator.new(points)
  end
end
