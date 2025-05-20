# frozen_string_literal: true

require "spec_helper"

describe Decidim::SpamSignal::Flows::FlowValidator do
  class TestOverrideForm < Decidim::Form
    include Decidim::SpamSignal::Flows::FlowValidator
    def self.available_actions = ["dummy"]

    def self.available_conditions = ["dummy"]

    def skip_antispam?
      false
    end

    def antispam_trigger_type
      "TestOverrideForm"
    end

    def current_organization; end

    def suspicious_user; end

    def spam_error_keys
      [:test]
    end

    def content_for_antispam
      "test"
    end

    def reportable_content; end

    def before_antispam; end

    def after_antispam; end
  end

  let!(:form) { TestOverrideForm.new }

  let(:organization) { create(:organization) }
  let(:tested_suspicious_user) { create(:user, organization:) }
  let(:tested_reportable_content) { create(:comment) }

  let(:condition) do
    create(:spam_signal_condition, organization:, condition_type: "dummy")
  end
  let(:flow_without_conditions) do
    create(:spam_signal_flow, trigger_type: "TestOverrideForm", organization:, conditions: [])
  end
  let(:flow_with_conditions) do
    created_flow = flow_without_conditions
    created_flow.conditions << condition
    created_flow
  end

  # Setup the registry
  before do
    Decidim::SpamSignal.config.conditions_registry.register(
      :dummy,
      Decidim::SpamSignal::Conditions::DummyConditionSettingsForm,
      Decidim::SpamSignal::Conditions::DummyConditionCommand
    )
    Decidim::SpamSignal.config.actions_registry.register(
      :dummy,
      Decidim::SpamSignal::Actions::DummySettingsForm,
      Decidim::SpamSignal::Actions::DummyActionCommand
    )
    Decidim::SpamSignal::FlowCondition.delete_all
    Decidim::SpamSignal::Flow.delete_all
    allow(form).to receive(:current_organization).and_return(organization)
    allow(form).to receive(:suspicious_user).and_return(tested_suspicious_user)
    allow(form).to receive(:content_for_antispam).and_return(tested_reportable_content.body)
    allow(form).to receive(:reportable_content).and_return(tested_reportable_content)
    allow(form).to receive(:skip_antispam?).and_return(false)
    allow(form).to receive(:before_antispam).and_return("#before_antispam")
    allow(form).to receive(:after_antispam).and_return("#after_antispam")
  end

  describe "#detect_spam!" do
    describe "skip_antispam?" do
      before do
        allow(form).to receive(:skip_antispam?).and_return(true)
        flow_with_conditions
      end

      describe "when skip_antispam is true" do
        it "does not call the before_antispam method" do
          form.detect_spam!
          expect(form).not_to have_received(:before_antispam)
        end
      end

      describe "when skip_antispam is false" do
        before do
          allow(form).to receive(:skip_antispam?).and_return(false)
        end

        it "calls the before_antispam method" do
          form.detect_spam!
          expect(form).to have_received(:before_antispam)
        end
      end
    end

    describe "with no saved flows" do
      it "does not call the before_antispam method" do
        allow(condition.command).to receive(:call).and_return(valid: {})
        form.detect_spam!
        expect(form).not_to have_received(:before_antispam)
      end
    end

    describe "with saved flows and conditions" do
      before do
        allow(Decidim::SpamSignal::Actions::ActionCommand).to receive(:call)
        flow_with_conditions
      end

      it "run the conditions" do
        allow(condition.command).to receive(:call)
        form.detect_spam!
        expect(condition.command).to have_received(:call)
      end

      it "doesn't call ActionCommand if no conditions are met" do
        allow(condition.command).to receive(:call).and_return(valid: {})
        form.detect_spam!
        expect(Decidim::SpamSignal::Actions::ActionCommand).not_to have_received(:call)
      end

      it "calls ActionCommand if at least one condition is met" do
        allow(condition.command).to receive(:call).and_return(invalid: {})
        form.detect_spam!
        expect(Decidim::SpamSignal::Actions::ActionCommand).to have_received(:call)
      end
    end

    describe "#before_antispam" do
      describe "when a flow with at least one condition exists for the trigger type" do
        before { flow_with_conditions }

        it "calls the before_antispam method" do
          form.detect_spam!
          expect(form).to have_received(:before_antispam)
        end
      end

      describe "when a flow with no conditions exists for the trigger type" do
        before { flow_without_conditions }

        it "does not calls the before_antispam method" do
          form.detect_spam!
          expect(form).not_to have_received(:before_antispam)
        end
      end
    end
  end
end
