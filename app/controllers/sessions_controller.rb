# frozen_string_literal: true

# Session controller methods.
class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = @user.id
    redirect_to @user
  end

  def destroy
    if current_user
      session.delete(:user_id)
    end
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
