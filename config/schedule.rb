# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# docs:
# https://morizyun.github.io/blog/whenever-gem-rails-ruby-capistrano/
# https://github.com/javan/whenever
#
# bundle exec whenever --update-crontab
# bundle exec whenever --clear-crontab

# Rails.root PATH
require File.expand_path(File.dirname(__FILE__) + "/environment")
set :output, "#{Rails.root}/log/crontab.log"
set :environment, :production

# every 1.minute do # 1.minute 1.day 1.week 1.month 1.year is also supported
# every :monday, at:'5am' do # :weekend, :weekday

every :monday, at: '5am' do
  command 'sudo certbot-auto renew --post-hook "sudo service nginx restart"'
end

every :thursday, at: '5am' do
  command "cd #{Rails.root}/public && wget https://github.com/ProjectTako/ffxi-addons/raw/master/equipviewer/icons.7z -O icons.7z && 7za x icons.7z -aoa icons/64 && cd ../Resources && git pull && cd .. && export RAILS_ENV=production && rails parse:items"
end