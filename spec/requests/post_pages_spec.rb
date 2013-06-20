require 'spec_helper'

describe "Post pages" do

  subject { page }
  
  describe "show" do
    let(:town) { FactoryGirl.create(:town) }
    let!(:post) do
      FactoryGirl.create(:post, town: town, title: "What up my dudes!",
                                            body: "Anybody got a job my dudes?")
    end  

    before { visit town_post_path(town, post) }

    it { should have_selector('h1',    text: post.title) }
    it { should have_selector('title', text: post.title) }
  end  

  describe "as an admin user" do
		let(:admin) { FactoryGirl.create(:admin) }
		before { sign_in admin }

    describe "post creation" do
      let!(:town) { FactoryGirl.create(:town) }
      let(:submit) { "Create new post" }
      before { visit new_town_post_path(town) }

      it { should have_selector('h1',    text: 'Create new post') }
      it { should have_selector('title', text: full_title('Create new post')) }

      describe "with invalid information" do

        it "should not create a post" do
          expect { click_button submit }.not_to change(Post, :count)
        end

        describe "error messages" do
          before { click_button submit }
          it { should have_content('error') }
        end
      end  

      describe "with valid information" do

        before { fill_in "Title", with: "Jobs for all available" }
        before { fill_in "Body",  with: "Where you guys at? There are jobs." }
        it "should create a post" do
          expect { click_button submit }.to change(Post, :count).by(1)
        end
      end
    end  

    describe "post destruction" do
      let(:muni) { FactoryGirl.create(:municipality) }
      let(:town) { FactoryGirl.create(:town, municipality: muni) }
      before { FactoryGirl.create(:post, town: town) }
      before { visit municipality_town_path(muni, town) }

      
      it "should delete a post" do
        expect { click_link "delete" }.to change(Post, :count).by(-1)
      end
    end  
    
    describe "editing a post" do
      let!(:town) { FactoryGirl.create(:town) }
      let!(:town_post) { FactoryGirl.create(:post, town: town) }
      before { visit edit_town_post_path(town, town_post) }

      describe "page" do
        it { should have_selector('h1',    text: "Update post") }
        it { should have_selector('title', text: "Update post") }
      end  
      
      describe "with invalid information" do
        
        describe "with blank title" do
          before { fill_in "Title", with: " " }

          describe "error messages" do
            before { click_button "Save changes" }
            it { should have_content('error') }
          end  
        end 
        
        describe "with blank body" do
          before { fill_in "Body", with: " " }

          describe "error messages" do
            before { click_button "Save changes" }
            it { should have_content('error') }
          end  
        end 
      end  

      describe "with valid information" do
        let("new_title") { "This is a new title." }
        let("new_body")  { "This is a new body." }
        before do
          fill_in "Title", with: new_title
          fill_in "Body",  with: new_body
          click_button "Save changes"
        end

        it { should have_selector('title', text: town.name) }
        it { should have_selector('div.alert.alert-success') }
        specify { town_post.reload.title.should == new_title }
      end  
    end  
  end  
end
