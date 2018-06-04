# frozen_string_literal: true

Delayed::Worker.max_run_time = 30.days
Delayed::Worker.logger = LogStashLogger.new(
  type: :file, path: 'log/logstash_delayed_job.log', sync: true
)
Delayed::Worker.max_attempts = 1
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.read_ahead = 50
