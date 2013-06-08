class MunicipalitiesController < ApplicationController
	before_filter :admin_user, except: :show
	before_filter :get_state			

	def get_state
		@state = State.find(params[:state_id])
	end

	def show
		@municipality = @state.municipalities.find(params[:id])
	end	

	def new
  	@municipality = @state.municipalities.new
	end	
	
	def create
		@municipality = @state.municipalities.new(params[:municipality])
		if @municipality.save
			flash[:success] = "Municipality created!"
			redirect_to @state
		else
			render 'new'
		end	
	end

	def edit
		@municipality = @state.municipalities.find(params[:id])
	end				

	def update
		@municipality = @state.municipalities.find(params[:id])
		if @municipality.update_attributes(params[:municipality])
			flash[:success] = "Municipality updated"
			redirect_to @state
		else
			render 'edit'
		end	
	end				

	def destroy
		@municipality = @state.municipalities.find(params[:id])
		@municipality.destroy
		redirect_to @state		
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
