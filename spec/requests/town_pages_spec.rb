require 'spec_helper'

describe "Town pages" do
  
  subject { page }

	describe "show" do
		let(:state) { FactoryGirl.create(:state) }
		let!(:m1) { FactoryGirl.create(:municipality, state: state, 
                                    name: "Tarandacua") }
    let!(:t1) { FactoryGirl.create(:town, municipality: m1, name: "San Pedro") }
    let!(:post1) do
      FactoryGirl.create(:post, town: t1, title: "help needed", 
                                          body: "help me out yo!")
    end  
    let!(:post2) do
      FactoryGirl.create(:post, town: t1, title: "looking for a job", 
                                          body: "anybody got a job yo!")
    end  

		before { visit municipality_town_path(m1, t1) }

		it { should have_selector('h1',    text: t1.name) }
		it { should have_selector('title', text: t1.name) }

    describe "posts" do
      it { should have_content(post1.title) }
      it { should have_content(post2.title) }
      it { should have_content(t1.posts.count) }
      it { should have_link(post1.title, href: town_post_path(t1, post1)) } 
      it { should have_link(post2.title, href: town_post_path(t1, post2)) } 
    end  
  end  

	describe "as an admin user" do
		let(:admin) { FactoryGirl.create(:admin) }
		before { sign_in admin }

    describe "town creation" do
      let!(:state) { FactoryGirl.create(:state) }
      let!(:muni) { FactoryGirl.create(:municipality, state: state) }
      let(:submit) { "Create new town" }
      before { visit new_municipality_town_path(muni) }

      it { should have_selector('h1',    text: 'Create new town') }
      it { should have_selector('title', text: full_title('Create new town')) }

      describe "with invalid information" do
        
        it "should not create a town" do
          expect { click_button submit }.not_to change(Town, :count)
        end

        describe "error messages" do
          before { click_button submit }
          it { should have_content('error') }
        end
      end

      describe "with valid information" do

        before { fill_in "Name", with: "San Pedro" }
        it "should create a town" do
          expect { click_button submit }.to change(Town, :count).by(1)
        end
      end
    end  

    describe "town destruction" do
      let(:state) { FactoryGirl.create(:state) }
      let(:muni)  { FactoryGirl.create(:municipality, state: state)}
      before { FactoryGirl.create(:town, municipality: muni) }
      before { visit state_municipality_path(state, muni) }

      it "should delete a town" do
        expect { click_link "delete" }.to change(Town, :count).by(-1)
      end
    end  

    describe "editing a town" do
      let!(:state) { FactoryGirl.create(:state) }
      let!(:muni)  { FactoryGirl.create(:municipality, state: state) }
      let!(:town)  { FactoryGirl.create(:town, municipality: muni) }
      before { visit edit_municipality_town_path(muni, town) }

      describe "page" do
        it { should have_selector('h1',    text: "Update town") }
        it { should have_selector('title', text: "Update town") }
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

        it { should have_selector('title', text: muni.name) }
        it { should have_selector('div.alert.alert-success') }
        specify { town.reload.name.should == new_name }
      end  
    end  
  end  
end
