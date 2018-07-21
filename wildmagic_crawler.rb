#!/usr/bin/ruby

require 'open-uri'
require 'nokogiri'
require 'line_notify'

class WildBunchCrawler

  def execute
    Parse.new(site_name: 'wildmagic water_area', url: "https://rsv.wildmagic.jp/search/?plan_search=plan_search&search_reservation_type=group&search_date_normal=&search_user_number=&search_date_group=2018%2F08%2F03&search_user_number_group_select=13&search_time_type=night", xpath: '//section[@id="planSection_16109"]/div[@class="area-list"]//tr[7]//div[@class="plan-btn-area-s"]/a/@href').check_stock

    Parse.new(site_name: 'wildmagic seaside_1', url: "https://rsv.wildmagic.jp/search/?plan_search=plan_search&search_reservation_type=group&search_date_normal=&search_user_number=&search_date_group=2018%2F08%2F03&search_user_number_group_select=13&search_time_type=night", xpath: '//section[@id="planSection_16109"]/div[@class="area-list"]//tr[9]//div[@class="plan-btn-area-s"]/a/@href').check_stock

    Parse.new(site_name: 'wildmagic seaside_2', url: "https://rsv.wildmagic.jp/search/?plan_search=plan_search&search_reservation_type=group&search_date_normal=&search_user_number=&search_date_group=2018%2F08%2F03&search_user_number_group_select=13&search_time_type=night", xpath: '//section[@id="planSection_16109"]/div[@class="area-list"]//tr[10]//div[@class="plan-btn-area-s"]/a/@href').check_stock

    Parse.new(site_name: 'wildmagic villadge_1', url: "https://rsv.wildmagic.jp/search/?plan_search=plan_search&search_reservation_type=group&search_date_normal=&search_user_number=&search_date_group=2018%2F08%2F03&search_user_number_group_select=13&search_time_type=night", xpath: '//section[@id="planSection_16109"]/div[@class="area-list"]//tr[12]//div[@class="plan-btn-area-s"]/a/@href').check_stock

    Parse.new(site_name: 'wildmagic villedge_2', url: "https://rsv.wildmagic.jp/search/?plan_search=plan_search&search_reservation_type=group&search_date_normal=&search_user_number=&search_date_group=2018%2F08%2F03&search_user_number_group_select=13&search_time_type=night", xpath: '//section[@id="planSection_16109"]/div[@class="area-list"]//tr[13]//div[@class="plan-btn-area-s"]/a/@href').check_stock

    Parse.new(site_name: 'wildmagic villedge_3', url: "https://rsv.wildmagic.jp/search/?plan_search=plan_search&search_reservation_type=group&search_date_normal=&search_user_number=&search_date_group=2018%2F08%2F03&search_user_number_group_select=13&search_time_type=night", xpath: '//section[@id="planSection_16109"]/div[@class="area-list"]//tr[14]//div[@class="plan-btn-area-s"]/a/@href').check_stock
  end
end

class Crawler
  def initialize()
  end
end

class Parse

  LINE_TOKEN = 'nwyZvycBGboIloWRGTp6H8FYad7p0abpUtM9KjJgegm'

  def initialize(site_name:, url:, xpath:)
    @site_name = site_name
    @url = url
    @xpath = xpath
  end

  def check_stock
    send_line if has_stock?
  end

  def doc
    Nokogiri.HTML(open(@url))
  end

  def stock
    doc.xpath(@xpath)
  end

  def has_stock?
    !(stock.nil? || stock.empty?)
  end

  def send_line
    line_notify = LineNotify.new(LINE_TOKEN)
    options = { message: "#{@site_name}: 空いてる!!!!!" }
    line_notify.send(options)
  end
end

WildBunchCrawler.new.execute
