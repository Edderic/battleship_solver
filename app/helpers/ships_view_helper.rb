module ShipsViewHelper
  def self.ships(real_ships)
    all_ships = Ships.new(real_ships)
    all_ships.all.sort_by(&:id)
  end

  class Ships
    def initialize(ships)
      @ships = ships
    end

    def all
      @ships | sunken_ships
    end

    def sunken_ship_ids
      Battleship::Ship.all_ids - unsunk_ship_ids
    end

    def sunken_ships
      sunken_ship_ids.map do |sunken_ship_id|
        Battleship::Ship.new(sunk: true, id: sunken_ship_id)
      end
    end

    def unsunk_ship_ids
      @ships.map {|ship| ship.id}
    end
  end
end
