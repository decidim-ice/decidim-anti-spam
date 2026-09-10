# frozen_string_literal: true

# Decidim + apartment matrix (thoughtbot/appraisal).
# Root Gemfile stays vanilla Decidim ~> 0.29.2 (default CI).
#
#   bundle exec appraisal install
#   BUNDLE_GEMFILE=gemfiles/decidim_0.29_apartment.gemfile bundle exec rake test_app
#   BUNDLE_GEMFILE=gemfiles/decidim_0.29_apartment.gemfile bundle exec rspec
#
# Do not reuse a vanilla dummy for the apartment appraisal — regenerate test_app.
# Local path to decidim-apartment-integration-gem is reference only; CI uses GitLab.

appraise "decidim-0.29-apartment" do
  gem "decidim", "~> 0.29.2"
  gem "decidim-dev", "~> 0.29.2"
  gem "decidim-apartment",
      git: "https://gitlab.com/lappis-unb/decidimbr/infra/participa-gem",
      branch: "feat/imports"
  gem "ros-apartment", "3.4.4", require: "apartment"
  gem "decidim-toggle",
      git: "https://git.octree.ch/decidim/vocacity/decidim-modules/decidim-toggle",
      branch: "main"
end
