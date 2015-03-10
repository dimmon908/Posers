class News < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 240 }
  scope :last_news, order("id desc").limit(5)
end
