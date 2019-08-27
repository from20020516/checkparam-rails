# Checkparam
> a Web site that provides gearset save and share for Final Fantasy XI.

## Requirements:
- Docker
- [Twitter API Key](https://developer.twitter.com/en/application/use-case)

## Usage:
```sh
$ git clone https://github.com/from20020516/checkparam-rails.git
$ cd checkparam-rails/
$ git submodule foreach git pull origin master
$ docker-compose build
$ docker-compose run app bundle install
$ echo -e 'DOMAIN=localhost\nSTAGE=local\nAPP_ENV=development' > .env
$ rm config/credentials.yml.enc
$ docker-compose run app rails credentials:edit
```
Add your Twitter API keys.
```yml
# aws:
#   access_key_id: 123
#   secret_access_key: 345

# Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
secret_key_base: # Auto generated keybase.
twitter:
  twitter_api_key: # ADD YOUR API KEY HERE
  twitter_api_secret: # ADD YOUR API SECRET HERE
```
```
$ docker-compose run app rails db:migrate
$ docker-compose run app rails db:seed
$ docker-compose up
$ curl localhost
```