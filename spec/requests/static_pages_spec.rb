require 'spec_helper'

describe "Static pages" do
	
	describe "Home page" do

		it "should have the content 'Paisa Finder'" do
			visit '/static_pages/home'
			page.should have_content('Paisa Finder')
		end
	end		
end
