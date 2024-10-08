# frozen_string_literal: true

module Decidim
  module SpamSignal
    # maintains compatibility with v0.26 which uses Rectify
    if defined? ::Decidim::Command
      class Command < ::Decidim::Command
      end
    else
      class Command < ::Rectify::Command
      end
    end
  end
end
