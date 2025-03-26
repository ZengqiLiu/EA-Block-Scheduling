class BlockCourse < ApplicationRecord
  belongs_to :block_selection
  belongs_to :course
end
