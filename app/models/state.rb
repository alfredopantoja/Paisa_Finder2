class State < ActiveRecord::Base
  attr_accessible :name

	validates :name, presence: true

	default_scope order: 'states.name ASC'
end
