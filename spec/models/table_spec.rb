require 'spec_helper'

describe Battleship::Table do
  describe '10x10 table with 3 ships' do
    it 'should calculate it' do
      ship_1 = Battleship::HorizontalShip.new(length: 2)
      ship_2 = Battleship::HorizontalShip.new(length: 3)
      ship_3 = Battleship::HorizontalShip.new(length: 3)
      ship_4 = Battleship::HorizontalShip.new(length: 4)
#
      hit_1 = Battleship::Point.new(row: 1, col: 1)
      sink_point = Battleship::Point.new(row: 1, col: 2)
      ships = [ship_1, ship_2, ship_3, ship_4]
      # ships = [ship_1, ship_2]
      hits = [hit_1]
      sink_pair = Battleship::SinkPair.new(point: sink_point,
                                           ship_length: 2)
      sink_pairs = [sink_pair]
      table = Battleship::Table.new(ships: ships,
                                    hits: hits,
                                    sink_pairs: sink_pairs,
                                    row_length: 10,
                                    col_length: 10)
      sink_pair.sink!

      # require 'ruby-prof'
      # RubyProf.start
      # table.abs_freq!
      # result = RubyProf.stop
#
      # printer = RubyProf::FlatPrinter.new(result)
#
      # File.open('graphs/10x10-3-ships.html', 'w') do |file|
        # printer = RubyProf::CallStackPrinter.new(result)
        # printer.print(file)
      # end
      #
      # require 'stackprof'; StackProf.run(mode: :wall, out: 'tmp/10x10-3-ships-table.abs-freq.dump') { table.abs_freq! }
      require 'benchmark'; puts Benchmark.measure {table.abs_freq! }
      # fully_sunk_ship = table.fully_sunk_ships[0]
      # expect(fully_sunk_ship.starting_point.same_as?(hit_1)).to eq true
      # expect(table.fully_sunk_ships.count).to eq 1
    end
  end

  describe '#fully_sunk_ships' do
    it 'should return ships that have all of its occupied points sunk' do
      ship_1 = Battleship::HorizontalShip.new(length: 2)
      ship_2 = Battleship::HorizontalShip.new(length: 3)
      hit_1 = Battleship::Point.new(row: 1, col: 1)
      sink_point = Battleship::Point.new(row: 1, col: 2)
      ships = [ship_1, ship_2]
      hits = [hit_1]
      sink_pair = Battleship::SinkPair.new(point: sink_point,
                                           ship_length: 2)
      sink_pairs = [sink_pair]
      table = Battleship::Table.new(ships: ships,
                                    hits: hits,
                                    sink_pairs: sink_pairs,
                                    row_length: 3,
                                    col_length: 3)
      sink_pair.sink!

      fully_sunk_ship = table.fully_sunk_ships[0]
      expect(fully_sunk_ship.starting_point.same_as?(hit_1)).to eq true
      expect(table.fully_sunk_ships.count).to eq 1
    end
  end

  describe '#ships_to_be_fully_sunk' do
    it 'should give us the unsunk ships and ships that are sunk but ambiguous' do
      ship_1 = Battleship::HorizontalShip.new(length: 2)
      ship_2 = Battleship::HorizontalShip.new(length: 3)
      hit_1 = Battleship::Point.new(row: 1, col: 1)
      hit_2 = Battleship::Point.new(row: 1, col: 3)
      sink_point = Battleship::Point.new(row: 1, col: 2)
      ships = [ship_1, ship_2]
      hits = [hit_1, hit_2]
      sink_pair = Battleship::SinkPair.new(point: sink_point,
                                           ship_length: 2)
      sink_pairs = [sink_pair]
      table = Battleship::Table.new(ships: ships,
                                    hits: hits,
                                    sink_pairs: sink_pairs,
                                    row_length: 3,
                                    col_length: 3)
      expect(table.ships_to_be_fully_sunk[0]).to eq ship_1
      expect(table.ships_to_be_fully_sunk[1]).to eq ship_2

      sink_pair.sink!

      expect(table.ships_to_be_fully_sunk[0]).to eq ship_1
      expect(table.ships_to_be_fully_sunk[1]).to eq ship_2
    end

    it 'should not include sunk ships that are unambiguous' do
      ship_1 = Battleship::HorizontalShip.new(length: 2)
      ship_2 = Battleship::HorizontalShip.new(length: 3)
      hit_1 = Battleship::Point.new(row: 1, col: 1)
      sink_point = Battleship::Point.new(row: 1, col: 2)
      ships = [ship_1, ship_2]
      hits = [hit_1]
      sink_pair = Battleship::SinkPair.new(point: sink_point,
                                           ship_length: 2)
      sink_pairs = [sink_pair]
      table = Battleship::Table.new(ships: ships,
                                    hits: hits,
                                    sink_pairs: sink_pairs,
                                    row_length: 3,
                                    col_length: 3)
      sink_pair.sink!

      expect(table.ships_to_be_fully_sunk[0]).to eq ship_2
      expect(table.ships_to_be_fully_sunk.length).to eq 1
    end
  end

  describe '#to_s' do
    it 'should print the 2D arrangement of  points' do
      ship_1 = Battleship::HorizontalShip.new(length: 2)
      ship_2 = Battleship::HorizontalShip.new(length: 2)
      hit_1 = Battleship::Point.new(row: 1, col: 1)
      hit_2 = Battleship::Point.new(row: 1, col: 3)
      sink_point = Battleship::Point.new(row: 1, col: 2)
      ships = [ship_1, ship_2]
      hits = [hit_1, hit_2]
      sink_pair = Battleship::SinkPair.new(point: sink_point,
                                           ship_length: 2)
      sink_pairs = [sink_pair]
      table = Battleship::Table.new(ships: ships,
                                    hits: hits,
                                    sink_pairs: sink_pairs,
                                    row_length: 3,
                                    col_length: 3)
      expect(table.to_s).to eq "(1,1 | h | 0) (1,2 | u | 0) (1,3 | h | 0)\n" +
        "(2,1 | u | 0) (2,2 | u | 0) (2,3 | u | 0)\n" +
        "(3,1 | u | 0) (3,2 | u | 0) (3,3 | u | 0)\n" +
        "sunk: false: (1,1 | h | 0), (1,2 | u | 0)\n" +
        "sunk: false: (1,1 | h | 0), (1,2 | u | 0)\n"
    end
  end

  describe '#num_times_matching_sink_pair' do
    describe 'when there is more than one ship' do
      describe '2 horizontal ships of length 2, hits:[(1,1), (1,3)], sink_pair: [sink_point(1,2), length:2]' do
        it 'should give [[0,0,0],[0,0,0],[0,0,0]]' do

          ship_1 = Battleship::HorizontalShip.new(length: 2)
          ship_2 = Battleship::HorizontalShip.new(length: 2)
          hit_1 = Battleship::Point.new(row: 1, col: 1)
          hit_2 = Battleship::Point.new(row: 1, col: 3)
          sink_point = Battleship::Point.new(row: 1, col: 2)
          ships = [ship_1, ship_2]
          hits = [hit_1, hit_2]
          sink_pair = Battleship::SinkPair.new(point: sink_point,
                                               ship_length: 2)
          sink_pairs = [sink_pair]
          table = Battleship::Table.new(ships: ships,
                                        hits: hits,
                                        sink_pairs: sink_pairs,
                                        row_length: 3,
                                        col_length: 3)

          abs_freqs = table.abs_freqs
          expect(abs_freqs).to eq [[0,0,0],[0,0,0],[0,0,0]]

          # hit(1,3) is unmatched
          expect(ship_2).not_to be_sunk

          # expect(tables_generator.num_total_configurations).to eq 2
        end
      end


      describe '1 horizontal, 1 vertical ship of length 2, hits:[(1,1), (1,3)], then sink_pair: [sink_point(1,2), length:2]' do
        it 'should give [[0,0,0],[1,0,1],[0,0,0]]' do
          ship_1 = Battleship::HorizontalShip.new(length: 2)
          ship_2 = Battleship::VerticalShip.new(length: 2)
          hit_1 = Battleship::Point.new(row: 1, col: 1)
          hit_2 = Battleship::Point.new(row: 1, col: 3)
          sink_point = Battleship::Point.new(row: 1, col: 2)
          ships = [ship_1, ship_2]
          hits = [hit_1, hit_2]
          sink_pair = Battleship::SinkPair.new(point: sink_point,
                                               ship_length: 2)
          sink_pairs = [sink_pair]
          table = Battleship::Table.new(ships: ships,
                                        hits: hits,
                                        sink_pairs: sink_pairs,
                                        row_length: 3,
                                        col_length: 3)
          sink_pair.sink!
          table.abs_freq!

          abs_freqs = table.abs_freqs
          expect(abs_freqs).to eq [[0,0,0],[1,0,1],[0,0,0]]
        end
      end
    end

    describe 'when there is only one ship' do
      describe 'when there is only one way' do
        it 'should return 1' do
          ship = Battleship::HorizontalShip.new(length: 2)
          ships = [ship]
          misses = []
          hit_1 = Battleship::Point.new(row: 1, col: 1, status: :hit)
          hit_2 = Battleship::Point.new(row: 1, col: 2)

          hits = [hit_1]

          sink_pair = Battleship::SinkPair.new(point: hit_2, ship_length: 2)
          hash = {row_length: 1,
                  col_length: 3,
                  ships: ships,
                  misses: misses,
                  sink_pairs: [sink_pair],
                  hits: hits}
          table = Battleship::Table.new(hash)

          expect(table.num_times_matching_sink_pair).to eq 1
        end
      end
    end
  end

  describe '#sink!(point, ship_length)' do
    describe 'when there are no ambiguities' do
      it 'sinks the points occupied by the ship that was just sunk' do
        ship = Battleship::HorizontalShip.new(length: 2)
        ships = [ship]
        misses = []
        hit_1 = Battleship::Point.new(row: 1, col: 1, status: :hit)
        hit_2 = Battleship::Point.new(row: 1, col: 2)
        sink_pair = Battleship::SinkPair.new(point: hit_2,
                                             ship_length: 2)
        sink_pairs = [sink_pair]

        hits = [hit_1]
        hash = {row_length: 1,
                col_length: 3,
                ships: ships,
                misses: misses,
                sink_pairs: sink_pairs,
                hits: hits}
        table = Battleship::Table.new(hash)

        sink_pair.sink!

        expect(table.point_at(hit_1)).to be_sunk
        expect(table.point_at(hit_2)).to be_sunk
      end
    end
  end

  describe '#rows' do
    it 'should return the rows' do
      ships = []
      misses = []
      hash = {row_length: 2, col_length: 1, ships: ships, misses: misses}
      table = Battleship::Table.new(hash)
      table.recreate!
      expect(table.rows[0][0].row).to eq 1
      expect(table.rows[0][0].col).to eq 1

      expect(table.rows[1][0].row).to eq 2
      expect(table.rows[1][0].col).to eq 1
    end
  end

  describe '#point_at' do
    it 'returns an off-the-table point if point is not on the table' do
      ships = []
      misses = []
      hash = {col_length: 10, row_length: 1, ships: ships, misses: misses}
      table = Battleship::Table.new(hash)
      off_table_point = table.point_at(10,10)

      expect(off_table_point).to be_off_table
    end
  end

  describe '#rel_freqs' do
    describe 'table is 1x3' do
      describe '1 ship of length 3' do
        it 'should return [1,1,1]' do
          ship = Battleship::HorizontalShip.new(length: 3)
          ships = [ship]
          table = Battleship::Table.new(row_length: 1,
                                        col_length: 3,
                                        misses: [],
                                        ships: ships)
          expect(table.rel_freqs.first).to eq [1,1,1]
        end
      end
    end

    describe 'table is 1x4' do
      describe '1 ship of length 3' do
        it 'should return [0.5, 1, 1, 0.5]' do
          ship = Battleship::HorizontalShip.new(length: 3)
          ships = [ship]
          table = Battleship::Table.new(row_length: 1,
                                        col_length: 4,
                                        misses: [],
                                        ships: ships)
          expect(table.rel_freqs.first).to eq [0.5,1,1,0.5]
        end
      end
    end
  end

  describe '#abs_freq!' do
    describe '1x6 board' do
      describe '3 ships of length 2' do
        it 'should give each point an absolute freq of 6' do
          misses = []
          first_ship_length_2 = Battleship::HorizontalShip.new(length: 2)
          second_ship_length_2 = Battleship::HorizontalShip.new(length: 2)
          third_ship_length_2 = Battleship::HorizontalShip.new(length: 2)

          ships = [first_ship_length_2, second_ship_length_2, third_ship_length_2]
          hash = {col_length: 6, row_length: 1, ships: ships, misses: misses}

          table = Battleship::Table.new(hash)
          table.abs_freq!

          first_row_abs_freqs = table.abs_freqs.first
          expect(first_row_abs_freqs).to eq [6,6,6,6,6,6]
        end

        # |a|a|a|b|b| |
        # | | |h|S|h| |
        # |1|1|0|0|0| |
        #
        describe 'sink point has two hit points next to it' do
          describe 'but the sinking is not ambiguous' do
            it 'should give [1,1,0,0,0,0]' do
              misses = []
              hit_1_3 = Battleship::Point.new(row: 1, col: 3)
              hit_1_5 = Battleship::Point.new(row: 1, col: 5)
              sink_1_4 = Battleship::Point.new(row: 1, col: 4)
              sink_pair = Battleship::SinkPair.new(point: sink_1_4,
                                                   ship_length: 2)

              hits = [hit_1_3, hit_1_5]
              sink_pairs = [sink_pair]

              ship_length_2 = Battleship::HorizontalShip.new(length: 2)
              ship_length_3 = Battleship::HorizontalShip.new(length: 3)

              ships = [ship_length_2, ship_length_3]
              hash = {col_length: 6,
                      row_length: 1,
                      ships: ships,
                      misses: misses,
                      hits: hits,
                      sink_pairs: sink_pairs
              }

              table = Battleship::Table.new(hash)
              sink_pair.sink!

              table.abs_freq!

              first_row_abs_freqs = table.abs_freqs.first

              expect(first_row_abs_freqs).to eq [1,1,0,0,0,0]
            end
          end
        end
      end
    end

    describe '1x10 board' do
      describe 'ship at (1,3), (1,4), (1,5) and ship at (1,6) and (1,7)' do
        describe 'hits at (1,5) and (1,7) and sink at (1,6)' do
          it 'should give us [0,0,1,1,0,0,0,1,1,0]' do
            ship_1 = Battleship::HorizontalShip.new(length: 3)
            ship_2 = Battleship::HorizontalShip.new(length: 2)
            hit_1_5 = Battleship::Point.new(row: 1, col: 5)
            hit_1_7 = Battleship::Point.new(row: 1, col: 7)
            sink_1_6 = Battleship::Point.new(row: 1, col: 6)
            sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                                 ship_length: 2)
            sink_pairs = [sink_pair]
            ships = [ship_1, ship_2]
            hits = [hit_1_5, hit_1_7]
            table = Battleship::Table.new(col_length: 10,
                                          row_length: 1,
                                          ships: ships,
                                          hits: hits,
                                          sink_pairs: sink_pairs)
            table.sink!(sink_pair)
            table.abs_freq!

            first_row_abs_freqs = table.abs_freqs.first
            # expect(table.sunk_ships).to include(ship_2)
            expect(first_row_abs_freqs).to eq [0,0,1,1,0,0,0,1,1,0]
          end

          describe 'user hits (1,4)' do
            it 'abs freqs should be [0,0,1,0,0,0,0,0,0,0]' do
              ship_1 = Battleship::HorizontalShip.new(length: 3)
              ship_2 = Battleship::HorizontalShip.new(length: 2)
              hit_1_4 = Battleship::Point.new(row: 1, col: 4)
              hit_1_5 = Battleship::Point.new(row: 1, col: 5)
              hit_1_7 = Battleship::Point.new(row: 1, col: 7)
              sink_1_6 = Battleship::Point.new(row: 1, col: 6)
              sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                                   ship_length: 2)
              sink_pairs = [sink_pair]
              ships = [ship_1, ship_2]
              hits = [hit_1_4, hit_1_5, hit_1_7]
              table = Battleship::Table.new(col_length: 10,
                                            row_length: 1,
                                            ships: ships,
                                            hits: hits,
                                            sink_pairs: sink_pairs)
              table.sink!(sink_pair)
              table.abs_freq!

              first_row_abs_freqs = table.abs_freqs.first
              # expect(table.sunk_ships).to include(ship_2)
              expect(first_row_abs_freqs).to eq [0,0,1,0,0,0,0,0,0,0]
            end
          end
        end
      end

      describe '5-length horizontal ship on (1,5) -> (1,10)' do
        it 'should give us [1,2,3,4,5,5,4,3,2,1]' do
          ship = Battleship::HorizontalShip.new(length: 5)
          ships = [ship]
          table = Battleship::Table.new(col_length: 10,
                                        row_length: 1,
                                        ships: ships)
          table.abs_freq!

          first_row_abs_freqs = table.abs_freqs.first
          expect(first_row_abs_freqs).to eq [1,2,3,4,5,5,4,3,2,1]
        end

        describe 'user misses at (1,5)' do
          it 'should give us [0,0,0,0,0,1,1,1,1,1]' do
            ship = Battleship::HorizontalShip.new(length: 5)
            miss = Battleship::Point.new(row: 1, col: 5)
            ships = [ship]
            misses = [miss]
            table = Battleship::Table.new(col_length: 10,
                                          row_length: 1,
                                          ships: ships,
                                          misses: misses)
            table.abs_freq!

            first_row_abs_freqs = table.abs_freqs.first
            expect(first_row_abs_freqs).to eq [0,0,0,0,0,1,1,1,1,1]
          end
        end

        describe 'user hits (1,6)' do
          it 'should give us [0,1,2,3,4,0,4,3,2,1]' do
            ship = Battleship::HorizontalShip.new(length: 5)
            hit_1_6 = Battleship::Point.new(row: 1, col: 6)
            ships = [ship]
            hits = [hit_1_6]
            misses = []
            table = Battleship::Table.new(col_length: 10,
                                          row_length: 1,
                                          ships: ships,
                                          hits: hits)

            table.abs_freq!

            first_row_abs_freqs = table.abs_freqs.first
            expect(first_row_abs_freqs).to eq [0,1,2,3,4,0,4,3,2,1]
          end

          describe 'user hits (1,7)' do
            it 'should give us [0,0,1,2,3,0,0,3,2,1]' do
              ship = Battleship::HorizontalShip.new(length: 5)
              hit_1_6 = Battleship::Point.new(row: 1, col: 6)
              hit_1_7 = Battleship::Point.new(row: 1, col: 7)
              ships = [ship]
              hits = [hit_1_6, hit_1_7]
              table = Battleship::Table.new(col_length: 10,
                                            row_length: 1,
                                            ships: ships,
                                            hits: hits)

              table.abs_freq!

              first_row_abs_freqs = table.abs_freqs.first
              expect(first_row_abs_freqs).to eq [0,0,1,2,3,0,0,3,2,1]
            end

            describe 'user nails all of the points and sinks the ship' do
              it 'should give abs_freqs of 0s all over' do
                ship = Battleship::HorizontalShip.new(length: 5)
                hit_1_6 = Battleship::Point.new(row: 1, col: 6)
                hit_1_7 = Battleship::Point.new(row: 1, col: 7)
                hit_1_8 = Battleship::Point.new(row: 1, col: 8)
                hit_1_9 = Battleship::Point.new(row: 1, col: 9)
                sink_1_10 = Battleship::Point.new(row: 1, col: 10)
                ships = [ship]
                hits = [hit_1_6, hit_1_7, hit_1_8, hit_1_9]
                sink_pair = Battleship::SinkPair.new(point: sink_1_10,
                                                     ship_length: 5)
                sink_pairs = [sink_pair]
                table = Battleship::Table.new(col_length: 10,
                                              row_length: 1,
                                              ships: ships,
                                              hits: hits,
                                              sink_pairs: sink_pairs)
                sink_pair.sink!

                table.abs_freq!

                first_row_abs_freqs = table.abs_freqs.first
                expect(first_row_abs_freqs).to eq [0,0,0,0,0,0,0,0,0,0]
              end
            end
          end
        end
      end

      describe '3-length ship is on (1,1), (1,2), and (1,3)' do
        describe '2-length ship is on (1,6) and (1,7)' do
          it 'instantly has [12, 22, 25, 23, 23, 23, 23, 25, 22, 12] of absolute frequencies' do
            misses = []
            ship_length_2 = Battleship::HorizontalShip.new(length: 2)
            ship_length_3 = Battleship::HorizontalShip.new(length: 3)
            ships = [ship_length_2, ship_length_3]
            hash = {col_length: 10, row_length: 1, ships: ships, misses: misses}

            table = Battleship::Table.new(hash)
            table.abs_freq!

            first_row_abs_freqs = table.abs_freqs.first
            expect(first_row_abs_freqs).to eq [12, 22, 25, 23, 23, 23, 23, 25, 22, 12]
          end

          describe 'user hits (1,6)' do
            it 'should give us the proper absolute frequencies' do
              misses = []
              hit_1_6 = Battleship::Point.new(row: 1, col: 6, state: :hit)

              hits = [hit_1_6]
              ship_length_2 = Battleship::HorizontalShip.new(length: 2)
              ship_length_3 = Battleship::HorizontalShip.new(length: 3)
              ships = [ship_length_2, ship_length_3]
              hash = {col_length: 10, row_length: 1, ships: ships, misses: misses, hits: hits}

              table = Battleship::Table.new(hash)
              table.abs_freq!

              first_row_abs_freqs = table.abs_freqs.first
              expect(first_row_abs_freqs).to eq [5,10,10,11,16,0,16,11,8,5]
            end

            describe 'user hits (1,7) and sinks ship of length 2' do
              it 'gives us the proper absolute frequencies' do
                hit_1_6 = Battleship::Point.new(row: 1, col: 6, state: :hit)
                hit_1_7 = Battleship::Point.new(row: 1, col: 7)

                hits = [hit_1_6]
                ship_length_2 = Battleship::HorizontalShip.new(length: 2)
                ship_length_3 = Battleship::HorizontalShip.new(length: 3)
                ships = [ship_length_2, ship_length_3]
                sink_pair = Battleship::SinkPair.new(ship_length:2,
                                                     point: hit_1_7)
                sink_pairs = [sink_pair]
                hash = {col_length: 10,
                        row_length: 1,
                        ships: ships,
                        sink_pairs: sink_pairs,
                        hits: hits}

                table = Battleship::Table.new(hash)
                sink_pair.sink!
                table.abs_freq!

                first_row_abs_freqs = table.abs_freqs.first
                expect(first_row_abs_freqs).to eq [1,2,3,2,1,0,0,1,1,1]
              end
            end
          end
        end
      end
    end
  end

  describe '#unsunk_ships' do
    describe 'when there are unsunk ships' do
      it 'returns the unsunk ships' do
        ship_1 = Battleship::HorizontalShip.new(length: 2)
        ship_2 = Battleship::HorizontalShip.new(length: 3)
        ships = [ship_1, ship_2]
        misses = []
        hit_1 = Battleship::Point.new(row: 1, col: 1, status: :hit)
        hit_2 = Battleship::Point.new(row: 1, col: 2)
        sink_pair = Battleship::SinkPair.new(point: hit_2, ship_length: 2)

        hits = [hit_1]
        hash = {row_length: 1,
                col_length: 5,
                sink_pairs: [sink_pair],
                ships: ships,
                misses: misses,
                hits: hits}
        table = Battleship::Table.new(hash)

        sink_pair.sink!
        expect( table.unsunk_ships.length).to eq 1
        expect( table.unsunk_ships[0].length).to eq ship_2.length
      end
    end
  end

  describe '2 ships' do
    describe 'both horizontal' do
      describe 'both length 2' do
        describe 'hits at [(1,1),(2,2)]' do
          it '#abs_freqs should give us [[0,4,0], [2,0,2], [0,0,0]]' do
            ship_1 = Battleship::HorizontalShip.new(length: 2)
            ship_2 = Battleship::HorizontalShip.new(length: 2)
            ships = [ship_1, ship_2]
            misses = []
            hit_1 = Battleship::Point.new(row: 1, col: 1)
            hit_2 = Battleship::Point.new(row: 2, col: 2)
            # sink_pair = Battleship::SinkPair.new(point: hit_2, ship_length: 2)

            hits = [hit_1, hit_2]
            hash = {row_length: 3,
                    col_length: 3,
                    sink_pairs: [],
                    ships: ships,
                    misses: misses,
                    hits: hits}
            table = Battleship::Table.new(hash)
            table.abs_freq!

            expect( table.abs_freqs).to eq [[0,4,0], [2,0,2], [0,0,0]]
          end
        end
      end
    end

    describe 'both vertical' do
      describe 'both length 2' do
        describe 'hits at [(1,1),(2,2)]' do
          it '#abs_freqs should give us [[0,2,0], [4,0,0], [0,2,0]]' do
            ship_1 = Battleship::VerticalShip.new(length: 2)
            ship_2 = Battleship::VerticalShip.new(length: 2)
            ships = [ship_1, ship_2]
            misses = []
            hit_1 = Battleship::Point.new(row: 1, col: 1)
            hit_2 = Battleship::Point.new(row: 2, col: 2)
            # sink_pair = Battleship::SinkPair.new(point: hit_2, ship_length: 2)

            hits = [hit_1, hit_2]
            hash = {row_length: 3,
                    col_length: 3,
                    sink_pairs: [],
                    ships: ships,
                    misses: misses,
                    hits: hits}
            table = Battleship::Table.new(hash)
            table.abs_freq!

            expect( table.abs_freqs).to eq [[0,2,0], [4,0,0], [0,2,0]]
          end
        end
      end
    end

    describe 'one vertical, one horizontal' do
      describe 'both length 2' do
        describe 'hits at [(1,1),(2,2)]' do
          it '#abs_freqs should give us [[0,3,0], [2,0,2], [0,0,0]]' do
            ship_1 = Battleship::VerticalShip.new(length: 2)
            ship_2 = Battleship::HorizontalShip.new(length: 2)
            ships = [ship_1, ship_2]
            misses = []
            hit_1 = Battleship::Point.new(row: 1, col: 1)
            hit_2 = Battleship::Point.new(row: 2, col: 2)
            # sink_pair = Battleship::SinkPair.new(point: hit_2, ship_length: 2)

            hits = [hit_1, hit_2]
            hash = {row_length: 3,
                    col_length: 3,
                    sink_pairs: [],
                    ships: ships,
                    misses: misses,
                    hits: hits}
            table = Battleship::Table.new(hash)
            table.abs_freq!

            expect( table.abs_freqs).to eq [[0,1,0], [1,0,1], [0,1,0]]
          end
        end
      end
    end
  end
end
