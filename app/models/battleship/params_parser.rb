class Battleship::ParamsParser
  attr_reader :misses, :sunken_points, :hits, :unsunk_ships

  def initialize(params)
    @statuses = params.fetch(:statuses) {[]}
    @sunken_points = []
    @misses = []
    @hits = []
    @unsunk_ships = Battleship::ShipsDecorator.new [
      Battleship::Ship.new(length: 2),
      Battleship::Ship.new(length: 3),
      Battleship::Ship.new(length: 3),
      Battleship::Ship.new(length: 4),
      Battleship::Ship.new(length: 5)
    ]

    params.fetch(:ships){[]}.map do |ship_obj|
      ship_hash = JSON.parse(ship_obj)
      key = ship_hash.keys.first
      ship_length = key.scan(/\d+/).first

      @unsunk_ships.reject_only_one_of_length!(ship_length) if ship_hash[key]
    end

    @statuses.each_with_index do |status, index|
      point = Battleship::Point.new(row: row(index), col: col(index))
      case status
      when 'missed'
        @misses << point
      when 'sunk'
        @sunken_points << point
      when 'hit'
        @hits << point
      end
    end
  end

  def parsed
    { sunken_points: sunken_points, hits: hits, misses: misses, unsunk_ships: unsunk_ships }
  end

  private

  def row(index)
    (index / 10) + 1
  end

  def col(index)
    (index % 10) + 1
  end
end
