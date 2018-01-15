# frozen_string_literal: true

# WASAPI File methods.
class WasapiFile < ApplicationRecord
  belongs_to :users, optional: true
end
