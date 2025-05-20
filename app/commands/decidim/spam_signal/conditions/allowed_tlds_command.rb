# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Conditions
      class AllowedTldsCommand < ConditionHandler
        def call
          return broadcast(:valid) if allowed_tlds_csv.empty?
          return broadcast(:valid) if all_allowed?

          broadcast(:invalid)
        end

        private

        def allowed_tlds_csv
          @allowed_tlds_csv ||= (
            config["allowed_tlds_csv"] || ""
          ).split(",").map(&:strip).filter { |tlds| !tlds.empty? }
        end

        def all_allowed?
          hosts.none? { |url| allowed_tlds_csv.none? { |tld| url.include? tld } }
        end

        def hosts
          URI.extract(suspicious_content, ["http", "https", "", "mailto"]).map do |uri|
            (_scheme, _subdomain, host) = URI.split(uri)
            host || ""
          rescue URI::InvalidURIError
            ""
          end
        end

        def regex(patterns)
          Regexp.union(patterns).source
        end
      end
    end
  end
end
