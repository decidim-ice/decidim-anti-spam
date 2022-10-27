# frozen_string_literal: true

module Decidim
  module SpamSignal
    class RuleForm < Decidim::Form
      include Decidim::SpamSignal::SettingsForm
      attribute :rules, String
    end
  end
end
