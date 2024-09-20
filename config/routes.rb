# frozen_string_literal: true

Decidim.register_global_engine :spam_signal, Decidim::SpamSignal::Engine, at: "/spam_signal"
