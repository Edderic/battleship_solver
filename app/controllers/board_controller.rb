class BoardController < ApplicationController
  def index
    @board = Battleship::HasbroBoard.new(Battleship::ParamsParser.new(params).parsed)
    @num_total_configurations = @board.num_total_configurations
    @abs_freqs = @board.abs_freqs
    @reduced_table = @board.reduced_table
  end

  def rerender_table
    @board = Battleship::HasbroBoard.new(Battleship::ParamsParser.new(params).parsed)
    @num_total_configurations = @board.num_total_configurations
    @abs_freqs = @board.abs_freqs
    @reduced_table = @board.reduced_table

    render partial: 'table', locals: {reduced_table: @reduced_table, abs_freqs: @abs_freqs}
  end
end
