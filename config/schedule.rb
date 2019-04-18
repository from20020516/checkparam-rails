# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# docs:
# https://morizyun.github.io/blog/whenever-gem-rails-ruby-capistrano/
# https://github.com/javan/whenever

# write job:
# sudo -E bundle exec whenever -w
# clear job:
# sudo -E bundle exec whenever -c
# check job:
# sudo crontab -l

# Rails.root PATH
require File.expand_path("#{File.dirname(__FILE__)}/environment")
set :output, Rails.root.join('log', 'crontab.log')
set :environment, :production

# every 1.minute do # 1.minute 1.day 1.week 1.month 1.year is also supported
# every :monday, at:'5am' do # :weekend, :weekday

every 1.day, at: '5am' do
  command 'sudo certbot-auto renew --post-hook "sudo service nginx restart"'
end

every :thursday, at: '5am' do
  command "cd #{Rails.root} && wget https://github.com/ProjectTako/ffxi-addons/raw/master/equipviewer/icons.7z -O public/icons.7z && 7za e public/icons.7z -aos -opublic/icons/ icons/64/*.png && git submodule foreach git pull origin master && export RAILS_ENV=production && rails csv:export && rails parse:items && bin/rails assets:precompile && kill -9 `pgrep -f puma` && bin/rails s -p 3000 -e production -d"
end

# test
# every 1.minute do
#   command "sudo service nginx restart >>#{Rails.root.join('log', 'cron_success.log')} 2>>#{Rails.root.join('log', 'cron_error.log')}"
# end
