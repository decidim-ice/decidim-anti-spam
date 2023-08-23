# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scans
      class ForbiddenTldsScanCommand < ScanHandler
        def self.form
          ::Decidim::SpamSignal::Scans::ForbiddenTldsForm
        end

        def call
          return broadcast(:forbidden_tlds_found) if any_forbidden_tlds?
          broadcast(:ok)
        end

        def self.output_symbols
          [:forbidden_tlds_found]
        end

        private

          def forbidden_tlds_csv
            @forbidden_tlds_csv ||= (
              config["forbidden_tlds_csv"] || ""
            ).split(",").map(&:strip)
          end

          def any_forbidden_tlds?
            hosts.filter { |url| forbidden_tlds_csv.any? { |tld| url.include? tld } }.present?
          end

          def hosts
            URI.extract(suspicious_content, ["http", "https", "", "mailto" ]).map do |uri|
              begin
                (scheme, subdomain, host) = URI.split(uri)
                host
              rescue URI::InvalidURIError
                ""
              end
            end
          end

          def regex(patterns)
            Regexp.union(patterns).source
          end
      end
    end
  end
end
