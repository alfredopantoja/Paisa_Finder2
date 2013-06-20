class Post < ActiveRecord::Base
  attr_accessible :body, :title 
  belongs_to :town

  validates :title, presence: true
  validates :body, presence: true
  validates :town_id, presence: true

  default_scope order: 'posts.created_at DESC'
end
