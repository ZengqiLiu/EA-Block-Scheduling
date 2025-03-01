class AddStudentIdUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :student_id, :string
    add_column :users, :active, :string
    add_column :users, :major, :string
  end
end
