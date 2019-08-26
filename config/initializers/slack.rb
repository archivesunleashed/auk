# frozen_string_literal: true

SLACK = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL'],
                            channel: '#auk-jobs',
                            username: 'auk-bot',
                            icon_emoji: ':auk:'
