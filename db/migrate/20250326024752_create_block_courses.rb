class CreateBlockCourses < ActiveRecord::Migration[7.2]
  def change
    create_table :block_courses do |t|
      t.references :block_selection, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
