require 'spec_helper'
RSpec.describe "suspenders:database"  do

  it 'generates Postgres database config' do
    with_app { generate("suspenders:database") }
    # Gemfile recives PG gem
    expect("Gemfile").to match_contents(%r{gem .pg.})
    expect("config/database.yml").to match_contents(%r{adapter: postgresql})
    expect('db/schema.rb').to exist_as_a_file
    # database.yml gets new config
    # database gets created
  end

  it 'destroys database config' do
  end

end
