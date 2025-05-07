class AddTamuUidToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :tamu_uid, :string
  end
end
