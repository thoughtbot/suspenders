  if ENV.fetch("HEROKU_APP_NAME", "").include?("staging-pr-")
    ENV["APPLICATION_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"
    ENV["ASSET_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"
  end

