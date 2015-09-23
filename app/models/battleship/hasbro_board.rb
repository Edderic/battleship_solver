class Battleship::HasbroBoard
  extend Forwardable
  attr_reader :unsunk_ships, :hits, :sunken_points, :misses, :sink_pairs

  def_delegators :reduced_table,
    :abs_freqs,
    :rel_freqs,
    :num_total_configurations,
    :best_targets,
    :point_at

  def initialize(hash={})
    @unsunk_ships = hash.fetch(:unsunk_ships) do
      [
        Battleship::Ship.new(length: 2),
        Battleship::Ship.new(length: 3),
        Battleship::Ship.new(length: 3),
        Battleship::Ship.new(length: 4),
        Battleship::Ship.new(length: 5)
      ]
    end

    @hits = Battleship::PointsDecorator.new(hash.fetch(:hits) {[]})
    @sunken_points = Battleship::PointsDecorator.new(hash.fetch(:sunken_points) {[]})
    @misses = Battleship::PointsDecorator.new(hash.fetch(:misses) {[]})
    @sink_pairs = Battleship::PointsDecorator.new(hash.fetch(:sink_pairs) {[]})
  end

  def col_length
    10
  end

  def row_length
    10
  end

  def reduced_table
    Battleship::ReducedTable.new(tables_generator)
  end

  def tables_generator
    Battleship::TablesGenerator.new(hits: hits,
                                    misses: misses,
                                    ships: unsunk_ships,
                                    sunken_points: sunken_points,
                                    sink_pairs: sink_pairs,
                                    row_length: row_length,
                                    col_length: col_length)
  end

  def hit!(row,col)
    hits << Battleship::Point.new(row: row, col: col)
  end

  def miss!(row,col)
    misses << Battleship::Point.new(row: row, col: col)
  end

  def sink_pair!(row, col, ship_length)
    point = Battleship::Point.new(row: row, col: col)
    sink_pair = Battleship::SinkPair.new(point: point, ship_length: ship_length)
    ship = unsunk_ships.select {|ship| ship.length == ship_length}.first
    @sink_pairs << sink_pair

    tg = Battleship::TablesGenerator.new(hits: hits,
                                         row_length: row_length,
                                         col_length: col_length,
                                         misses: misses,
                                         ships: [ship],
                                         sunken_points: sunken_points,
                                         sink_pairs: @sink_pairs)

    tg.occupied_points_by_sink_pairs.each do |point|
      # require 'pry'; binding.pry
      puts point.to_s
      @hits.reject! {|hit| hit.same_as?(point) }
      sunken_points << point
    end

    @sink_pairs.pop
  end
end
