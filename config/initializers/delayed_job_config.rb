# frozen_string_literal: true

Delayed::Worker.max_run_time = 14.days
Delayed::Worker.logger = Logger.new(Rails.root.join('log', 'delayed_job.log'))
Delayed::Worker.max_attempts = 3
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.read_ahead = 20
