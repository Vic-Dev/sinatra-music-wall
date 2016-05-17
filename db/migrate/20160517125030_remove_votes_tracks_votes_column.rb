class RemoveVotesTracksVotesColumn < ActiveRecord::Migration
  def change
    remove_column :tracks, :votes, :integer, default: 0
  end
end
