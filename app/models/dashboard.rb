# frozen_string_literal: true

# Dashboard methods.
class Dashboard < ApplicationRecord
  validates :job_id, presence: true
  validates :user_id, presence: true
  validates :queue, presence: true
  validates :start_time, presence: true
end
