class AddUniqueIndexToCourses < ActiveRecord::Migration[7.2]
  def change
    add_index :courses, [:term, :syn], unique: true, name: "index_courses_on_unique_fields"
  end
end
