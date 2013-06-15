require 'spec_helper'

describe Municipality do

	let(:state) { FactoryGirl.create(:state) }
	before { @municipality = state.municipalities.build(name: "Salvatierra") }

	subject { @municipality }

	it { should respond_to(:name) }
  it { should respond_to(:towns) }
	it { should respond_to(:state_id) }	
	it { should respond_to(:state) }
	its(:state) { should == state }

	it { should be_valid }

	describe "accessible attributes" do
		it "should not allow access to state_id" do
			expect do
				Municipality.new(state_id: state.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end	
	
	describe "when state_id is not present" do
		before { @municipality.state_id = nil }
		it { should_not be_valid }
	end	

	describe "with blank name" do
		before { @municipality.name = " " }
		it { should_not be_valid }
	end	

  describe "town associations" do
    before { @municipality.save }
		let!(:c_town) do
			FactoryGirl.create(:town, municipality: @municipality, name: "c")
		end
		let!(:a_town) do
			FactoryGirl.create(:town, municipality: @municipality, name: "a")
		end
		let!(:b_town) do
			FactoryGirl.create(:town, municipality: @municipality, name: "b")
		end

    it "should destroy associated towns" do
      towns = @municipality.towns.dup
      @municipality.destroy
      towns.should_not be_empty
      towns.each do |town|
        Town.find_by_id(town.id).should be_nil
      end
    end

    it "should have the right towns in the right order" do
      @municipality.towns.should == [a_town, b_town, c_town]
    end
  end  
end
