# frozen_string_literal: true

class SpamScan < Decidim::SpamSignal::Scans::ScanHandler
  def call
    broadcast(:spam)
  end
end

class SuspiciousScan < Decidim::SpamSignal::Scans::ScanHandler
  def call
    broadcast(:suspicious)
  end
end

class OkScan < Decidim::SpamSignal::Scans::ScanHandler
  def call
    broadcast(:ok)
  end
end
