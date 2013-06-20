class TownsController < ApplicationController
  before_filter :admin_user, except: :show
	before_filter :get_municipality 
  before_filter :get_state 

  def show 
    @town = @municipality.towns.find(params[:id])
    @posts = @town.posts.paginate(page: params[:page])
  end

  def new
    @town = @municipality.towns.new  
  end

  def create 
    @town = @municipality.towns.new(params[:town]) 
    if @town.save
      flash[:success] = "Town created!"
      redirect_to [@state, @municipality]
    else
      render 'new'
    end  
  end

  def edit
    @town = @municipality.towns.find(params[:id])
  end

  def update
    @town = @municipality.towns.find(params[:id])
    if @town.update_attributes(params[:town])
      flash[:success] = "Town updated"
      redirect_to [@state, @municipality]
    else
      render 'edit'
    end
  end  

  def destroy
    @town = @municipality.towns.find(params[:id])
    @town.destroy
    redirect_to [@state, @municipality]
  end  

  private
	  def get_municipality
		  @municipality = Municipality.find(params[:municipality_id])
	  end

    def get_state
      @state = @municipality.state
    end  

    def admin_user
      @user = User.find_by_remember_token(cookies[:remember_token])
      if @user && @user.admin?
        true
      else
        redirect_to(root_path)
      end
    end  
end  
