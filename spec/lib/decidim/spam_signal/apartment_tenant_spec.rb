# frozen_string_literal: true

require "spec_helper"

if Gem.loaded_specs.has_key?("decidim-apartment")
  require "decidim/apartment/test/factories"

  describe "spam_signal apartment tenant isolation" do
    let(:host_a) { "spam-a-#{SecureRandom.hex(4)}.example.org" }
    let(:host_b) { "spam-b-#{SecureRandom.hex(4)}.example.org" }
    let(:key_a) { create(:distribution_key, host: host_a) }
    let(:key_b) { create(:distribution_key, host: host_b) }

    before do
      register_dummy_condition!
      register_dummy_action!
      ensure_tenant!(key_a)
      ensure_tenant!(key_b)
    end

    after do
      drop_tenant!(key_a.key)
      drop_tenant!(key_b.key)
    end

    it "keeps spam_signal tables in each new tenant schema" do
      key_a.switch { expect(spam_signal_tables).to all(be_truthy) }
    end

    it "keeps conditions inside the tenant schema" do
      condition_id = create_condition_in!(key_a, host_a)
      key_b.switch do
        create(:organization, host: host_b)
        expect(Decidim::SpamSignal::Condition.where(id: condition_id)).not_to exist
      end
    end

    it "keeps flows invisible to another tenant" do
      key_a.switch do
        org = create(:organization, host: host_a)
        create_flow_with_condition!(org)
      end

      key_b.switch do
        org_b = create(:organization, host: host_b)
        expect(flows_for(org_b)).to be_empty
      end
    end

    it "keeps the anti-spam bot user inside the tenant schema" do
      bot_id = bot_id_in!(key_a, host_a)
      key_b.switch do
        create(:organization, host: host_b)
        expect(Decidim::User.where(id: bot_id)).not_to exist
        expect(Decidim::User.where(nickname: "bot")).not_to exist
      end
    end

    def register_dummy_condition!
      Decidim::SpamSignal.config.conditions_registry.register(
        "dummy",
        Decidim::SpamSignal::Conditions::DummyConditionSettingsForm,
        Decidim::SpamSignal::Conditions::DummyConditionCommand
      )
    end

    def register_dummy_action!
      Decidim::SpamSignal.config.actions_registry.register(
        "dummy",
        Decidim::SpamSignal::Actions::DummySettingsForm,
        Decidim::SpamSignal::Actions::DummyActionCommand
      )
    end

    def ensure_tenant!(distribution_key)
      return if pg_schema?(distribution_key.key)

      Apartment::Tenant.create(distribution_key.key)
    end

    def pg_schema?(name)
      ActiveRecord::Base.connection.select_value(
        "SELECT 1 FROM pg_namespace WHERE nspname = #{ActiveRecord::Base.connection.quote(name)}"
      ).present?
    end

    def drop_tenant!(key)
      Apartment::Tenant.drop(key) if pg_schema?(key)
      delete_distribution_key!(key)
    rescue StandardError
      nil
    end

    def spam_signal_tables
      conn = ActiveRecord::Base.connection
      %w(
        anti_spam_conditions anti_spam_flows anti_spam_flows_conditions
        anti_spam_settings user_report_flows
      ).map { |table| conn.table_exists?(table) }
    end

    def create_condition_in!(distribution_key, host)
      distribution_key.switch do
        organization = create(:organization, host:)
        create(:spam_signal_condition, organization:, condition_type: "dummy", name: "tenant-a").id
      end
    end

    def create_flow_with_condition!(organization)
      condition = create(:spam_signal_condition, organization:, condition_type: "dummy")
      flow = create(:spam_signal_flow, organization:, trigger_type: "TestApartmentForm")
      flow.conditions << condition
      flow
    end

    def flows_for(organization)
      Decidim::SpamSignal::Flow.where(organization:, trigger_type: "TestApartmentForm")
    end

    def bot_id_in!(distribution_key, host)
      distribution_key.switch do
        org = create(:organization, host:)
        Decidim::SpamSignal::AntiSpamUser.get(org).id
      end
    end

    def delete_distribution_key!(key)
      ::Apartment::Tenant.switch("public") do
        Decidim::Apartment::DistributionKey.where(key: key).find_each do |row|
          Decidim::Apartment::DistributionHost.where(apartment_distribution_key_id: row.id).delete_all
          row.delete
        end
      end
    end
  end
end
