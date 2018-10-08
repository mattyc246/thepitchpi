class Lock < ApplicationRecord
  belongs_to :user

  validates :lock_name, presence: true


end
