# frozen_string_literal: true

# Collection controller methods.
class CollectionsController < ApplicationController
  before_action :set_user
  before_action :set_user_collections
  before_action :set_collection_title

  AI_COLLECTION_API_URL = 'https://partner.archive-it.org/api/collection/'

  def index
    @collections = @user.collections
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_collections
    @collections = WasapiFile.find(@user)
  end
end
