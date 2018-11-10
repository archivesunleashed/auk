# frozen_string_literal: true

# WASAPI File methods.
class WasapiFile < ApplicationRecord
  belongs_to :users, optional: true, counter_cache: true
  belongs_to :collections, optional: true, counter_cache: true
end
