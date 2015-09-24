require 'spec_helper'

describe Battleship::VariableSizeBoard do
  describe 'sink 3 ships' do
    it 'should not take that long' do
      ship_1 = Battleship::Ship.new(length: 2)
      ship_2 = Battleship::Ship.new(length: 3)
      ship_3 = Battleship::Ship.new(length: 3)
      ship_4 = Battleship::Ship.new(length: 4)
      ship_5 = Battleship::Ship.new(length: 5)

      ships = [ship_1, ship_2, ship_3, ship_4, ship_5]

      miss_5_5 = Battleship::Point.new(row: 5, col: 5)
      hit_6_6 =  Battleship::Point.new(row: 6, col: 6)
      hit_6_7 =  Battleship::Point.new(row: 6, col: 7)
      miss_6_8 = Battleship::Point.new(row: 6, col: 8)
      miss_7_6 = Battleship::Point.new(row: 7, col: 6)
      miss_5_7 = Battleship::Point.new(row: 5, col: 7)
      sink_point_6_4 = Battleship::Point.new(row: 6, col: 4)
      sink_pair_6_4 = Battleship::SinkPair.new(point: sink_point_6_4, ship_length: 4)
      miss_4_3 = Battleship::Point.new(row: 4, col: 3)
      miss_3_6 = Battleship::Point.new(row: 3, col: 6)
      miss_8_3 = Battleship::Point.new(row: 8, col: 3)
      hit_4_9 = Battleship::Point.new(row: 4, col: 9)
      miss_5_9 = Battleship::Point.new(row: 5, col: 9)
      hit_4_8 = Battleship::Point.new(row: 4, col: 8)
      sink_point_4_7 = Battleship::Point.new(row: 4, col: 7)
      sink_pair_4_7 = Battleship::SinkPair.new(point: sink_point_4_7, ship_length: 3)
      miss_2_4 = Battleship::Point.new(row: 2, col: 4)
      hit_5_2 = Battleship::Point.new(row: 5, col: 2)
      miss_6_2 = Battleship::Point.new(row: 6, col: 2)
      miss_5_1 = Battleship::Point.new(row: 5, col: 1)
      miss_3_2 = Battleship::Point.new(row: 3, col: 2)
      hit_5_3 = Battleship::Point.new(row: 5, col: 3)
      sink_point_5_4 = Battleship::Point.new(row: 5, col: 4)
      sink_pair_5_4 = Battleship::SinkPair.new(point: sink_point_5_4, ship_length: 3)
      miss_9_5 = Battleship::Point.new(row: 9, col: 5)
      miss_1_5 = Battleship::Point.new(row: 1, col: 5)
      miss_6_10 = Battleship::Point.new(row: 6, col: 10)


      # ships = [ship_1, ship_2]
      # ships = [ship_1, ship_2, ship_3]
      # hits = [hit_1, hit_2]
      hits = [
        hit_6_6 ,
        hit_6_7 ,
        hit_4_9 ,
        hit_4_8 ,
        hit_5_2 ,
        hit_5_3
      ]

      misses = [
        miss_5_5,
        miss_6_8,
        miss_7_6,
        miss_5_7,
        miss_4_3,
        miss_3_6,
        miss_8_3,
        miss_5_9,
        miss_2_4,
        miss_6_2,
        miss_5_1,
        miss_3_2,
        miss_9_5,
        miss_1_5,
        miss_6_10
      ]

      sink_pairs = [
        sink_pair_6_4,
        sink_pair_4_7,
        sink_pair_5_4
      ]
      # sink_pair = Battleship::SinkPair.new(point: sink_point,
      # ship_length: 2)

      variable_size_board = Battleship::VariableSizeBoard.new(ships: ships,
                                                              hits: hits,
                                                              sink_pairs: sink_pairs,
                                                              misses: misses,
                                                              row_length: 10,
                                                              col_length: 10)
      # RubyProf.start
      # abs_freqs = variable_size_board.abs_freqs
      # result = RubyProf.stop

      # printer = RubyProf::FlatPrinter.new(result)
      # File.open('graphs/callstack.html', 'w') do |file|
      # printer = RubyProf::CallStackPrinter.new(result)
      # printer.print(file)
      # end

      # require 'stackprof'
      # StackProf.run(mode: :wall, out: 'tmp/stackprof-wall-abs-freqs.dump') do
      # abs_freqs = variable_size_board.abs_freqs
      # end

      abs_freqs = variable_size_board.abs_freqs
      require 'pry'; binding.pry
      puts abs_freqs
      # require 'pry'; binding.pry
      # rel_freqs = variable_size_board.rel_freqs
    end
  end

  describe '#best_targets' do
    it 'should give us [[0,0,0], [2,0,1], [0,2,0]]' do
      ship_1 = Battleship::Ship.new(length: 2)
      ship_2 = Battleship::Ship.new(length: 2)
      hit_1 = Battleship::Point.new(row: 1, col: 1)
      hit_2 = Battleship::Point.new(row: 2, col: 2)
      sink_point = Battleship::Point.new(row: 1, col: 2)
      ships = [ship_1, ship_2]
      hits = [hit_1, hit_2]
      sink_pair = Battleship::SinkPair.new(point: sink_point,
                                           ship_length: 2)
      sink_pairs = [sink_pair]
      variable_size_board = Battleship::VariableSizeBoard.new(ships: ships,
                                                              hits: hits,
                                                              sink_pairs: sink_pairs,
                                                              row_length: 3,
                                                              col_length: 3)
      abs_freqs = variable_size_board.abs_freqs
      rel_freqs = variable_size_board.rel_freqs

      expect(abs_freqs).to eq [[0,0,0], [2,0,1], [0,2,0]]
      expect(rel_freqs).to eq [[0,0,0], [0.4,0,0.2], [0,0.4,0]]
      expect(variable_size_board.num_total_configurations).to eq 5
      expect(variable_size_board.best_targets.count).to eq 2
      expect(variable_size_board.best_targets.any? do |pt|
        pt.has_coords?(2,1)
      end).to eq true

      expect(variable_size_board.best_targets.any? do |pt|
        pt.has_coords?(3,2)
      end).to eq true
    end
  end
end
