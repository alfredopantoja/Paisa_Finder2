require 'spec_helper'

describe State do
	
	before { @state = State.new(name: "Guanajuato") }

	subject { @state }

	it { should respond_to(:name) }	

	it { should be_valid }

	describe "with blank name" do
		before { @state.name = " " }
		it { should_not be_valid }
	end	
end
