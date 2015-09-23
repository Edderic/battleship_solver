# Battleship::Table is designed to only take ships with specified orientation.
# This means that ships must be either a Battleship::HorizontalShip, or a
# Battleship::VerticalShip.
#
# To sink something, the sink pairs must passed in the initialize,
# and then it needs to be called after the initialize

module Battleship
  class Table
    include Battleship::TableHelper
    include Enumerable

    def sunk_ships
      @ships.select {|ship| ship.sunk? }
    end

    def add_fully_sunk_ship!(ship)
      @fully_sunk_ships << Battleship::FullySunkShip.new(ship)
    end

    def num_times_matching_sink_pair
      if sink_pairs.empty?
        return 0
      end

      # TODO: consider cases when there are more than one sink pairs to sink
      sink_pair = sink_pairs.first

      sink_pair.num_times_matching_sink_pair
    end

    def sink!(sink_pair)
      sink_pair.sink!
    end

    def rel_freqs
      abs_freq!

      super
    end

    def sum_of_abs_freqs
      self.inject(0) {|accum, point| accum = accum + point.abs_freq }
    end

    def abs_freq!
      calculate_across_all_points!(unsunk_ships, 0) do
        unsunk_ships.each do |ship|
          debug("ship.abs_freq!") do
            ship.abs_freq! { @num_total_configurations += 1 / unsunk_ships.count.to_f }
          end
        end
      end
    end

    def ships_to_be_fully_sunk
      ships.select do |ship|
        ship.unsunk? || ship.ambiguous_sunk?
      end
    end

    private

    def valid?
      unsunk_ships.all? {|ship| ship.occupies_valid_points?} &&
        @hits.all? { |hit| hit.table = self; hit.on_an_unsunk_ship?  } &&
        @sink_pairs.all? {|sink_pair| sink_pair.valid?  }
    end


    def unsunk_ships_of_specified_length(length)
      unsunk_ships.select {|ship| ship.length == length}
    end
  end
end
