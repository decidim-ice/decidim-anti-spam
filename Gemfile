# frozen_string_literal: true

source "https://rubygems.org"

base_path = "./"
base_path = "../../" if File.basename(__dir__) == "decidim_dummy_app"
base_path = "../" if File.basename(__dir__) == "development_app"

require_relative "#{base_path}lib/decidim/spam_signal/version"

DECIDIM_VERSION = "~> 0.27"

gem "decidim", DECIDIM_VERSION
gem "decidim-spam_signal", path: base_path

gem "bootsnap", "~> 1.4"
gem "puma", ">= 5.5.1"
gem "uglifier", "~> 4.1"

gem "deface", ">= 1.8.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "decidim-dev", "~> 0.27"
end

group :test do
  gem "capybara", "~> 3.24"
  gem "rspec-rails", "~> 4.0"
  gem "rubocop-faker"
  gem "selenium-webdriver"
end

group :development do
  gem "faker", "~> 2.14"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 4.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.0.4"
end
