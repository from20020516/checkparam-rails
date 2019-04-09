namespace :ffo do
  require 'csv'
  require 'open-uri'
  require 'nokogiri'
  require 'colorize'

  task :import => :environment do
    CSV.foreach("./FFO.csv", headers: true) do |row|
      puts [row["id"], row["ja"]].to_s
      Ffo.find_or_create_by(id: row["id"], ja: row["ja"])
    end
  end

  task :export => :environment do
    csv = CSV.generate do |csv|
      csv << Ffo.column_names
      pos   = 0     # 開始位置
      range = 10000 # 範囲
      loop do
        # ActiveRecordオブジェクトを生成せず、10000件ずつデータをメモリに展開して処理
        results = Ffo.all.limit(range).offset(pos).pluck(*Ffo.column_names)
        break if results.empty?
        pos += range
        results.each do |result|
          csv << result
        end
      end
    end
    File.open("./FFO.csv", 'w') do |file|
      file.write(csv)
    end
  end

  task :init => :environment do
    def parser(page_id)
      url = "http://wiki.ffo.jp/wiki.cgi?Command=ChangeList&pageid=#{page_id}"
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      Nokogiri::HTML.parse(html, nil, charset)
    end

    max = Ffo.all.length > 0 ? 10 : parser(10000).xpath('//*[@id="article"]/div/dl[1]/dd[3]').children.text.delete("^0-9")
    puts [max.present?, max].to_s

    if max.present?
      for page_id in 1..max.to_i do
      doc = parser(page_id)
        for i in 1..50 do
          item = doc.xpath("//*[@id='article']/div/ul/li[#{i}]/a")
          id = item.attribute("href").value.delete("^0-9")
          ja = item.children.text
          Ffo.find_or_create_by(id: id, ja: ja)
          puts [page_id, i, id, ja].to_s
        end
      end

      Item.all.each {|item|
        if item.ffo.blank?
          ffo_exact = Ffo.find_by(ja: item.ja)
          if ffo_exact.present?
            item.update(ffo_id: ffo_exact.id)
            puts [item.id, item.ja].to_s
          else
            ffo_alias = Ffo.find_by(ja: item.ja.gsub(/(\+[1-3]$|改$|^[真極])/, ''))
            item.update(ffo_id: ffo_alias.id)
            puts [item.id, item.ja].to_s.colorize(:red)
          end
        end
      }
    end
  end
end