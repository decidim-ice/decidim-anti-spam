# frozen_string_literal: true

module Decidim
  module SpamSignal
    module SpamDetectionService
      class << self

        def valid?(content)
          !invalid?(content)
        end

        def invalid?(content)
          return false if content_has_go_list_tlds?(content)
          return true if content_has_stop_list_tlds?(content)
          content_has_uri?(content) && content_has_stop_list_worlds?(content)
        end

        private
          def content_has_uri?(content)
            content.match?(URI.regexp) unless content.nil?
          end

          def content_has_stop_list_worlds?(content)
            content.match(/#{regex(stop_list_worlds)}/i).to_s.present? unless content.nil?
          end

          def content_has_stop_list_tlds?(content)
            content.match(/#{regex(stop_list_tlds)}/i).to_s.present? unless content.nil?
          end

          def content_has_go_list_tlds?(content)
            content.match(/#{regex(go_list_tlds)}/i).to_s.present? unless content.nil?
          end

          def regex(patterns)
            Regexp.union(patterns)
          end

          def stop_list_worlds
            [ "seo", "sex", "escort", "mmda", "$$$", "#1", "0%", "99.9%", "100%", "50% OFF",
              "Access for free", "Access now", "Access right away",
              "Act now", "Apply NOW", "Apply Online", "Buy Now",
              "Buy direct", "Cancel at any time", "Make Money", "Best offer",
              "Best price", "Earn $", "Earn extra cash", "Free investment",
              "JACKPOT", "Lose weight", "Lose weight instantly", "Recover your debt",
              "Unlimited", "You will not believe your eyes", "Zero percent", "Affordable",
              "Cheap", "Confidential", "Viagra", "Valium", "VIP", "babes", "Rolex",
              "Marketing", "Meet women", "Mortgage", "Miracle", "Meet singles", "porn",
              "Stock alert", "Call Girl", "Sexy", "Extra offering", "Call Service", "unlimited pleasure"
            ]
          end

          def stop_list_tlds
            ["blackdomain.gg"]
          end

          def go_list_tlds
            ["lausanne.ch"]
          end

      end
    end
  end
end
