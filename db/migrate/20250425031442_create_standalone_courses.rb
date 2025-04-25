class CreateStandaloneCourses < ActiveRecord::Migration[7.2]
  def change
    create_table :standalone_courses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
