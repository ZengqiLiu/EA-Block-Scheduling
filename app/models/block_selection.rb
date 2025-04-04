class BlockSelection < ApplicationRecord
  belongs_to :user
  has_many :block_courses, dependent: :destroy
  has_many :courses, through: :block_courses
end
