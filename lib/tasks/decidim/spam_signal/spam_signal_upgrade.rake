# frozen_string_literal: true

Rake::Task["decidim:choose_target_plugins"].enhance do
  name = Decidim::SpamSignal::Engine.railtie_name
  ENV["FROM"] = "#{ENV.fetch("FROM", nil)},#{name}" unless ENV["FROM"].to_s.include?(name)
end

if Rake::Task.task_defined?("decidim:upgrade")
  Rake::Task["decidim:upgrade"].enhance do
    name = Decidim::SpamSignal::Engine.railtie_name
    Rake::Task["#{name}:webpacker:install"].invoke if Rake::Task.task_defined?("#{name}:webpacker:install")
  end
end
