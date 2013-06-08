require 'spec_helper'

describe "Municipality pages" do

	subject { page }

	describe "show" do
		let(:state) { FactoryGirl.create(:state) }
		let!(:m1) { FactoryGirl.create(:municipality, state: state, name: "Tarandacua")}
		before { visit state_municipality_path(state, m1) }

		it { should have_selector('h1',    text: m1.name) }
		it { should have_selector('title', text: m1.name) }
		it { should have_content(m1.name) }			
	end				
	
	describe "as an admin user" do
		let(:admin) { FactoryGirl.create(:admin) }
		before { sign_in admin }

		describe "municipality creation" do
			let!(:state) { FactoryGirl.create(:state) }			
			let(:submit) { "Create new municipality" }
			before { visit new_state_municipality_path(state) }	

			it { should have_selector('h1',   text: 'Create new municipality') }
			it { should have_selector'title', text: full_title('Create new municipality')}

			describe "with invalid information" do

				it "should not create a municipality" do
					expect { click_button submit }.not_to change(Municipality, :count)
				end

				describe "error messages" do
					before { click_button submit }
					it { should have_content('error') }
				end	
			end	

			describe "with valid information" do
			
				before { fill_in "Name", with: "Salvatierra" }
				it "should create a municipality" do
					expect { click_button submit }.to change(Municipality, :count).by(1)
				end
			end	
		end	

		describe "municipality destruction" do
			let(:state) { FactoryGirl.create(:state) }			
			before { FactoryGirl.create(:municipality, state: state) }
			before { visit state_path(state) }

			it "should delete a municipality" do
				expect { click_link "delete" }.to change(Municipality, :count).by(-1)
			end
		end	

		describe "editing a municipality" do
			let!(:state) { FactoryGirl.create(:state) }
			let!(:municipality) { FactoryGirl.create(:municipality, state: state) }			
			before { visit edit_state_municipality_path(state, municipality) }

			describe "page" do
				it { should have_selector('h1',    text: "Update municipality") }
				it { should have_selector('title', text: "Update municipality") }
			end	

			describe "with invalid information" do
				before { fill_in "Name", with: " " }
				
				describe "error messages" do
					before { click_button "Save changes" }
					it { should have_content('error') }
				end
			end	
			
			describe "with valid information" do
				let("new_name") { "New Name" }
				before do
					fill_in "Name", with: new_name				
					click_button "Save changes"
				end

				it { should have_selector('title', text: state.name) }
				it { should have_selector('div.alert.alert-success') }
				specify { municipality.reload.name.should == new_name }
			end	
		end				
	end				
end
