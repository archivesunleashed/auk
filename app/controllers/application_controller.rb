# frozen_string_literal: true

# Application Controller methods.
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # Confirms logged in user.
  def logged_in_user
    return false if logged_in?
    flash[:danger] = 'Please log in.'
    redirect_to root_path
  end
end
