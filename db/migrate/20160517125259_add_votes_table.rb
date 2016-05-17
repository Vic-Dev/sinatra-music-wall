class AddVotesTable < ActiveRecord::Migration
  def change
    create_join_table :tracks, :users, table_name: :votes do |t|
      t.integer :track_id
      t.integer :user_id
      t.integer :value
    end 
  end
end
