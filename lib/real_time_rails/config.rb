
module RealTimeRails
  
  CONFIG = YAML.load_file("#{Rails.root.to_s}/config/realtimerails.yml")[Rails.env.to_s]
  
end
