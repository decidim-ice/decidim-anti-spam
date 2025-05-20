# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Conditions
      class ForbiddenTldsCommand < ConditionHandler
        def call
          return broadcast(:invalid) if any_forbidden_tlds?

          broadcast(:valid)
        end

        private

        def forbidden_tlds_csv
          @forbidden_tlds_csv ||= (
            config["forbidden_tlds_csv"] || ""
          ).split(",").map(&:strip)
        end

        def any_forbidden_tlds?
          hosts.any? { |url| forbidden_tlds_csv.any? { |tld| url.include? tld } }
        end

        def hosts
          URI.extract(suspicious_content, ["http", "https", "", "mailto"]).map do |uri|
            (_scheme, _subdomain, host) = URI.split(uri)
            host
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
