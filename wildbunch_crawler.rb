#!/usr/bin/ruby

require 'open-uri'
require 'nokogiri'
require 'line_notify'

class WildBunchCrawler
  def execute
    comfort = Parse.new(site_name: 'コンフォートホテル', url: "https://asp.hotel-story.ne.jp/ver3d/planlist.asp?hcod1=CH410&hcod2=001&LB01=server4&mode=seek&hidSELECTARRYMD=2018/7/29&hidSELECTHAKSU=1&sortmethod=priceup&clrmode=seek", xpath: '//div[@class="plan-list"]')
    comfort.check_stock

    toyoko_in = Parse.new(site_name: '東横イン', url: 'https://www.toyoko-inn.com/search/result?chck_in=2018/07/29&inn_date=1&rsrv_num=1&sel_ldgngPpl=2&sel_area=42&sel_area_txt=%E5%B1%B1%E5%8F%A3&sel_htl=&rd_smk=&sel_room_clss_Id=&sel_prkng=1&sel_prkng=1&pln_only=&rsrv_only=&sel_cnfrnc=1&sel_hrtfll_room=1&sel_whlchr=&sel_bath=&sel_rstrnt=&srch_key_word=&lttd=&lngtd=&pgn=1&sel_dtl_cndtn=on&prcssng_dvsn=dtl&', xpath: '//div[@class="listHead mt20"]/p[@class="txtMessage"]')
    toyoko_in.check_stock

    active = Parse.new(site_name: 'アクティブ', url: 'https://ishidaya.rwiths.net/r-withs/tfs0020a.do?hotelNo=15761&GCode=ishidaya&vipCode=&sort=1&curPage=1&f_lang=ja&ciDateY=2018&ciDateM=07&ciDateD=29&lowerCharge=0&upperCharge=999999&coDateY=2018&coDateM=07&coDateD=30&otona=2&s1=0&s2=0&y1=0&y2=0&y3=0&y4=0&room=1', xpath: '//div[@class="planList"]')
    active.check_stock
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
    p @site_name
    p stock
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
    options = { message: "#{@site_name}: 空室があります!!!!!!" }
    line_notify.send(options)
  end
end

WildBunchCrawler.new.execute
