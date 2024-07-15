class Post < ApplicationRecord
  belongs_to :user

  MIN_LENGTH_MESSAGE = 3

  validates :message, presence: true, length: { minimum: 3 }
end
