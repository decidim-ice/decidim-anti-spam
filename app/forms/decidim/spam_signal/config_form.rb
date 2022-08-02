# frozen_string_literal: true

module Decidim
  module SpamSignal
    class ConfigForm < Decidim::Form
      mimic :config
      attribute :profile_scan, String
      attribute :comment_scan, String
      attribute :profile_obvious_cop, String
      attribute :profile_suspicious_cop, String
      attribute :comment_obvious_cop, String
      attribute :comment_suspicious_cop, String
    end
  end
end
