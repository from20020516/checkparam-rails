# Checkparam
> a Web site that provides gearset save and share for Final Fantasy XI.

## Requirements:
- Docker
- [Twitter API Key](https://developer.twitter.com/en/application/use-case)

## Usage:
```
bundle install --path vendor/bundle
rails db:migrate
rails db:seed
bash -c "cron && bundle exec whenever --update-crontab && rails s -b 0.0.0.0 -p 80"
```
