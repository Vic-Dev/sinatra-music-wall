class AddPasswordTracksTable < ActiveRecord::Migration
  def change
    add_column :tracks, :password_digest, :string, null: :false
    add_column :tracks, :login_token, :string, index: true
    add_column :tracks, :remember_token, :string, index: true
  end
end
