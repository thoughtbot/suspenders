require "spec_helper"

RSpec.describe "suspenders:production:error_tracker", type: :generator do
  it "inserts the HONEYBADGER_ENV into Heroku" do
    with_app { generate("suspenders:production:error_tracker") }

    # TODO
  end

  it "removes the HONEYBADGER_ENV from Heroku" do
    with_app { destroy("suspenders:production:error_tracker") }
  end
end
