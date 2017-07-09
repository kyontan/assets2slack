# assets2slack

_to share your assets to others_

Post your total assets and each banks assets to Slack

## Screenshot

![](https://dev.monora.me/img/assets2slack_example.png?v2)

## How to use

### On-premise

#### Prepare

```
# git pull git@github.com:kyontan/assets2slack.git
# cd assets2slack
# cp .env{.sample,}
# # Edit .env
# bundle install --path vendor/bundle
```

Maybe, you want to use `capybara-webkit`, or you can use any selenium drivers.

#### Use

```
# bundle exec ruby crawler.rb
```

### Docker

you need `docker-compose` to use this.

Available image for Docker Hub: [kyontan/assets2slack](https://hub.docker.com/r/kyontan/assets2slack/)

#### Prepare

```
# git pull git@github.com:kyontan/assets2slack.git
# cd assets2slack
# cp .env{.sample,}
# # Edit .env
# docker-compose pull
```

#### Use

```
# docker-compose run crawler --rm
```

The container is up once for crawl and post to Slack, and then deleted.

## License

These codes are licensed under CC0.

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.ja)
