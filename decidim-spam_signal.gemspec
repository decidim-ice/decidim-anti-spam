# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/spam_signal/version"

Gem::Specification.new do |s|
  s.version = Decidim::SpamSignal.version
  s.authors = ["Hadrien Froger", "Renato Silva"]
  s.email = ["hadrien@octree.ch", "renato@octree.ch"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/octree-gva/decidim-module-spam_signal"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-spam_signal"
  s.summary = "A decidim spam_signal module"
  s.description = "Spam signal module for Lausanne's Decidim."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE.md", "Rakefile", "README.md"]

  s.require_paths = ["lib"]
  s.add_dependency "decidim-core", Decidim::SpamSignal.version
  s.add_dependency "decidim", Decidim::SpamSignal.version
  s.add_dependency "rails"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec_junit_formatter"
  s.add_development_dependency "decidim-dev", Decidim::SpamSignal.version
  s.add_development_dependency "decidim-consultations", Decidim::SpamSignal.version
  s.add_development_dependency "decidim-participatory_processes", Decidim::SpamSignal.version
  s.add_development_dependency "decidim-proposals", Decidim::SpamSignal.version
  s.add_development_dependency "decidim", Decidim::SpamSignal.version

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "bootsnap"
  s.add_development_dependency "puma"
  s.add_development_dependency "uglifier"
  s.add_development_dependency "codecov"
end
