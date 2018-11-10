# frozen_string_literal: true

# Methods for Collections
class Collection < ApplicationRecord
  self.primary_key = 'collection_id'
  has_many :wasapi_files, counter_cache: true
end
