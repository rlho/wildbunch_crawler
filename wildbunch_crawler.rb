#!/usr/bin/ruby

# About nokogiri

require 'open-uri'
require 'nokogiri'
require 'line_notify'

class WildBunchCrawler
  LINE_TOKEN = 'nwyZvycBGboIloWRGTp6H8FYad7p0abpUtM9KjJgegm'
  def execute
    line_notify = LineNotify.new(LINE_TOKEN)

    comfort_doc = Nokogiri.HTML(open("https://asp.hotel-story.ne.jp/ver3d/planlist.asp?hcod1=CH410&hcod2=001&LB01=server4&mode=seek&hidSELECTARRYMD=2018/7/28&hidSELECTHAKSU=1&sortmethod=priceup&clrmode=seek"))
    comport_text = comfort_doc.xpath('//div[@class="plan-list"]').text

    options = { message: "コンフォートホテル: #{stock_text(comport_text)}" }
    line_notify.send(options)

    toyoko_doc = Nokogiri.HTML(open("https://www.toyoko-inn.com/search/result?chck_in=2018/07/28&inn_date=1&rsrv_num=1&sel_ldgngPpl=2&sel_area=42&sel_area_txt=%E5%B1%B1%E5%8F%A3&sel_htl=&rd_smk=&sel_room_clss_Id=&sel_prkng=&sel_cnfrnc=&sel_hrtfll_room=&sel_whlchr=&sel_bath=&sel_rstrnt=&srch_key_word=&lttd=&lngtd=&pgn=1&sel_dtl_cndtn=on&prcssng_dvsn=dtl&"))
    toyoko_text = toyoko_doc.xpath('//div[@class="listHead mt20"]/p[@class="txtMessage"]').text

    options = { message: "東横イン: #{stock_text(toyoko_text)}" }
    line_notify.send(options)

    active_doc = Nokogiri.HTML(open("https://ishidaya.rwiths.net/r-withs/tfs0020a.do?hotelNo=15761&vipCode=&sort=1&curPage=1&f_lang=ja&ciDateY=2018&ciDateM=07&ciDateD=28&coDateY=2018&coDateM=07&coDateD=29&otona=2&s1=0&s2=0&y1=0&y2=0&y3=0&y4=0&room=1"))
    active_text = active_doc.xpath('//div[@class="planList"]').text

    options = { message: "アクティブ: #{stock_text(active_text)}" }
    line_notify.send(options)
  end

  def stock_text(text)
    text.nil? || text.empty? ? 'なし' : 'あり'
  end
end
WildBunchCrawler.new.execute
