require 'spec_helper'

describe State do
	
	before { @state = State.new(name: "Guanajuato") }

	subject { @state }

	it { should respond_to(:name) }	
	it { should respond_to(:municipalities) }

	it { should be_valid }

	describe "with blank name" do
		before { @state.name = " " }
		it { should_not be_valid }
	end	

	describe "municipality associations" do
		before { @state.save }
		let!(:c_municipality) do
			FactoryGirl.create(:municipality, state: @state, name: "c")
		end
		let!(:a_municipality) do
			FactoryGirl.create(:municipality, state: @state, name: "a")
		end
		let!(:b_municipality) do
			FactoryGirl.create(:municipality, state: @state, name: "b")
		end
		
		it "should destroy associated municipalities" do
			municipalities = @state.municipalities.dup
			@state.destroy
			municipalities.should_not be_empty
			municipalities.each do |municipality|
				Municipality.find_by_id(municipality.id).should be_nil
			end	
		end	

		it "should have the right municipalities in the right order" do
			@state.municipalities.should == [a_municipality, b_municipality,
																			 c_municipality]
		end
	end	
end
