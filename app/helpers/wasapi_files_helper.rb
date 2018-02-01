# frozen_string_literal: true

# WasapiFiles helper methods.
module WasapiFilesHelper
  def collection_count(collection_id)
    WasapiFile.where(collection_id: collection_id).count
  end

  def collection_size(collection_id)
    file_size = WasapiFile.where(collection_id: collection_id).sum(:size)
    number_to_human_size(file_size)
  end
end
