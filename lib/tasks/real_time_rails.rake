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
    
    redis_yml = <<-REDIYML.gsub /^\s+/, ""
    local: &local
      :url: redis://localhost:6379
      :host: localhost
      :port: 6379
      :timeout: 1
      :inline: true
    development: *local
    test: *local
    REDIYML
    
    channel_rb = <<-CHANNELSTR
    class RealTimeRailsChannel < ApplicationCable::Channel
      def subscribed
        stop_all_streams
        stream_from "real_time_rails"
      end

      def unfollow
        stop_all_streams
      end
    end
    CHANNELSTR

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
    
    puts "create: config/redis/cable.yml"
    FileUtils.mkdir_p 'config/redis'
    unless File.exist?(Rails.root.join("config","redis","cable.yml"))
      File.open(Rails.root.join("config","redis","cable.yml"), "w") do |f|
        f.write redis_yml
      end
      puts "done"
    else
      puts "SKIPPING: config/redis/cable.yml already exists"
      puts
      puts "Below is the standard config:"
      puts redis_yml.gsub(/^/, "\t")
      puts
    end
    
    puts "create: app/channels/real_time_rails_channel.rb"
    FileUtils.mkdir_p 'app/channels'
    unless File.exist?(Rails.root.join("app","channels","real_time_rails_channel.rb"))
      File.open(Rails.root.join("app","channels","real_time_rails_channel.rb"), "w") do |f|
        f.write channel_rb
      end
      puts "done"
    else
      puts "SKIPPING: app/channels/real_time_rails_channel.rb already exists"
      puts
      puts "Below is the standard config:"
      puts channel_rb.gsub(/^/, "\t")
      puts
    end
    
    
    puts "To start the cable server just run bundle exec cable"
  end

end