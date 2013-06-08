class State < ActiveRecord::Base
  attr_accessible :name

	has_many :municipalities, dependent: :destroy 

	validates :name, presence: true

	default_scope order: 'states.name ASC'
end
