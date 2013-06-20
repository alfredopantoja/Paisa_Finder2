class PostsController < ApplicationController
  before_filter :admin_user, except: :show
  before_filter :get_town
  before_filter :get_municipality, only: [:create, :update, :destroy]

  def show
    @post = @town.posts.find(params[:id])
  end

  def new
    @post = @town.posts.new
  end

  def create 
    @post = @town.posts.new(params[:post])
    if @town.save
      flash[:success] = "Post created!"
      redirect_to [@municipality, @town]
    else
      render 'new'
    end  
  end

  def edit
    @post = @town.posts.find(params[:id]) 
  end

  def update
    @post = @town.posts.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:success] = "Post updated"
      redirect_to [@municipality, @town]
    else
      render 'edit'
    end
  end  

  def destroy
    @post = @town.posts.find(params[:id])
    @post.destroy
    redirect_to [@municipality, @town]
  end

  private
    def get_town
      @town = Town.find(params[:town_id])
    end  

    def get_municipality
      @municipality = @town.municipality
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
