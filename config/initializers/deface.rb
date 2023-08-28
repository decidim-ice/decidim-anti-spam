# frozen_string_literal: true

require 'deface'

Rails.application.configure do
  config.deface = Deface::Environment.new
end