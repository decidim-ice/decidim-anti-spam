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
  s.add_dependency "decidim-core", Decidim::SpamSignal.decidim_version
  s.add_dependency "decidim-admin", Decidim::SpamSignal.decidim_version
  s.add_dependency "decidim-comments", Decidim::SpamSignal.decidim_version
  s.add_dependency "deface", '~> 1.8', '>= 1.8.1'

end
