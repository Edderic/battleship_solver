# Generates all the possible combinations of ships
# HorizontalShips will not be converted to VerticalShips, and vice versa
# Ships will be converted to both horizontal and vertical ships

module Battleship
  class TablesGenerator
    attr_reader :tables, :misses, :hits, :sink_pairs, :row_length, :col_length, :ships, :sunken_points
    def initialize(hash)
      @ships = hash.fetch(:ships) {Battleship::PointsDecorator.new([])}
      @misses = hash.fetch(:misses) {Battleship::PointsDecorator.new([])}
      @hits = hash.fetch(:hits) {Battleship::PointsDecorator.new([])}
      @sink_pairs = hash.fetch(:sink_pairs) {Battleship::PointsDecorator.new([])}
      @row_length = hash.fetch(:row_length)
      @col_length = hash.fetch(:col_length)
      @sunken_points = hash.fetch(:sunken_points) {Battleship::PointsDecorator.new([])}

      @sink_pairs.each do |sink_pair|
        sink_pair.tables_generator = self

        # this should be done by HasbroBoard
        # sink_pair.sink!
      end

      @tables = reinitialize_tables
    end

    def best_targets
      Battleship::ReducedTable.new(abs_freqs, num_total_configurations).best_targets
    end

    def ships_combinations
      # combine(0, [], [])
      horizontal_ships | vertical_ships
    end

    def num_times_matching_sink_pair
      tables.inject(0) do |count, table|
        count = count + table.num_times_matching_sink_pair
      end
    end

    def reinitialize_tables
      ships_combinations.map do |ships_combo|
        table = Battleship::NaiveTable.new(row_length: row_length,
                                      col_length: col_length,
                                      ships: Array(ships_combo),
                                      sunken_points: sunken_points,
                                      sink_pairs: cloned_sink_pairs,
                                      misses: misses,
                                      hits: hits)
        table
      end
    end

    def abs_freqs
      count = 0

      @tables.each do |table|
        table.abs_freq!
      end

      reshape(sum_one_dim(points_in_one_dim {|point| point.abs_freq}))
    end

    def num_total_configurations
      tables.inject(0) do |count, table|
        count = count + table.num_total_configurations
      end
    end

    def occupied_points_by_sink_pairs
      tables.inject([]) do |accum, table|
        occupied_points = table.occupied_points_by_sink_pairs
        if occupied_points.any?
          accum = accum | occupied_points
        else
          accum
        end
      end
    end

    def find_best_start_point_sunk_ship(sink_pair)
      # is sink pair
      ship.occupies_point?(sunk_point) && ship.occupies_
      # goal: when there is a sink event, we need to know which hit points
      # should be converted to sunken_points, and we should also know which
      # ones should stay as hit points
      #
      # associated ship covers all hit points except the sink point.
      # covers sink point
      sink_pair.sinkable_at_starting_point?(starting_point)
      sink_pair.occupied_points
    end

    private

    # maybe better to use ruby NMatrix library
    # converts rows into one row
    def points_in_one_dim(&block)
      @tables.map do |table|
        table.map do |point|
          yield point
        end
      end
    end

    # TODO: what is the purpose of this?
    def filtered_tables
      if num_times_matching_sink_pair == 1
        tables.select {|table| table.num_times_matching_sink_pair == 1}
      elsif num_times_matching_sink_pair == 0 && sink_pairs.empty?
        null_table = Battleship::Table.new(row_length: row_length,
                                           col_length: col_length,
                                           ships: [])
        def null_table.num_total_configurations
          0
        end
        [null_table]
      else
        tables
      end
    end

    # converts back to 2-d
    def reshape(one_dim)
      (0...row_length).inject([]) do |rows, row_index|
        start_index = row_index * col_length
        end_index = (row_index+1) * col_length
        range = (start_index)...(end_index)
        rows << one_dim[range]
      end
    end

    def sum_one_dim(one_dim)
      one_dim.inject do |sum, row|
        (0...row.length).to_a.each do |index|
          sum[index] = sum[index] + row[index]
        end

        sum
      end
    end

    def combine(ship_index, combinations, combination)
      if ship_index >= @ships.length
        combinations << combination.clone
        return combinations
      end

      combine(ship_index + 1, combinations, ship(ship_index, :to_horizontal, combination))
      combine(ship_index + 1, combinations, ship(ship_index, :to_vertical, combination))
      combinations
    end

    def ship(ship_index, orientation, combination)
      ship = @ships[ship_index].clone
      new_combo = combination.clone << ship.send(orientation)
      new_combo.map {|a_ship| a_ship.clone}
    end

    def cloned_sink_pairs
      @sink_pairs.map do |sink_pair|
        sink_pair.clone
      end
    end

    private

    def horizontal_ships
      @ships.map {|ship| ship.to_horizontal}
    end

    def vertical_ships
      @ships.map {|ship| ship.to_vertical}
    end

  end
end
