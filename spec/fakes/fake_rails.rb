module Rails
  RAILS_ENV = ENV.fetch("RAILS_ENV", "development")

  class Env < String
    def development?
      self == "development"
    end

    def test?
      self == "test"
    end

    def production?
      self == "production"
    end
  end

  def self.env
    @env ||= Env.new(RAILS_ENV)
  end
end
