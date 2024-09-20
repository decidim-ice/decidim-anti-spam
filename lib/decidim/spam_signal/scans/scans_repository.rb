# frozen_string_literal: true

require "singleton"

module Decidim
  module SpamSignal
    module Scans
      ##
      # Strategies repository
      class ScansRepository
        include Singleton

        def initialize
          @_strategies = {}
        end

        def register(strategy, command_klass)
          @_strategies[strategy.to_sym] = command_klass
        end

        def unset_strategy(strategy)
          key = strategy.to_sym
          raise Error, "Cop's Strategy #{strategy} does not exists" unless @_strategies.has_key? key

          @_strategies.except!(key)
        end

        def strategies
          @_strategies.keys
        end

        def form_for(strategy)
          strategy(strategy).form
        end

        def strategy(strategy)
          key = strategy.to_s.to_sym
          return @_strategies[key] if @_strategies.has_key? key

          nil
        end
      end
    end
  end
end
