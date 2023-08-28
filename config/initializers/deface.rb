# frozen_string_literal: true

require 'deface'

Rails.application.configure do
  config.deface = Deface::Environment.new
  config.deface.enable = ENV['DEFACE_ENABLED'] == true
end