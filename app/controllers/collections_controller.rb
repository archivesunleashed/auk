# frozen_string_literal: true

# Collection controller methods.
class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show]
  before_action :set_user, only: %i[show download]
  before_action :set_collection_id, only: %i[download]

  def index; end

  def download
    WasapiFilesDownloadJob.perform_later(@user, @collection_id)
    CollectionsSparkJob.perform_later(@user, @collection_id)
  end

  def show; end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def set_collection_id
    @collection_id = Collection.find(params[:collection_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def collection_params
    params.require(:collection).permit(:title, :public, :user_id)
  end
end
