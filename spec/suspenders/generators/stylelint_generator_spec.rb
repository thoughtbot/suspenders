require "spec_helper"

RSpec.describe Suspenders::StylelintGenerator, type: :generator do
  def invoke_stylelint_generator!
    copy_file "hound.yml", ".hound.yml"
    invoke! Suspenders::StylelintGenerator
  end

  def revoke_stylelint_generator!
    revoke! Suspenders::StylelintGenerator
  end

  describe "invoke" do
    it "creates .stylelintrc.json" do
      with_fake_app do
        invoke_stylelint_generator!

        expect(".stylelintrc.json")
          .to match_contents(%r{"extends": "@thoughtbot/stylelint-config"})
      end
    end

    it "calls the lint generator" do
      with_fake_app do
        expect(Suspenders::LintGenerator)
          .to receive(:dispatch)
          .with(nil, [], [], hash_including(behavior: :invoke))

        invoke_stylelint_generator!
      end
    end

    it "adds stylelint and @thoughtbot/stylelint-config to the package.json" do
      with_fake_app do
        invoke_stylelint_generator!

        expect("package.json")
          .to have_yarned("add stylelint @thoughtbot/stylelint-config --dev")
      end
    end

    it "uncomments the hound config_file option" do
      with_fake_app do
        invoke_stylelint_generator!

        expect(".hound.yml").to(
          match_contents(/^  config_file: \.stylelintrc\.json/)
        )
      end
    end
  end

  context "revoke" do
    it "removes .stylelintrc.json" do
      with_fake_app do
        invoke_stylelint_generator!
        revoke_stylelint_generator!

        expect(".stylelintrc.json").not_to exist_as_a_file
      end
    end

    it "removes stylelint and @thoughtbot/stylelint-config from package.json" do
      with_fake_app do
        invoke_stylelint_generator!
        revoke_stylelint_generator!

        expect("package.json")
          .to have_yarned("remove stylelint @thoughtbot/stylelint-config")
      end
    end

    it "comments in the hound config_file option" do
      with_fake_app do
        invoke_stylelint_generator!
        revoke_stylelint_generator!

        expect(".hound.yml")
          .to match_contents(/^  # config_file: \.stylelintrc\.json/)
      end
    end
  end
end
