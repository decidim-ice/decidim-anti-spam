# frozen_string_literal: true

require "singleton"

module Decidim
  module SpamSignal
    module Scans
      ##
      # Strategies repository
      class ScansRepository
        include Singleton
        attr_reader :strategies

        def initialize
          @_strategies = {}
        end

        def register(strategy, command_klass)
          @_strategies[strategy.to_sym] = command_klass
        end

        def unset_strategy(strategy)
          key = strategy.to_sym
          raise Error, "Cop's Strategy #{strategy} does not exists" unless @_strategies.key? key
          @_strategies.except!(key)
        end

        def strategies
          @_strategies.keys
        end

        def form_for(strategy)
          strategy(strategy).form
        end

        def strategy(strategy)
          key = "#{strategy}".to_sym
          return @_strategies[key] if @_strategies.key? key
          nil
        end
      end
    end
  end
end
