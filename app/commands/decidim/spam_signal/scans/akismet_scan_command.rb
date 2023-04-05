# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Scans
      class AkismetScanCommand < ScanHandler
        def self.form
          ::Decidim::SpamSignal::NoSettingsForm
        end

        def call
          return broadcast(:ok) unless Decidim::Akismet.instance.ready?
          context = config["context"]
          current_request = Thread.current[:current_request]
          detection = Decidim::Akismet.instance.detect!(
            comment_type:  comment_type,
            current_organization: context[:current_organization],
            user: context[:author],
            user_ip: current_request[:real_ip],
            user_agent: current_request[:user_agent],
            referrer: current_request[:referrer],
            content: suspicious_content,
            date: context[:date],
            is_updating: context[:date],
            permalink: nil
          )
          case detection
          when :ham
            broadcast(:ok)
          when :suspicious
            broadcast(:akismet_suspicious)
          when :spam
            broadcast(:akismet_spam)
          end
        end

        def self.output_symbols
          [:akismet_spam, :akismet_suspicious]
        end

        private

          def context
            config["context"]
          end

          def comment_type
            case context["validator"]
            when "profile"
              "signup"
            when "comment-reply"
              "reply"
            when "comment"
              "comment"
            else
              "comment"
            end
          end
      end
    end
  end
end
