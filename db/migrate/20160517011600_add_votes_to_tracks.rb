class AddVotesToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :votes, :integer, :default => 0
  end
end
