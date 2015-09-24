class BoardController < ApplicationController
  def index
    @board = Battleship::HasbroBoard.new(Battleship::ParamsParser.new(params).parsed)
    @reduced_table = @board.reduced_table
  end

  def rerender_table
    @board = Battleship::HasbroBoard.new(Battleship::ParamsParser.new(params).parsed)
    @reduced_table = @board.reduced_table

    render partial: 'body', locals: {reduced_table: @reduced_table}
  end
end
