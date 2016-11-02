class FakeMysql
  def self.has_gem_included?(project_path, gem_name)
    gemfile = File.open(File.join(project_path, "Gemfile"))

    File.foreach(gemfile).any? do |line|
      line.match(/#{Regexp.quote(gem_name)}/)
    end
  end

  def self.has_mysql_adapter?(project_path)
    database_config =
      File.open(File.join(project_path, "config", "database.yml"))

    File.foreach(database_config).any? do |line|
      line.match(/#{Regexp.quote("adapter: mysql2")}/)
    end
  end
end
