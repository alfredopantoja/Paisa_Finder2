require 'spec_helper'

describe Town do
	
	let(:municipality) { FactoryGirl.create(:municipality) }
	before { @town = municipality.towns.build(name: "San Pedro") }

	subject { @town }

	it { should respond_to(:name) }
  it { should respond_to(:posts) }
	it { should respond_to(:municipality_id) }	
  it { should respond_to(:municipality) }
  its(:municipality) { should == municipality }

  it { should be_valid }

  describe "when municipality_id is not present" do
    before { @town.municipality_id = nil }
    it { should_not be_valid }
  end 

  describe "accessible attributes" do
    it "should not allow access to municipality_id" do
      expect do
        Town.new(municipality_id: municipality.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end  

  describe "with blank name" do
    before { @town.name = " " }
    it { should_not be_valid }
  end  

  describe "post associations" do

    before { @town.save }
    let!(:older_post) do
      FactoryGirl.create(:post, town: @town, created_at: 1.day.ago)
    end  
    let!(:newer_post) do
      FactoryGirl.create(:post, town: @town, created_at: 1.hour.ago)
    end  

    it "should have the right posts in the right order" do
      @town.posts.should == [newer_post, older_post]
    end

    it "should destroy associated posts" do
      posts = @town.posts.dup
      @town.destroy
      posts.should_not be_empty
      posts.each do |post|
        Post.find_by_id(post.id).should be_nil
      end
    end  
  end  
end
