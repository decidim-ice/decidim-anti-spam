# frozen_string_literal: true

require "singleton"

module Decidim
  module SpamSignal
    module Cops
      ##
      # Strategies repository
      class CopsRepository
        include Singleton
        attr_reader :strategies
        def initialize
          # Default strategies, can add others through set_strategy
          @strategies = {
          }
        end

        def register(strategy, command_klass)
          @strategies[strategy.to_sym] = command_klass
        end

        def unset_strategy(strategy)
          key = strategy.to_sym
          raise Error, "Cop's Strategy #{strategy} does not exists" unless @strategies.key? key
          @strategies.except!(key)
        end

        def strategy(strategy)
          key = strategy.to_sym
          return @strategies[key] if @strategies.key? key
          nil
        end
      end
    end
  end
end
