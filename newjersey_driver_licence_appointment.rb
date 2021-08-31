#!/usr/bin/ruby

require 'open-uri'
require 'nokogiri'
require 'line_notify'

class DriverLicenceCrawler
  def execute
    comfort = Parse.new(url: "https://telegov.njportal.com/njmvc/AppointmentWizard/15", xpath: '//script[contains(text(), "timeData")]')
    comfort.check_stock

  end
end

class Parse

  LINE_TOKEN = 'yjmWD5Gi3JbkmkMLg8GvTqPhWi8zy8OJU45qMxVr7un'

  def initialize( url:, xpath:)
    @url = url
    @xpath = xpath
  end

  def check_stock
    send_line(result)
  end

  def doc
    Nokogiri.HTML(open(@url))
  end

  def stock
    doc.xpath(@xpath)
  end

  def result
    stock.text.scan(/LocationId":(.+?),.*?FirstOpenSlot":"(.+?)"/)
  end

  def send_line(result)
    p "予約状況を確認します"
    p result
    result.each do |location_id, status|
      next if status == "No Appointments Available"
      p "can reserve!"
      line_notify = LineNotify.new(LINE_TOKEN)
      options = { message: "予約が取れます location_id: #{location_id} \n https://telegov.njportal.com/njmvc/AppointmentWizard/15" }
      line_notify.send(options)
    end
  end
end

DriverLicenceCrawler.new.execute
