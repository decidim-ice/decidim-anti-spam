# frozen_string_literal: true

module Decidim
  module SpamSignal
    describe SpamConfigRepo do
      let(:subject) { SpamConfigRepo }
      it "applies default value to spam configuration" do
        params = {}
        repository = subject.new("comments", params)
        expect(repository.config).to eq({
          "scans" => {},
          "rules" => {},
          "spam_cop" => {},
          "suspicious_cop" => {},
        })
      end

      context "rules" do 
        context "#rule()" do 
          it "gives the rule with the given id" do 
            repo = subject.new("comments", {"rules" => {"A17FS" => "salut"}})
            expect(repo.rule("A17FS")).to eq("salut")
          end

          it "gives nil if the given rule id does not exists" do
            repo = subject.new("comments", {"rules" => {"A17FS" => "salut"}})
            expect(repo.rule("404")).to eq(nil)
          end
        end

        context "#add_rule(rule)" do
          it "merge a rule to the ruleset" do
            repo = subject.new("comments", {"rules" => {"A17FS" => "salut"}})
            repo.add_rule("200" => "ok")
            expect(repo.rules).to eq({"A17FS" => "salut", "200" => "ok"})
          end
          it "override a rule if the ruleset already have the key" do
            repo = subject.new("comments", {"rules" => {"foo" => "tbal"}})
            repo.add_rule("foo" => "bar")
            expect(repo.rules).to eq({"foo" => "bar"})
            expect(repo.rule("foo")).to eq("bar")
          end
        end
        context "#rm_rule(rule)" do
          it "remove a rule with the given rule id" do
            repo = subject.new("comments", {"rules" => {"foo" => "bar"}})
            repo.rm_rule("foo")
            expect(repo.rules).to eq({"foo" => "bar"})
          end
          it "has no effect if the rule id does not exists" do
            repo = subject.new("comments", {"rules" => {"foo" => "bar"}})
            repo.rm_rule("nope")
            expect(repo.rules).to eq({"foo" => "bar"})
            expect(repo.rule("foo")).to eq("bar")
          end
        end

      end


    end
  end
end
