# frozen_string_literal: true

require "fileutils"
require "rake"
require "rake/file_utils"
require "yaml"

require "decidim/dev/common_rake"

# Appraisal/CI often set a relative BUNDLE_GEMFILE; dummy chdir breaks that path.
def expand_bundle_gemfile!
  gemfile = ENV["BUNDLE_GEMFILE"]
  return if gemfile.nil? || gemfile.empty? || File.absolute_path?(gemfile)

  ENV["BUNDLE_GEMFILE"] = File.expand_path(gemfile, __dir__)
end

def apartment_loaded?
  Gem.loaded_specs.has_key?("decidim-apartment")
end

def run!(cwd, command)
  FileUtils.chdir(cwd) { sh(command) }
end

def install_module(path)
  expand_bundle_gemfile!
  run!(path, "bundle exec rails decidim_spam_signal_admin:install:migrations")
  return unless apartment_loaded?

  run!(path, "bundle exec rails decidim_toggle:install:migrations")
  run!(path, "bundle exec rails decidim_apartment:install:migrations")
end

def seed_db(path)
  run!(path, "bundle exec rails db:seed")
end

def common_db_config
  config = {
    "adapter" => "postgresql",
    "encoding" => "unicode",
    "host" => ENV.fetch("DATABASE_HOST", "spam-signal-pg"),
    "port" => ENV.fetch("DATABASE_PORT", "5432").to_i,
    "username" => ENV.fetch("DATABASE_USERNAME", "decidim"),
    "password" => ENV.fetch("DATABASE_PASSWORD", "pleaseChangeMe"),
    "database" => "#{base_app_name}_test_app"
  }
  config["schema_search_path"] = "public,shared_extensions" if apartment_loaded?
  config
end

desc "Prepare for testing"
task :prepare_tests do
  expand_bundle_gemfile!
  disable_docker_compose = ENV.fetch("DISABLED_DOCKER_COMPOSE", "false") == "true"
  unless disable_docker_compose
    sh("docker-compose -f docker-compose.yml down -v --remove-orphans")
    sh("docker-compose -f docker-compose.yml up -d")
  end
  ENV["RAILS_ENV"] = "development"
  database_yml = {
    "test" => common_db_config,
    "development" => common_db_config
  }

  config_file = File.expand_path("spec/decidim_dummy_app/config/database.yml", __dir__)
  File.open(config_file, "w") { |f| YAML.dump(database_yml, f) }
  dummy = File.expand_path("spec/decidim_dummy_app", __dir__)
  run!(dummy, "bundle exec rails db:drop")
  run!(dummy, "bundle exec rails db:create")
  run!(dummy, "bundle exec rails db:migrate")
end

desc "Generates a dummy app for testing"
task :test_app do
  expand_bundle_gemfile!
  Bundler.with_original_env do
    expand_bundle_gemfile!
    generate_decidim_app(
      "spec/decidim_dummy_app",
      "--app_name",
      "#{base_app_name}_test_app",
      "--path",
      "../..",
      "--skip_spring",
      "--demo",
      "--force_ssl",
      "false",
      "--locales",
      "en,fr,es,ca"
    )
  end
  install_module("spec/decidim_dummy_app")
  Rake::Task["prepare_tests"].invoke
end

desc "Generates a development app"
task :development_app do
  expand_bundle_gemfile!
  Bundler.with_original_env do
    expand_bundle_gemfile!
    generate_decidim_app(
      "development_app",
      "--app_name",
      "#{base_app_name}_development_app",
      "--path",
      "..",
      "--recreate_db",
      "--demo"
    )
  end
end
