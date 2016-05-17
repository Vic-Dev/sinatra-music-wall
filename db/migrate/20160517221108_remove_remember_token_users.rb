class RemoveRememberTokenUsers < ActiveRecord::Migration
  def change
    remove_column :users, :remember_token, :string, index: true
  end
end
