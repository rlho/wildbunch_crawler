#!/usr/bin/ruby

require 'open-uri'
require 'nokogiri'
require 'line_notify'

class WildBunchCrawler
  def execute
    comfort = Parse.new(site_name: 'コンフォートホテル', url: "https://www.amazon.co.jp/gp/offer-listing/B07XV7PXBM/ref=dp_olp_all_mbc?ie=UTF8&condition=all", xpath: '//span[@class="a-size-large a-color-price olpOfferPrice a-text-bold"]')
    comfort.check_stock

  end
end

class Parse

  LINE_TOKEN = 'lMTLtbK88EP88ZILNx6PWyNbauyakYWJwJ8rZWxURsk'

  def initialize(site_name:, url:, xpath:)
    @site_name = site_name
    @url = url
    @xpath = xpath
  end

  def check_stock
    prices.each do |price|
      send_line(price) if price < 10000
    end
  end

  def doc
    Nokogiri.HTML(open(@url))
  end

  def stock
    doc.xpath(@xpath)
  end

  def prices
    stock.map do |stock|
      stock.text.strip.scan(/[\d,]*/).reject { |a| a == '' }.map { |a| a.gsub(',', '') }.map(&:to_i)
    end.flatten
  end

  def send_line(price)
    line_notify = LineNotify.new(LINE_TOKEN)
    options = { message: "リングフィットアドベンチャー価格: #{price}" }
    p options
    line_notify.send(options)
  end
end

WildBunchCrawler.new.execute
