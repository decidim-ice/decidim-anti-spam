# frozen_string_literal: true

module Decidim
  module SpamSignal
    describe SettingsForm do
      class StubForm < Decidim::Form
        include SettingsForm
      end

      it "uses context.handler_name for model_name" do
        subject = StubForm.new.with_context(handler_name: "foo")
        expect(subject.model_name.human).to eq("Foo")
      end

      it "#handler_name raises an error if no context is passed" do
        expect do
          StubForm.new.handler_name
        end.to raise_error Error
      end
    end
  end
end
