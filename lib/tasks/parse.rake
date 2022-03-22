# frozen_string_literal: true

namespace :parse do
  desc "parse Item data."
  task items: :environment do
    return puts 'blank wiki data.' if Wiki.all.count.zero?

    require 'benchmark'
    @state = Rufus::Lua::State.new
    res = @state.eval('
      local json = require("lib.assets.json")
      local items = require("Resources.resources_data.items")
      local descriptions = require("Resources.resources_data.item_descriptions")
      local results = {}

      for i,v in pairs(items) do
        if (v.category == "Weapon" or v.category == "Armor")
          -- filter code here
          then
          results[i] = {v, descriptions[i] or ""}
        end
      end
      return json.stringify(results)
    ')

    keep_list = %w[
      クラーケンクラブ 玄武盾 守りの指輪 妖蟲の髪飾り+1 アルコンリング 胡蝶のイヤリング 素破の耳 磁界の耳 幽界の耳 ラジャスリング ブルタルピアス ロケイシャスピアス エボカーリング ラジャスリング 八輪の帯 火輪の帯 土輪の帯 水輪の帯 風輪の帯 氷輪の帯 雷輪の帯 光輪の帯 闇輪の帯 フォシャゴルゲット フォシャベルト ノーヴィオピアス ノーヴィアピアス ニヌルタサッシュ ガネーシャマーラー ウィトフルベルト インカントストーン ジーゲルサッシュ ストロファデピアス プロリクスリング シェルターリング ブラキュラピアス エフェドラリング ハオマリング マリソンメダル デビリスメダル エポナリング ギフトピアス ヘカテーピアス ラベジャーゴルジェ タントラネックレス オリゾンケープ ゴエティアチェーン エストクルカラー レイダーベルト クリードカラー ベイルベルト フェリンマント アエドベルト シルバンスカーフ 雲海喉輪 伊賀襟巻 ランサートルク コーラーサッシュ マーヴィスカーフ ナバーチチョーカー チルコネックレス カリスネックレス サバントテーシス ラベジャーオーブ タントラタスラム オリゾンロケット ゴエティアマント エストクルケープ レイダーブーメラン クリードボードリエ ベイルチョーカー フェリンネックレス アエドマティネ シルバンクラミュス 雲海菅蓑 伊賀道中合羽 ランサーペルリーヌ コーラーペンダント マーヴィタスラム ナバーチマント チルコサッシュ カリスフェザー サバントチェーン ラベジャーピアス タントラピアス オリゾンピアス ゴエティアピアス エストクルピアス レイダーピアス クリードピアス ベイルピアス フェリンピアス アエドピアス シルバンピアス 雲海耳飾 伊賀耳飾 ランサーピアス コーラーピアス マーヴィピアス ナバーチピアス チルコピアス カリスピアス サバントピアス ピュシアサッシュ+1 キャリアーサッシュ ハーティーピアス
    ]

    # Old RMEs and DNC Male.
    ignore_list = [
      20792, 20793, 22117, 21260, 21261, 21267, 20880, 20881, 21264, 21265, 21269, 20653, 20654, 21070, 11927, 20839, 20840, 20486, 20487, 20645,
      20646, 20753, 11926, 20747, 20748, 20561, 20562, 21246, 21247, 21266, 20790, 20791, 21064, 21065, 21212, 21213, 22116, 21135, 21136, 20482,
      20483, 20925, 20926, 20837, 20838, 20480, 20481, 20651, 20652, 20557, 20558, 21262, 21263, 21268, 21137, 21138, 20563, 20564, 21141, 21142,
      21067, 21068, 21069, 20794, 20795, 21485, 21143, 21144, 20835, 20836, 20649, 20650, 20555, 20556, 20647, 20648, 21060, 21061, 21062, 21063,
      20745, 20746, 20884, 20885, 20882, 20883, 20750, 20751, 21139, 21140, 20929, 20930, 20559, 20560, 21210, 21211, 22115, 20484, 20485, 20972,
      20973, 21015, 21016, 21017, 21018, 21019, 21020, 20974, 20975, 20927, 20928, 20970, 20971, 27846, 23125, 23460, 28129, 23259, 23594, 27702,
      23058, 23393, 28262, 23326, 23661, 27982, 23192, 23527, 18571, 18572
    ]

    benchmark_result = Benchmark.realtime do
      JSON.parse(res).each do |data|
        # IL119 gears and slots w/o IL or Instrument, Bell
        next if ignore_list.include?(data[0].to_i)
        next unless data[1][0]['item_level'] == 119 || data[1][0]['level'] == 99 && ([2, 8, 512, 1024, 6144, 24576, 32768].include?(data[1][0]['slots']) || [41, 42, 45].include?(data[1][0]['skill'])) || keep_list.include?(data[1][0]['ja'])

        Item.find_or_create_by(id: data[0].to_i).init(data)
      end
    end
    p "completed parse in #{benchmark_result} seconds."
  end

  desc "show the type of stat."
  task statlist: :environment do
    result = Hash.new(0)
    Item.all.select(:id, :ja).each do |item|
      str = item.description[:raw]
      def status(str)
        str.split(/\s/).flat_map { |stat| stat.sub(/[+-]\d+～/, '').scan(/(\D+?)([+-]?\d+)%?$/) }.to_h
      end
      sep = str.partition(/ペット:|召喚獣:|飛竜:|オートマトン:|羅盤:/)
      res = status(sep[0])&.merge(status(sep[2]).transform_keys { |key| sep[1] + key }).map do |key, value|
        [key.to_sym, value.to_i]
      end .compact.to_h
      res.keys.each { |key| result[key] += 1 }
    rescue StandardError => e
      puts e, item.inspect
    end
    # exclude column if already exists.
    column_names = Stat.column_names
    p result.reject { |key, _value| column_names.member?(key.to_s) || key.to_s.include?('スキル') }.sort_by(&:last).to_h
  end

  # TODO: FIX
  desc "parse wiki data."
  task wiki: :environment do
    require 'csv'
    require 'open-uri'
    require 'nokogiri'

    def parser(page_id)
      url = "http://wiki.ffo.jp/wiki.cgi?Command=ChangeList&pageid=#{page_id}"
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      Nokogiri::HTML.parse(html, nil, charset)
    end

    max = Wiki.all.count.zero? ? parser(10000).xpath('//*[@id="article"]/div/dl[1]/dd[3]').children.text.delete('^0-9') : 10
    puts [max.present?, max].to_s

    if max.present?
      (1..max.to_i).each do |page_id|
        doc = parser(page_id)
        (1..50).each do |i|
          begin
            item = doc.xpath("//*[@id='article']/div/ul/li[#{i}]/a")
            id = item.attribute('href').value.delete('^0-9')
            ja = item.children.text
            Wiki.find_or_create_by(id: id, ja: ja)
          rescue
            break
          end
        end
      end

      Item.all.select(:id, :ja, :wiki_id).each do |item|
        next if item.wiki_id.present?

        wiki_exact = Wiki.find_by(ja: item.ja)
        if wiki_exact.present?
          item.update(wiki_id: wiki_exact.id)
          puts [item.id, item.ja].to_s
        else
          wiki_alias = Wiki.find_by(ja: item.ja.gsub(/(\+[1-3]$|改$|^[真極])/, ''))
          item.update(wiki_id: wiki_alias.id) if wiki_alias&.id
          puts [item.id, item.ja].to_s
        end
      end
    end
  end
end
