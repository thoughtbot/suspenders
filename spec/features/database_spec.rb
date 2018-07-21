# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_context 'Project Setup Hook' do |option|
  before :context do
    drop_dummy_database
    remove_project_directory
    run_suspenders option
    setup_app_dependencies
  end
end

RSpec.describe 'Suspend a new project with custom database option' do
  context '--database=sqlite3' do
    include_context 'Project Setup Hook', '--database=sqlite3'

    it 'adds sqlite3 to Gemfile' do
      gemfile = IO.read "#{project_path}/Gemfile"

      expect(gemfile).to match(/sqlite3/)
    end
  end

  context '--database=mysql' do
    include_context 'Project Setup Hook', '--database=mysql'

    it 'adds mysql2 to Gemfile' do
      gemfile = IO.read "#{project_path}/Gemfile"

      expect(gemfile).to match(/mysql2/)
    end
  end
end
