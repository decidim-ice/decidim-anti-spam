# frozen_string_literal: true

# This module overrides the `call` method in the UpdateAccount service.
# By using `prepend`, the module's `call` method takes precedence
# over the original method in the service.
#
# The overridden `call` method has been modified to broadcast a
# `:spam_detected` event with the errors if spam is detected.
module Decidim
  module UpdateAccountOverrides
    extend ActiveSupport::Concern

    prepended do
      def call
        return broadcast(:invalid, @form.password) unless @form.valid?
        
        update_personal_data
        update_avatar
        update_password
        
        
        if current_user.valid?
          changes = current_user.changed
          current_user.save!
          notify_followers
          send_update_summary!(changes)
          broadcast(:ok, current_user.unconfirmed_email.present?)
        else
          # Add the broadcast condition for spam_signal
          if current_user.errors.has_key?(:about)
            broadcast(:spam_detected, current_user.errors)
          else
            [:avatar, :password].each do |key|
              @form.errors.add key, current_user.errors[key] if current_user.errors.has_key? key
            end
            broadcast(:invalid, @form.password)
          end
        end
      end
    end
  end
end