namespace :real_time_rails do
  desc "generate config files"
  task :setup => :environment do
    
    require 'fileutils'
    configru_string = <<-CONFIGRU.gsub /^\s+/, ""
      # cable/config.ru
      require ::File.expand_path('../../config/environment',  __FILE__)
      Rails.application.eager_load!
      require 'action_cable/process/logging'
      run ActionCable.server
    CONFIGRU
    
    cable_exe = <<-CABLEEXE.gsub /^\s+/, ""
      # /bin/bash
      bundle exec puma -p 28080 cable/config.ru
    CABLEEXE
    

    puts "create: cable/config.ru"
    FileUtils.mkdir_p 'cable'
    unless File.exist?(Rails.root.join("cable","config.ru"))
      File.open(Rails.root.join("cable","config.ru"), "w") do |f|
        f.write configru_string
      end
      puts "done"
    else
      puts "SKIPPING: config.ru already exists"
      puts
      puts "Below is the standard config:"
      puts configru_string.gsub(/^/, "\t")
      puts
    end
    
    puts "create: bin/cable"
    FileUtils.mkdir_p 'bin'
    unless File.exist?(Rails.root.join("bin","cable"))
      File.open(Rails.root.join("bin","cable"), "w") do |f|
        f.write cable_exe
      end
      `chmod +x #{Rails.root.join("bin","cable")}`
      puts "done"
    else
      puts "SKIPPING: bin/cable already exists"
      puts
      puts "Below is the standard config:"
      puts cable_exe.gsub(/^/, "\t")
      puts
    end
    
    
    puts "To start the cable server just run bundle exec cable"
  end

end