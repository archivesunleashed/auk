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

  def set_collection_title
    collection_api_request_url = AI_COLLECTION_API_URL + @collection
    collection_api_request = HTTP.get(collection_api_request_url)
    collection_api_results = JSON.parse(collection_api_request)
    Collection.find_or_create_by(
      collection_id: collection_api_results['id']
    ) do |collection|
      collection.title = collection_api_results['name'],
      collection.public = collection_api_results['publicly_visible'],
      collection.description =
        collection_api_results['metadata']['Description']['value']
    end
  end
end
