class ShippersController < ApplicationController
  
  def main
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
    
    render template: 'shippers/main'
  end
  
  # get total number of dealers
  def get_total
    count = 1
    @rows.each do |row|
      count +=1
    end
    return count
  end
  helper_method :get_total
  
  
  # get dealers with aquaculture permits
  def get_aqua
    count = 1
    @rows.each do |row|
      if row.values[4].include? "AQ"
          count +=1
      end
    end
    return count
  end
  helper_method :get_aqua
  
  # get dealers with d-shipper permits
  def get_dshipper
    count = 1
    @rows.each do |row|
      if row.values[3].to_s.length > 3
        count +=1
      end
    end
    return count
  end
  helper_method :get_dshipper
  
  def get_rfh
      count = 1
      @rows.each do |row|
        name = row.values[0]
        if name.include? "*"
            count +=1
        end
      end
      return count
  end
  helper_method :get_rfh
  
  def get_ws
      count = 1
      @rows.each do |row|
        symbol = row.values[4]
        if symbol.include? "WS"
            count +=1
        end
      end
      return count
  end
  helper_method :get_ws
  
end