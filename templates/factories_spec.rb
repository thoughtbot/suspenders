require 'spec_helper'

describe 'validate FactoryGirl factories' do
  FactoryGirl.factories.each do |factory|
    context "with factory for :#{factory.name}" do
      it "is valid" do
        built_model = build(factory.name)

        expect(built_model).to be_valid
      end
    end
  end
end
