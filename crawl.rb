#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require
require 'json'

post_banks_mapping = JSON.parse(ENV.fetch('DRWALLET_BANKS_MAPPING'))

# require 'capybara-webkit'
# Capybara.javascript_driver = :webkit

# Capybara::Webkit.configure do |config|
#   config.allow_url("www.drwallet.jp")
#   config.block_unknown_urls
# end

# s = Capybara::Session.new(:webkit)

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    url: ENV.fetch('SELENIUM_URI'),
    desired_capabilities: ENV.fetch('SELENIUM_DESIRED_CAPABILITIES').to_sym
end

Capybara.configure do |config|
  config.default_driver    = :selenium
  config.javascript_driver = :selenium
end

s = Capybara::Session.new(:selenium)

s.visit 'https://www.drwallet.jp/users/sign_in'

s.fill_in :'メールアドレス', with: ENV.fetch('DRWALLET_ID')
s.fill_in :'パスワード',    with: ENV.fetch('DRWALLET_PASSWORD')

s.find('#signup-view-signup-button').click

wallet = {}

s.all('.account_item').map do |item|
  k = item.find('.account_item_head').text
  v = item.find('.account_item_status').text
  wallet[k] = v.gsub(',', '').gsub('￥', '').scan(/-?\d+/)[0].to_i
end

post_text = ''
post_text += "口座残高:\n"

bank_status_str = post_banks_mapping.each do |(in_name, out_name)|
  post_text += "- #{out_name}: #{wallet[in_name]}円\n"
end

post_text += "\n総資産: #{wallet.values.inject(:+)}円"

def slack_post(url, payload)
  Net::HTTP.post_form(url, { payload: payload.to_json })
end

slack_post(URI(ENV.fetch('SLACK_WEBHOOK_URL')),
{
  channel: ENV.fetch('SLACK_POST_CHANNEL'),
  username: 'Dr.Wallet',
  text: post_text,
  icon_url: 'https://www.drwallet.jp/assets/apple-touch-icon.png'
})
