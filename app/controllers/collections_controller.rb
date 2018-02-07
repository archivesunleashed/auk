# frozen_string_literal: true

# Collection controller methods.
class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show]
  before_action :set_user, only: %i[show]
  before_action :set_wasapi_files, only: %i[show]

  def index
    @collection = Collection.all
  end

  def show; end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_wasapi_files
    @wasapi_files = @collection.wasapi_files.where(
      collection_id: params[:collection_id]
    )
  end

  def collection_params
    params.require(:collection).permit(:title, :public, :user_id)
  end
end
