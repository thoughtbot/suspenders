require 'spec_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "factory #{factory_name}" do
    it 'is valid' do
      factory = build(factory_name)

      if factory.respond_to?(:valid?)
        expect(factory).to be_valid, factory.errors.full_messages.join(',')
      end
    end
  end
end
