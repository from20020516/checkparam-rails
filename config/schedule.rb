# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# 日本語doc:
# https://morizyun.github.io/blog/whenever-gem-rails-ruby-capistrano/
# 設定:
# bundle exec whenever --update-crontab
# 削除:
# bundle exec whenever --clear-crontab

set :output, 'log/crontab.log'
set :environment, :production

every :monday, at: '5am' do # Use any day of the week or :weekend, :weekday
  command 'sudo certbot-auto renew --post-hook "sudo service nginx restart"'
end

# every 1.minute do # 1.minute 1.day 1.week 1.month 1.year is also supported
#   runner "parse:color"
# end

# every :day, at: '5am' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
#   runner ''
# end