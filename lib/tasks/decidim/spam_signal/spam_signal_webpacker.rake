# frozen_string_literal: true

require "decidim/gem_manager"

namespace :decidim_spam_signal do
  namespace :webpacker do
    desc "Installs Spam Signal webpacker files in Rails instance application"
    task install: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_spam_signal_npm
    end

    desc "Adds Spam Signal dependencies in package.json"
    task upgrade: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_spam_signal_npm
    end

    def install_spam_signal_npm
      return if spam_signal_npm_dependencies.empty?

      puts "install NPM packages. You can also do this manually with this command:"
      puts "npm i #{spam_signal_npm_dependencies.join(" ")}"
      spam_signal_system! "npm i #{spam_signal_npm_dependencies.join(" ")}"
    end

    def spam_signal_npm_dependencies
      @spam_signal_npm_dependencies ||= begin
        package_json = JSON.parse(File.read(spam_signal_path.join("package.json")))

        (package_json["dependencies"] || {}).map { |package, version| "#{package}@#{version}" }
      end
    end

    def spam_signal_path
      @spam_signal_path ||= Pathname.new(spam_signal_gemspec.full_gem_path) if Gem.loaded_specs.has_key?(spam_signal_gem_name)
    end

    def spam_signal_gemspec
      @spam_signal_gemspec ||= Gem.loaded_specs[spam_signal_gem_name]
    end

    def rails_app_path
      @rails_app_path ||= Rails.root
    end

    def spam_signal_system!(command)
      system("cd #{rails_app_path} && #{command}") || abort("\n== Command #{command} failed ==")
    end

    def spam_signal_gem_name
      "decidim-spam_signal"
    end
  end
end
