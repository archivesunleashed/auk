# frozen_string_literal: true

# Helpers for Session Controller.
module SessionsHelper
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end
end
