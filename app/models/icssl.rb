class Icssl < ActiveRecord::Base
  
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  require 'active_support/core_ext/hash/conversions'
  
  def self.new_from_lookup()
  
  # doc = Nokogiri::HTML(open("https://www.accessdata.fda.gov/scripts/shellfish/sh/shippers.cfm?country=US&state=NY"))
  file = File.read('ny_icssl.htm')
  doc = Nokogiri::HTML(file)
  
  @headers = []
  doc.xpath('//*/table/thead/tr/th').each do |th|
      @headers << th.text
  end
  
  @rows = []
  doc.xpath('//*/table/tbody/tr')[1..-1].each_with_index do |row, i|
      @rows[i] = {}
      row.xpath('td').each_with_index do |td, j|
          @rows[i][@headers[j]] = td.text
      end
  end
  
  # print cert numbers formatted NY-123-SS
  def get_full_list
      count = 1
      puts "The following is the list of all dealers in NY:"
      @rows.each do |row|
        cert = "#{row.values[2].strip}-#{row.values[3]}-#{row.values[4]}"
        puts "#{count}. #{row.values[0]} / #{row.values[1]} / (#{cert})"
        count +=1
      end
      puts "There are #{@rows.size} shellfish dealers as of #{Time.now}"
  end
  
  # print dealers with aquaculture permits
  def get_aqua
      count = 1
      puts "The following dealers have aquaculture permits:"
      @rows.each do |row|
        symbol = row.values[4]
        if symbol.include? "AQ"
            puts "#{count}. #{row.values[0]}"
            count +=1
        end
      end
  end
  
  # print dealers with wet storage permits
  def get_ws
      count = 1
      puts "The following dealers have wet storage permits:"
      @rows.each do |row|
        symbol = row.values[4]
        if symbol.include? "WS"
            puts "#{count}. #{row.values[0]}"
            count +=1
        end
      end
  end
  
  
  # print dealers who can receive from harvesters
  def get_rfh
      count = 1
      puts "The following dealers are authorized to buy from harvesters:"
      @rows.each do |row|
        name = row.values[0]
        if name.include? "*"
            puts "#{count}. #{row.values[0]}"
            count +=1
        end
      end
  end
  
  # print dealers who are dshippers
  def get_dshipper
      count = 1
      puts "The following dealers are D-Shippers:"
      @rows.each do |row|
        number = row.values[3]
        if number.to_s.length > 3
            puts "#{count}. #{row.values[0]}"
            count +=1
        end
      end
  end
  
  # search for dealer names and their permit #
  def search_name
      count = 1
      puts "Enter dealer name:"
      input = gets.chomp
      
      puts "The following is your result:"
      @rows.each do |row|
        if row.values[0].include? input.upcase
            cert = "#{row.values[2].strip}-#{row.values[3]}-#{row.values[4]}"
            puts "#{count}. #{row.values[0]} / #{row.values[1]} / (#{cert})"
            count +=1
        end
      end
  end
  
  # search for cert no. for names
  def search_cert
      count = 0
      puts "Enter certification #:"
      input = gets.chomp
      
      puts "The following is your result:"
      @rows.each do |row|
        if row.values[3] == input
            puts "#{row.values[0]} (#{row.values[2].strip}-#{row.values[3]}-#{row.values[4]})" 
            count +=1
        end
      end
      puts "Your search yielded #{count} result(s)"
  end
  
  # search for dealers with certain permit types
  def search_type
      count = 1
      puts "Enter certification type (RS, SS, SP, WS, AQ):"
      input = gets.chomp.upcase
      
      puts "The following is your result:"
      @rows.each do |row|
        if row.values[4].include? input
            puts "#{count}. #{row.values[0]} (#{row.values[2].strip}-#{row.values[3]}-#{row.values[4]})"
            count +=1
        end
      end
  end
  
  def main_menu
      puts "Enter your choice (1-8):"
      puts "(1) Full list of Shellfish Shippers"
      puts "(2) List of dealers who can buy from diggers"
      puts "(3) List of dealers with D-Shipper permit"
      puts "(4) Search dealers by name"
      puts "(5) Search dealers by permit #"
      puts "(6) Search dealers by permit type (RS, SS, SP, WS, AQ)"
      case gets().strip()
      when "1"
        get_full_list
      when "2"
        get_rfh
      when "3"
        get_dshipper
      when "4"
        search_name
      when "5"
        search_cert
      when "6"
        search_type
      else
        puts "Invalid input."
      end
  end
  
  
  
  
  # OUTPUT
  main_menu
end
