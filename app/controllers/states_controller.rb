class StatesController < ApplicationController
	before_filter :admin_user, except: :show

	def show
		@state = State.find(params[:id])				
	end

	def index
		@states = State.all	
	end

	def new
		@state = State.new
	end
	
	def create
		@state = State.new(params[:state])
		if @state.save
			flash[:success] = "New state created"			
			redirect_to states_url
		else
			render 'new'
		end
	end	

	def edit
		@state =	State.find(params[:id]) 
	end	

	def update	
		@state = State.find(params[:id])
		if @state.update_attributes(params[:state])
			flash[:success] = "State updated"
			redirect_to states_url
		else
			render 'edit'
		end	
	end	

	def destroy
		State.find(params[:id]).destroy
		flash[:success] = "State destroyed."
		redirect_to states_url
	end	

	private
		def admin_user
			@user = User.find_by_remember_token(cookies[:remember_token])
			if @user && @user.admin?
				true
			else	
				redirect_to(root_path)
			end	
		end	

end	
