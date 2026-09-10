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
      Decidim::SpamSignal.configure do |config|
        config.conditions_registry.register(
          "dummy",
          Decidim::SpamSignal::Conditions::DummyConditionSettingsForm,
          Decidim::SpamSignal::Conditions::DummyConditionCommand
        )
      end

      Apartment::Tenant.create(key_a.key) unless Apartment.tenant_names.include?(key_a.key)
      Apartment::Tenant.create(key_b.key) unless Apartment.tenant_names.include?(key_b.key)
    end

    after do
      drop_tenant!(key_a.key)
      drop_tenant!(key_b.key)
    end

    it "keeps conditions inside the tenant schema" do
      condition_id = nil

      key_a.switch do
        organization = create(:organization, host: host_a)
        condition = create(:spam_signal_condition, organization:, condition_type: "dummy", name: "tenant-a")
        condition_id = condition.id
        expect(Decidim::SpamSignal::Condition.where(id: condition_id)).to exist
      end

      key_b.switch do
        create(:organization, host: host_b)
        expect(Decidim::SpamSignal::Condition.where(id: condition_id)).not_to exist
      end
    end

    def drop_tenant!(key)
      Apartment::Tenant.drop(key) if Apartment.tenant_names.include?(key)
      ::Apartment::Tenant.switch("public") do
        Decidim::Apartment::DistributionKey.where(key: key).find_each do |distribution_key|
          Decidim::Apartment::DistributionHost.where(apartment_distribution_key_id: distribution_key.id).delete_all
          distribution_key.delete
        end
      end
    rescue StandardError
      nil
    end
  end
end
