class Municipality < ActiveRecord::Base
  attr_accessible :name
	belongs_to :state

	validates :name,     presence: true
	validates :state_id, presence: true 
	
	default_scope order: 'municipalities.name ASC'
end
