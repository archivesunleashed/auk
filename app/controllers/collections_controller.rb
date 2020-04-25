# frozen_string_literal: true

# Collection controller methods.
class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show]
  before_action :set_user, only: %i[show audio download domains_chart
                                    domainfrequency domaingraph
                                    images imagegraph pdfs presentationprogram
                                    spreadsheets videos webgraph
                                    webpages webpage_text wordprocessor]
  before_action :set_collection_id, only: %i[audio domainfrequency domaingraph
                                             download domains_chart
                                             images imagegraph pdfs spreadsheets
                                             webgraph videos wordprocessor
                                             webpages webpage_text presentationprogram]
  before_action :set_account, only: %i[domains_chart]
  before_action :gexf_path, only: %i[download_gexf]
  before_action :graphml_path, only: %i[download_graphml]
  before_action :domains_path, only: %i[download_domains]
  before_action :domains_chart_data, only: %i[domains_chart]
  before_action :fulltext_path, only: %i[download_fulltext]
  before_action :textfilter_path, only: %i[download_textfilter]
  before_action :correct_user, only: %i[show audio download domaingraph
                                        domainfrequency images imagegraph
                                        download_gexf download_fulltext
                                        download_domains download_textfilter
                                        pdfs spreadsheets videos
                                        wordprocessor webgraph
                                        webpages webpage_text presentationprogram]

  include CollectionsHelper

  def audio
    AudioJob.set(queue: :audio)
            .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def domainfrequency
    DomainfrequencyJob.set(queue: :domainfrequency)
                      .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def domaingraph
    DomaingraphJob.set(queue: :domaingraph)
                  .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def download
    WasapiDownloadJob.set(queue: :download)
                     .perform_later(@user, @collection_id)
    redirect_to user_path(@user)
  end

  def images
    ImagesJob.set(queue: :images)
             .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def imagegraph
    ImagegraphJob.set(queue: :imagegraph)
                 .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def pdfs
    PdfsJob.set(queue: :pdfs)
           .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def presentationprogram
    PresentationProgramJob.set(queue: :presentation_program)
                          .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def spreadsheets
    SpreadsheetsJob.set(queue: :spreadsheets)
                   .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def webgraph
    WebgraphJob.set(queue: :webgraph)
               .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def videos
    VideosJob.set(queue: :videos)
             .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def webpages
    WebpagesJob.set(queue: :webpages)
               .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def webpage_text
    WebpageTextJob.set(queue: :webpage_text)
                  .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
  end

  def wordprocessor
    WordProcessorJob.set(queue: :word_processor)
                    .perform_later(@user, @collection_id)
    redirect_to user_collection_path(@user, @collection_id)
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

  def download_textfilter
    send_file(
      @textfilter_path,
      type: 'application/zip'
    )
  end

  def download_domains
    send_file(
      @domains_path,
      type: 'text/plain'
    )
  end

  def domains_chart
    render json: domains_chart_data
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

  def set_account
    @account = Collection.where(user_id: params[:user_id],
                                collection_id: params[:collection_id])
                         .pluck(:account)
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
                    '-fullurls.csv'
  end

  def fulltext_path
    @fulltext_path = ENV['DOWNLOAD_PATH'] + '/' + params[:format].to_s + '/' +
                     params[:collection_id].to_s + '/' + params[:user_id].to_s +
                     '/derivatives/all-text/' + params[:collection_id].to_s +
                     '-fulltext.csv'
  end

  def textfilter_path
    @textfilter_path = ENV['DOWNLOAD_PATH'] + '/' + params[:format].to_s + '/' +
                       params[:collection_id].to_s + '/' +
                       params[:user_id].to_s + '/derivatives/filtered-text/' +
                       params[:collection_id].to_s + '-filtered_text.zip'
  end

  def correct_user
    @user = User.find(params[:user_id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def domains_chart_data
    display_domains(@user.id, @collection_id.id, @account[0])
  end
end
