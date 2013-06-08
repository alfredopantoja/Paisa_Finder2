require 'spec_helper'

describe "State pages" do
				
	subject { page }

	describe "show" do
		let(:state) { FactoryGirl.create(:state) }
		let!(:m1) { FactoryGirl.create(:municipality, state: state, name: "Salva")}
		let!(:m2) { FactoryGirl.create(:municipality, state: state, name: "Acambaro")}
		before { visit state_path(state) }

		it { should have_selector('h1',    text: state.name) }
		it { should have_selector('title', text: state.name) }
		it { should have_content(state.name) }			

		describe "municipalities" do
			it { should have_content(m1.name) }				
			it { should have_content(m2.name) }				
			it { should have_content(state.municipalities.count) }
			it { should_not have_link('edit',   
								  					    href: edit_state_municipality_path(state, m1)) }
			it { should_not have_link('delete', 
														    href: state_municipality_path(state, m1)) }
		end	
	end				

	describe "as an admin user" do
		let(:admin) { FactoryGirl.create(:admin) }
		let!(:state1) { FactoryGirl.create(:state, name: "Tamaulipas") }
		let!(:state2) { FactoryGirl.create(:state, name: "Chihuahua") }
		let!(:m1) { FactoryGirl.create(:municipality, state: state1) }
		before { sign_in admin }				
		
		describe "show" do
			before { visit state_path(state1)}
						
			it { should have_link('edit',   
								  					href: edit_state_municipality_path(state1, m1)) }
			it { should have_link('delete', 
														href: state_municipality_path(state1, m1)) }
		end

		describe "index" do
			before { visit states_path }

			it { should have_selector('h1',    text: "All states") }
			it { should have_selector('title', text: "All states") }

			it { should have_content(state1.name) }
			it { should have_content(state2.name) }
			it { should have_link(state1.name, href: state_path(state1)) }
			it { should have_link(state2.name, href: state_path(state2)) }
			it { should have_link('delete', href: state_path(state1)) }
			it { should have_link('delete', href: state_path(state2)) }
			it { should have_link('edit',   href: edit_state_path(state1)) }
			it { should have_link('edit',   href: edit_state_path(state2)) }
		end	

		describe "new" do
			before { visit new_state_path }
			let(:submit) { "Create new state" }
			
			it { should have_selector('h1',    text: 'Create new state') }
			it { should have_selector('title', text: full_title('Create new state')) }	

			describe "with invalid information" do
				it "should not create a state" do
					expect { click_button submit }.not_to change(State, :count)
				end				

				describe "error messages" do
					before { click_button submit }
					it { should have_content('error') }
				end	
			end	

			describe "with valid information" do
				before { fill_in "Name", with: "Tachidolandia" }
				
				it "should create a state" do
					expect { click_button submit }.to change(State, :count).by(1)
				end				

				describe "after saving the state" do
					before { click_button submit }

					let(:state) { State.find_by_name('Tachidolandia') }
					it { should have_selector('title', text: 'All states') }
					it { should have_selector('div.alert.alert-success', text: 'New state created') }
					it { should have_selector('li', text: 'Tachidolandia') }
				end	
			end	
		end

		describe "edit" do
			before { visit edit_state_path(state1) }

			describe "page" do
				it { should have_selector('h1',    text: "Update state") }
				it { should have_selector('title', text: "Edit state") }				
			end	

			describe "with invalid information" do
				before { fill_in "Name", with: " " }

				describe "error messages" do
					before { click_button "Save changes" }				
					it { should have_content('error') }
				end	
			end	

			describe "with valid information" do
				let("new_name") {"New Name" }
				before do
					fill_in "Name", with: new_name
					click_button "Save changes"
				end

				it { should have_selector('title', text: 'All states') }
				it { should have_selector('div.alert.alert-success') }
				specify { state1.reload.name.should == new_name }
			end	
		end				
	end	
end
