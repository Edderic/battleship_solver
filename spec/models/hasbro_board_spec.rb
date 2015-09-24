require 'spec_helper'

describe Battleship::HasbroBoard do
  describe '#row_length' do
    it 'should instantiate a board' do
      board = Battleship::HasbroBoard.new
      expect(board.row_length).to eq 10
    end
  end

  describe '#col_length' do
    it 'should instantiate a board' do
      board = Battleship::HasbroBoard.new
      expect(board.col_length).to eq 10
    end
  end

  describe 'in the beginning' do
    before do
      @board = Battleship::HasbroBoard.new
    end

    specify 'test' do
      @board.hit!(5,5)
      @board.hit!(4,5)
      @board.hit!(6,5)
      @board.hit!(7,5)
      @board.miss!(8,5)
      @board.sink_pair!(3,5,4)

      require 'pry'; binding.pry
      expect(@board.hits.count).to eq 1
      expect(@board.sunken_points.include_point?(3,5)).to eq true
      expect(@board.sunken_points.include_point?(4,5)).to eq true
      expect(@board.sunken_points.include_point?(5,5)).to eq true
      expect(@board.sunken_points.include_point?(6,5)).to eq true

      expect(@board.sunken_points.include_point?(7,5)).to eq false
      expect(@board.sunken_points.include_point?(8,5)).to eq false
      expect(true).to eq true
    end

    specify 'there should be 5 ships' do
      require 'pry'; binding.pry
      expect(@board.unsunk_ships.any? {|ship| ship.length == 2}).to eq true
      expect(@board.unsunk_ships.select {|ship| ship.length == 3}.count).to eq 2
      expect(@board.unsunk_ships.any? {|ship| ship.length == 4}).to eq true
      expect(@board.unsunk_ships.any? {|ship| ship.length == 5}).to eq true
    end

    specify 'there should be no hits' do
      expect(@board.hits).to be_empty
    end

    specify 'there should be no misses' do
      expect(@board.misses).to be_empty
    end

    specify 'there should be no sunken points' do
      expect(@board.sunken_points).to be_empty
    end

    specify 'absolute frequencies should be correct' do
      expect(@board.abs_freqs).to eq [[160, 240, 304, 336, 352, 352, 336, 304, 240, 160],
                                      [240, 320, 384, 416, 432, 432, 416, 384, 320, 240],
                                      [304, 384, 448, 480, 496, 496, 480, 448, 384, 304],
                                      [336, 416, 480, 512, 528, 528, 512, 480, 416, 336],
                                      [352, 432, 496, 528, 544, 544, 528, 496, 432, 352],
                                      [352, 432, 496, 528, 544, 544, 528, 496, 432, 352],
                                      [336, 416, 480, 512, 528, 528, 512, 480, 416, 336],
                                      [304, 384, 448, 480, 496, 496, 480, 448, 384, 304],
                                      [240, 320, 384, 416, 432, 432, 416, 384, 320, 240],
                                      [160, 240, 304, 336, 352, 352, 336, 304, 240, 160]]
    end

    specify 'best_targets should be the middle points' do
      best_targets = @board.best_targets
      expect(best_targets.include_point?(5,5)).to eq true
      expect(best_targets.include_point?(5,6)).to eq true
      expect(best_targets.include_point?(6,5)).to eq true
      expect(best_targets.include_point?(6,6)).to eq true
      expect(best_targets.include_point?(9,6)).to eq false
    end

    describe '#hit!(5,5)' do
      before { @board.hit!(5,5) }

      it 'should change the frequencies' do
        best_targets = @board.best_targets

        expect(best_targets.include_point?(5,6)).to eq true
        expect(best_targets.include_point?(6,5)).to eq true
        expect(best_targets.include_point?(5,4)).to eq true
        expect(best_targets.include_point?(4,5)).to eq true
        expect(best_targets.include_point?(5,5)).to eq false
      end
    end

    describe '#miss!(5,5)' do
      before { @board.miss!(5,5) }

      specify 'best_targets should only be (6,6)' do
        best_targets = @board.best_targets

        expect(best_targets.include_point?(6,6)).to eq true
        expect(best_targets.count).to eq 1
        expect(@board.abs_freqs ).to eq [[160, 240, 304, 336, 336, 352, 336, 304, 240, 160],
                                         [240, 320, 384, 416, 384, 432, 416, 384, 320, 240],
                                         [304, 384, 448, 480, 384, 496, 480, 448, 384, 304],
                                         [336, 416, 480, 512, 336, 528, 512, 480, 416, 336],
                                         [336, 384, 384, 336, 0, 352, 416, 448, 416, 352],
                                         [352, 432, 496, 528, 352, 544, 528, 496, 432, 352],
                                         [336, 416, 480, 512, 416, 528, 512, 480, 416, 336],
                                         [304, 384, 448, 480, 448, 496, 480, 448, 384, 304],
                                         [240, 320, 384, 416, 416, 432, 416, 384, 320, 240],
                                         [160, 240, 304, 336, 352, 352, 336, 304, 240, 160]]
      end

      describe '#hit!(6,6)' do
        before do
          @board.hit!(6,6)
        end

        specify 'changes the list of best targets' do
          best_targets = @board.best_targets
          expect(best_targets.include_point?(6,5)).to eq true
          expect(best_targets.include_point?(6,7)).to eq true
          expect(best_targets.include_point?(5,6)).to eq true
          expect(best_targets.include_point?(7,6)).to eq true
          expect(best_targets.count).to eq 4
        end

        describe '#hit!(6,7)' do
          before do
            @board.hit!(6,7)
          end

          specify 'changes the list of best targets' do
            best_targets = @board.best_targets
            expect(best_targets.include_point?(6,5)).to eq true
            expect(best_targets.include_point?(5,6)).to eq true
            expect(best_targets.include_point?(5,7)).to eq true
            expect(best_targets.include_point?(7,6)).to eq true
            expect(best_targets.include_point?(7,7)).to eq true
            expect(best_targets.count).to eq 5
          end

          describe '#hit!(6,5)' do
            before do
              @board.hit!(6,5)
            end

            specify 'changes the list of best targets' do
              best_targets = @board.best_targets
              expect(best_targets.include_point?(6,4)).to eq true
              expect(best_targets.include_point?(5,6)).to eq true
              expect(best_targets.include_point?(5,7)).to eq true
              expect(best_targets.include_point?(7,6)).to eq true
              expect(best_targets.include_point?(7,7)).to eq true
              expect(best_targets.count).to eq 5
            end

            describe '#sink_pair!(6,4,4)' do
              before do
                @board.sink_pair!(6,4,4)
              end

              specify 'changes the list of best targets' do
                best_targets = @board.best_targets

                expect(@board.unsunk_ships.count).to eq 4
                expect(@board.unsunk_ships.any?{|ship| ship.length == 4}).to eq false
                expect(@board.hits).to be_empty
                expect(@board.sunken_points.count).to eq 4

                expect(best_targets.include_point?(6,4)).to eq true
                expect(best_targets.include_point?(5,6)).to eq true
                expect(best_targets.include_point?(5,7)).to eq true
                expect(best_targets.include_point?(7,6)).to eq true
                expect(best_targets.include_point?(7,7)).to eq true
                expect(best_targets.count).to eq 5
              end
            end
          end
        end
      end
    end
  end
end
