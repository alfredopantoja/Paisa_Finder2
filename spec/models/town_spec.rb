require 'spec_helper'

describe Town do
	
	let(:municipality) { FactoryGirl.create(:municipality) }
	before { @town = municipality.towns.build(name: "San Pedro") }

	subject { @town }

	it { should respond_to(:name) }
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
end
