#! ruby -Ku
# encoding: utf-8
require 'open-uri' #URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' #Nokogiriライブラリを読み込みます。
require 'pp'
require 'date'

url = 'http://www.ytv.co.jp/cematin/calendar/bn/mcms/20130424.html'#切り出すURLを指定します。
#url = 'http://www.ytv.co.jp/cematin/calendar/bn/mcms/20140307.html'

#########
#　大量のアクセスをするので注意！
#　１：sleep(秒) をする
#　２：期間を短めにする
#########

start_date = Date.parse("2015/02/16")
end_date   = Date.parse(Time.now.strftime("%Y/%m/%d"))

(start_date..end_date).each do |ymd|
  sleep(10)
  url = "http://www.ytv.co.jp/cematin/calendar/bn/mcms/#{ymd.strftime("%Y%m%d")}.html"
  puts url

  page = Nokogiri::HTML.parse(open(url).read, url) #htmlを解析し、オブジェクト化

  pan_name = page.search('span[@class="day"]')
  # pp pan_name.text

  pan_name = page.search('span[@class="komidashi"]')

  st_pan_flg = nil
  en_pan_flg = nil

  page.search("h4").each do |value|
    if value.text =~ /パン屋/
      st_pan_flg = value
    elsif st_pan_flg != nil && en_pan_flg.nil?
      en_pan_flg = value
    end
  end

  unless st_pan_flg.nil?
    pos = st_pan_flg
    while true
      pos = pos.next
      break if pos == en_pan_flg
      if pos.name == "span"
        pp "店名：" + pos.text
      end
      if pos.name == "p"
        pp "住所：" + pos.text
      end
      if pos.name == "ul"
        pp pos.children.children[1].attributes["src"].value
        pp pos.children.children[3].attributes["src"].value
      end
    end
  end
end
