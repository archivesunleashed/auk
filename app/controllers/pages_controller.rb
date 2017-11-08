# frozen_string_literal: true

# Pages controller methods.
class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:page]}"
  end
end
