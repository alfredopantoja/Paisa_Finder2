require 'spec_helper'

describe Post do

  let(:town) { FactoryGirl.create(:town) }
  before { @post = town.posts.build(title: "Workers needed",
                                    body: "Yo I need some workers pronto") }

  subject { @post }

  it { should respond_to(:title) }
  it { should respond_to(:body) }
  it { should respond_to(:town_id) }
  it { should respond_to(:town) }
  its(:town) { should == town }

  it { should be_valid }

  describe "when town_id is not present" do
    before { @post.town_id = nil }
    it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to town_id" do
      expect do
        Post.new(town_id: town.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end  

  describe "with blank title" do
    before { @post.title = " " }
    it { should_not be_valid }
  end  

  describe "with blank body" do
    before { @post.body = " " }
    it { should_not be_valid }
  end  
end
