# frozen_string_literal: true

Rake::Task["decidim:choose_target_plugins"].enhance do
  ENV["FROM"] = "#{ENV.fetch("FROM", nil)},decidim_spam_signal" unless ENV["FROM"].to_s.include?("decidim_spam_signal")
end

Rake::Task["decidim:upgrade"].enhance do
  Rake::Task["decidim_spam_signal:install:migrations"].invoke if Rake::Task.task_defined?("decidim_spam_signal:install:migrations")
end
