require 'rails_helper'

RSpec.describe Move, type: :model do
  it 'has an action' do
    move = Move.create(action: "hit!(5,5)")
    expect(move.action).to eq 'hit!(5,5)'
  end
end
