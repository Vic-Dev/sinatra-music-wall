class AddPasswordDigestUser < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string, null: :false
    add_column :users, :login_token, :string, index: true
    add_column :users, :remember_token, :string, index: true
  end
end
