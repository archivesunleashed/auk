# frozen_string_literal: true

# Dashboard methods.
class Dashboard < ApplicationRecord
  has_many :collections
  has_many :users
  paginates_per 20
end
