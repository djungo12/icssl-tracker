class WebScraperController < ApplicationController
  
  def scrape_ny
    require 'open-uri'
    require 'nokogiri'
    
    doc = Nokogiri::HTML(open("https://www.accessdata.fda.gov/scripts/shellfish/sh/shippers.cfm?country=US&state=NY"))
    
    @headers = []
    doc.xpath('//*/table/thead/tr/th').each do |th|
        @headers << th.text
    end
  
    @rows = []
    doc.xpath('//*/table/tbody/tr').each_with_index do |row, i|
      @rows[i] = {}
      row.xpath('td').each_with_index do |td, j|
          @rows[i][@headers[j]] = td.text
      end
    end
    
    render template: 'web_scraper/result'
  end
  
  # get dealers with aquaculture permits
  def get_aqua
    count = 1
    @rows.each do |row|
      if row.values[4].include? "AQ"
          count +=1
      end
    end
  end
  helper_method :get_aqua
  
  
end