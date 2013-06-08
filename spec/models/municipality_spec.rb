require 'spec_helper'

describe Municipality do

	let(:state) { FactoryGirl.create(:state) }
	before { @municipality = state.municipalities.build(name: "Salvatierra") }

	subject { @municipality }

	it { should respond_to(:name) }
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
end
