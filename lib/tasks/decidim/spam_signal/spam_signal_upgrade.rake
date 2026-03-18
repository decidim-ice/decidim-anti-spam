# frozen_string_literal: true

MODULE_NAME = "decidim-spam_signal"
RAILTIE_NAME = Decidim::SpamSignal::Engine.railtie_name

Rake::Task["decidim:choose_target_plugins"].enhance do
  ENV["FROM"] = "#{ENV.fetch("FROM", nil)},#{MODULE_NAME}" unless ENV["FROM"].to_s.include?(MODULE_NAME)
end

if Rake::Task.task_defined?("decidim:upgrade")
  Rake::Task["decidim:upgrade"].enhance do
    Rake::Task["#{RAILTIE_NAME}:install:migrations"].invoke if Rake::Task.task_defined?("#{RAILTIE_NAME}:install:migrations")
    Rake::Task["#{RAILTIE_NAME}:webpacker:install"].invoke if Rake::Task.task_defined?("#{RAILTIE_NAME}:webpacker:install")
  end
end
