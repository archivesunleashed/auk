# frozen_string_literal: true

Delayed::Worker.max_run_time = 3.days
Delayed::Worker.logger = Logger.new(Rails.root.join('log', 'delayed_job.log'))
