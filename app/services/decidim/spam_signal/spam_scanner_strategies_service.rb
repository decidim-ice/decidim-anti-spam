# frozen_string_literal: true
require 'singleton'

module Decidim
  module SpamSignal
    ##
    # Strategies repository
    class SpamScannerStrategiesService
      include Singleton
      attr_reader :strategies
      def initialize
        # Default strategies, can add others through set_strategy
        @strategies = {
          none: Scanners::NoneScanCommand.class,
          word_and_links: Scanners::WordAndLinksScanCommand.class,
        }
      end

      def set_strategy(strategy, command_klass)
        @strategies[strategy.to_sym] = command_klass
      end

      def unset_strategy(strategy)
        key = strategy.to_sym
        raise Error, "Can not remove :none strategy" if key == :none
        raise Error, "Cop's Strategy #{strategy} does not exists" unless @strategies.has? key
        @strategies.except!(key)
      end

      def strategy(strategy)
        key = strategy.to_sym
        return @strategies[key] if @strategies.has? key
        @strategies[:none]
      end
    end
  end
end
