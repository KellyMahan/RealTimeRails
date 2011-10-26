
module RealTimeRails
  
  def self.config
    @@config_file_options ||= begin
      config_path = Rails.root.join('config','realtimerails.yml')
      YAML.load_file(config_path)[Rails.env.to_s]
    end
  end
    
end
