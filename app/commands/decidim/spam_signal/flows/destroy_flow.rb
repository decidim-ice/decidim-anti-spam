# frozen_string_literal: true

module Decidim
  module SpamSignal
    module Flows
      class DestroyFlow < ApplicationCommand
        def initialize(flow)
          @flow = flow
        end

        def call
          destroy_flow

          broadcast(:ok)
        end

        private

        def destroy_flow
          delete_flow_condition
          @flow.delete
        end

        def delete_flow_condition
          flow_condition.each(&:destroy)
        end

        def flow_condition
          @flow_condition = Decidim::SpamSignal::FlowCondition.where(anti_spam_flow_id: @flow.id)
        end
      end
    end
  end
end
