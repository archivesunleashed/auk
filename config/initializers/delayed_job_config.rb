# frozen_string_literal: true

Delayed::Worker.max_run_time = 30.days
Delayed::Worker.logger = LogStashLogger.new(
  type: :file, path: 'log/logstash_delayed_job.log', sync: true
)
Delayed::Worker.max_attempts = 1
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.read_ahead = 50

# This let's us "retry" jobs that are stuck or failed too many times.
# Delayed::Job.find(1234).retry!
module Delayed
  module Backend
    module ActiveRecord
      # Hook into jobs.
      class Job
        def retry!
          self.run_at = Time.current - 1.day
          self.locked_at = nil
          self.locked_by = nil
          self.attempts = 0
          self.last_error = nil
          self.failed_at = nil
          self.save!
        end
      end
    end
  end
end
