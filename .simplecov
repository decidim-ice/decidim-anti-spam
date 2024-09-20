# frozen_string_literal: true

if ENV["SIMPLECOV"]
  SimpleCov.start do
    track_files "**/*.rb"

    # We ignore some of the files because they are never tested
    add_filter "/config/"
    add_filter "/db/"
    add_filter "/vendor/"
    add_filter "/spec/"
    add_filter "/test/"
    add_filter %r{^/decidim-[^/]*/lib/decidim/[^/]*/engine.rb}
    add_filter %r{^/decidim-[^/]*/lib/decidim/[^/]*/admin-engine.rb}
    add_filter %r{^/decidim-[^/]*/lib/decidim/[^/]*/component.rb}
    add_filter %r{^/decidim-[^/]*/lib/decidim/[^/]*/participatory_space.rb}
  end

  SimpleCov.merge_timeout 1800

  if ENV["CI"]
    require "simplecov-cobertura"
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  end
end
