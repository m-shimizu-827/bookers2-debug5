class RelationshipsController < ApplicationController
	before_action :set_user

	def create
		following = current_user.follow(@user)
		if following.save
			redirect_to @user
		else
			redirect_to @user
		end
	end

	def destroy
	    following = current_user.unfollow(@user)
	    if following.destroy
	      redirect_to @user
	    else
	      redirect_to @user
	    end
    end

	private
	def set_user
		@user = User.find(params[:follow_id])
	end
end
