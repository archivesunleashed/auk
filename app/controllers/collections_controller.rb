# frozen_string_literal: true

# Collection controller methods.
class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show]
  before_action :set_user, only: %i[show download]
  before_action :set_collection_id, only: %i[download]
  before_action :gexf_path, only: %i[download_gexf]
  before_action :graphml_path, only: %i[download_graphml]
  before_action :domains_path, only: %i[download_domains]
  before_action :fulltext_path, only: %i[download_fulltext]
  before_action :correct_user, only: %i[show download download_gexf
                                        download_fulltext download_domains]

  def download
    WasapiDownloadJob.set(queue: :download)
                     .perform_later(@user, @collection_id)
    flash[:notice] = 'Your collection has begun downloading. An e-mail will be
                      sent to ' + @user.email + ' once it is complete.'
    redirect_to user_path(@user)
  end

  def download_gexf
    send_file(
      @gexf_path,
      type: 'text/xml'
    )
  end

  def download_graphml
    send_file(
      @graphml_path,
      type: 'text/xml'
    )
  end

  def send_gexf
    File.read(@gexf_path)
  end

  def download_fulltext
    send_file(
      @fulltext_path,
      type: 'text/plain'
    )
  end

  def download_domains
    send_file(
      @domains_path,
      type: 'text/plain'
    )
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
    params.require(:collection).permit(:title, :public, :user_id, :account)
  end

  def gexf_path
    @gexf_path = ENV['DOWNLOAD_PATH'] + '/' + params[:format].to_s + '/' +
                 params[:collection_id].to_s + '/' + params[:user_id].to_s +
                 '/derivatives/gephi/' + params[:collection_id].to_s +
                 '-gephi.gexf'
  end

  def graphml_path
    @graphml_path = ENV['DOWNLOAD_PATH'] + '/' + params[:format].to_s +
                    '/' + params[:collection_id].to_s + '/' +
                    params[:user_id].to_s + '/derivatives/gephi/' +
                    params[:collection_id].to_s + '-gephi.graphml'
  end

  def domains_path
    @domains_path = ENV['DOWNLOAD_PATH'] + '/' + params[:format].to_s + '/' +
                    params[:collection_id].to_s + '/' + params[:user_id].to_s +
                    '/derivatives/all-domains/' + params[:collection_id].to_s +
                    '-fullurls.txt'
  end

  def fulltext_path
    @fulltext_path = ENV['DOWNLOAD_PATH'] + '/' + params[:format].to_s + '/' +
                     params[:collection_id].to_s + '/' + params[:user_id].to_s +
                     '/derivatives/all-text/' + params[:collection_id].to_s +
                     '-fulltext.txt'
  end

  def correct_user
    @user = User.find(params[:user_id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
