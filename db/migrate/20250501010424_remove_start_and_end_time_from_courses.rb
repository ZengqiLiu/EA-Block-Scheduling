class RemoveStartAndEndTimeFromCourses < ActiveRecord::Migration[7.2]
  def change
    remove_column :courses, :start_time, :time
    remove_column :courses, :end_time, :time
    add_column :courses, :time_slots, :text
  end
end
