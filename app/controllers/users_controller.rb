# frozen_string_literal: true

# User controller methods.
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :logged_in_user, only: %i[show edit update]
  before_action :correct_user, only: %i[show edit update]

  def index
    @users = User.all
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user }
        WasapiFilesPopulateJob.perform_later(@user)
      else
        format.html { render :edit }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :institution, :wasapi_username,
                                 :wasapi_password)
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
end
