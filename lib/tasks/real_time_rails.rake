namespace :real_time_rails do
  desc "generate config files"
  task :generate => :environment do
    
    require 'fileutils'
    FileUtils.mkdir_p 'cable'
    
    
    unless File.exist?(File.join(RAILS_ROOT,"cable","config.ru"))
    
      configru_string = <<-CONFIGRU.gsub /^\s+/, ""
        # cable/config.ru
        require ::File.expand_path('../../config/environment',  __FILE__)
        Rails.application.eager_load!

        require 'action_cable/process/logging'

        run ActionCable.server
      CONFIGRU
      File.open(File.join(RAILS_ROOT,"cable","config.ru"), "w") do |f|
        f.write configru_string
      end
    else
      puts "SKIPPING: config.ru already exists"
      puts
      puts "Below is the standard config:"
      puts configru_string
    end
  end

end