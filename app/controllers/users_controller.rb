# frozen_string_literal: true

# User controller methods.
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :logged_in_user, only: %i[show edit update]
  before_action :correct_user, only: %i[show edit update]
  before_action :set_collections, only: %i[show]

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user }
        WasapiSeedJob.set(queue: :seed).perform_later(@user)
        flash[:notice] = 'Your account is now syncing.
        An e-mail will be sent to ' + @user.email + ' once it is complete.'
      else
        format.html { render :edit }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_collections
    @collections = @user.collections.where(user_id: params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :institution, :wasapi_username,
                                 :wasapi_password, :auk_name, :terms)
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
end
