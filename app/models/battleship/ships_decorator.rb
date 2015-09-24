class Battleship::ShipsDecorator < SimpleDelegator
  def reject_only_one_of_length!(length)
    if duplicated?(length.to_i)
      indices = self.each_index.select{|index| self[index].length == length.to_i}
      self.delete_at(indices.first)
    else
      self.reject!{|ship| ship.length == length.to_i}
    end
  end

  private

  def duplicated?(length)
    self.select {|ship| ship.length == length}.count > 1
  end
end
