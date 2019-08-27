ENV.each { |k, v| env(k, v) }
set :output, error: 'log/crontab_error.log', standard: 'log/crontab.log'
set :environment, :development

every 1.day, at: '4:30 am' do
  rake "update:item"
end