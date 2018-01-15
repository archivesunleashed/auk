# frozen_string_literal: true

# Methods for Collections
class Collection < ApplicationRecord
  self.primary_key = 'collection_id'
  has_and_belongs_to_many :wasapi_files
end
