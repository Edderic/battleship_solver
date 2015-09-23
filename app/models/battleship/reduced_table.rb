module Battleship
  class ReducedTable
    extend Forwardable
    include Battleship::TableHelper
    include Enumerable

    attr_reader :row_length,
      :col_length,
      :abs_freqs,
      :num_total_configurations,
      :misses,
      :hits,
      :sunken_points,
      :ships

    def_delegators :@tables_generator,
      :num_total_configurations

    def initialize(tables_generator)
      @tables_generator = tables_generator
      @abs_freqs = tables_generator.abs_freqs
      @row_length = @abs_freqs.length
      @col_length = @abs_freqs[0].length
      @misses = @tables_generator.misses
      @hits = @tables_generator.hits
      @ships = @tables_generator.ships
      @sunken_points = @tables_generator.sunken_points
      @table = rebuild_table

      puts @table
    end

    def rebuild_table
      (1..row_length).map do |row|
        (1..col_length).map do |col|

          point = Battleship::Point.new(row: row, col: col)
          point.abs_freq = abs_freqs[row-1][col-1]

          if misses.include_point?(point)
            point.miss!
          elsif hits.include_point?(point)
            point.hit!
          elsif sunken_points.include_point?(point)
            point.sink!
          end

          point
        end
      end
    end

    def best_targets
      Battleship::PointsDecorator.new( select { |point| point.abs_freq == max_abs_freq })
    end
  end
end
