class Message < ApplicationRecord
  belongs_to :chat

  validates :body, presence: true, length: { maximum: 65535 }
end
