# frozen_string_literal: true

source "https://rubygems.org"

base_path = ""
base_path = "../../" if File.basename(__dir__) == "dummy"
require_relative "#{base_path}lib/decidim/spam_signal/version"

DECIDIM_VERSION = Decidim::SpamSignal.version

gem "decidim", DECIDIM_VERSION
gem "decidim-spam_signal", path: "."

gem "puma", ">= 4.3"
gem "bootsnap", "~> 1.4"
gem "uglifier", "~> 4.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", "~> 0.24.3"
end

group :test do
  gem "rspec-rails", "~> 3.9.1"
end

group :development do
  gem "faker", "~> 2.14"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end
