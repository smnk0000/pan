#! ruby -Ku
# encoding: utf-8
require 'open-uri' #URLにアクセスする為のライブラリを読み込みます。
require 'nokogiri' #Nokogiriライブラリを読み込みます。
require 'pp'
url = 'http://www.ytv.co.jp/cematin/calendar/bn/mcms/20130424.html'#切り出すURLを指定します。

#url = 'http://www.ytv.co.jp/cematin/calendar/bn/mcms/20140307.html'
page = Nokogiri::HTML.parse(open(url).read, url) #htmlを解析し、オブジェクト化

pan_name = page.search('span[@class="day"]')
# pp pan_name.text

pan_name = page.search('span[@class="komidashi"]')
pan_name.each do |value|
  # pp value.text
end


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
