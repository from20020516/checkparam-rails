# frozen_string_literal: true

namespace :parse do
  task items: :environment do
    return true if Wiki.all.blank?

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
      クラーケンクラブ 玄武盾 守りの指輪 妖蟲の髪飾り+1 アルコンリング 胡蝶のイヤリング 素破の耳 磁界の耳 幽界の耳 ラジャスリング ブルタルピアス ロケイシャスピアス エボカーリング ラジャスリング 八輪の帯 火輪の帯 土輪の帯 水輪の帯 風輪の帯 氷輪の帯 雷輪の帯 光輪の帯 闇輪の帯 フォシャゴルゲット フォシャベルト ノーヴィオピアス ノーヴィアピアス ニヌルタサッシュ ガネーシャマーラー ウィトフルベルト インカントストーン ジーゲルサッシュ ストロファデピアス プロリクスリング シェルターリング ブラキュラピアス エフェドラリング ハオマリング マリソンメダル デビリスメダル エポナリング ギフトピアス ヘカテーピアス ラベジャーゴルジェ タントラネックレス オリゾンケープ ゴエティアチェーン エストクルカラー レイダーベルト クリードカラー ベイルベルト フェリンマント アエドベルト シルバンスカーフ 雲海喉輪 伊賀襟巻 ランサートルク コーラーサッシュ マーヴィスカーフ ナバーチチョーカー チルコネックレス カリスネックレス サバントテーシス ラベジャーオーブ タントラタスラム オリゾンロケット ゴエティアマント エストクルケープ レイダーブーメラン クリードボードリエ ベイルチョーカー フェリンネックレス アエドマティネ シルバンクラミュス 雲海菅蓑 伊賀道中合羽 ランサーペルリーヌ コーラーペンダント マーヴィタスラム ナバーチマント チルコサッシュ カリスフェザー サバントチェーン ラベジャーピアス タントラピアス オリゾンピアス ゴエティアピアス エストクルピアス レイダーピアス クリードピアス ベイルピアス フェリンピアス アエドピアス シルバンピアス 雲海耳飾 伊賀耳飾 ランサーピアス コーラーピアス マーヴィピアス ナバーチピアス チルコピアス カリスピアス サバントピアス ピュシアサッシュ+1 キャリアーサッシュ
    ]

    # Old RMEs and DNC Male.
    ignore_list = [
      20792, 20793, 22117, 21260, 21261, 21267, 20880, 20881, 21264, 21265, 21269, 20653, 20654, 21070, 11927, 20839, 20840, 20486, 20487, 20645,
      20646, 20753, 11926, 20747, 20748, 20561, 20562, 21246, 21247, 21266, 20790, 20791, 21064, 21065, 21212, 21213, 22116, 21135, 21136, 20482,
      20483, 20925, 20926, 20837, 20838, 20480, 20481, 20651, 20652, 20557, 20558, 21262, 21263, 21268, 21137, 21138, 20563, 20564, 21141, 21142,
      21067, 21068, 21069, 20794, 20795, 21485, 21143, 21144, 20835, 20836, 20649, 20650, 20555, 20556, 20647, 20648, 21060, 21061, 21062, 21063,
      20745, 20746, 20884, 20885, 20882, 20883, 20750, 20751, 21139, 21140, 20929, 20930, 20559, 20560, 21210, 21211, 22115, 20484, 20485, 20972,
      20973, 21015, 21016, 21017, 21018, 21019, 21020, 20974, 20975, 20927, 20928, 20970, 20971, 27846, 23125, 23460, 28129, 23259, 23594, 27702,
      23058, 23393, 28262, 23326, 23661, 27982, 23192, 23527, 18571, 18572]

    def convert_job(jobs)
      if jobs == 8388606
        { ja: 'All Jobs',
          en: 'All Jobs' }
      else
        job2bin = format('%#024b', jobs).split('').map(&:to_i).reverse
        { ja: Job.pluck(:jas).zip(job2bin).to_h.select { |_k, v| v == 1 }.keys.join,
          en: Job.pluck(:ens).zip(job2bin).to_h.select { |_k, v| v == 1 }.keys.join('/') }
      end
    end

    benchmark_result = Benchmark.realtime do
      JSON.parse(res).each do |data|
        # IL119 gears and slots w/o IL or Instrument, Bell
        item = data[1][0] # items.lua
        item[:description] = data[1][1] # item_descriptions.lua
        item = item.with_indifferent_access

        next if ignore_list.include?(item[:id])
        next unless item[:item_level] == 119 || item[:level] == 99 && ([2, 8, 512, 1024, 6144, 24576, 32768].include?(item[:slots]) || [41, 42, 45].include?(item[:skill])) || keep_list.include?(item[:ja])

        begin
          jobs = convert_job(item[:jobs])
          @item = Item.find_or_create_by(id: item[:id])
          @item.stat = Stat.find_or_create_by(item_id: @item.id)
          @item.update(
            slot: item[:slots],
            job: item[:jobs],
            ja: item[:ja],
            en: item[:en],
            wiki_id: @item[:wiki_id] || Wiki.find_by(ja: item[:ja])&.id || Wiki.find_by(ja: item[:ja].gsub(/(\+[1-3]$|改$|^[真極])/, ''))&.id
          )

          next if item[:description].blank?

          text = item[:description][:ja]&.gsub(/\n/, ' ')
          @item.update(
            description: {
              ja: "<a href='http://wiki.ffo.jp/html/#{@item[:wiki_id]}.html' target='_blank'>#{item[:ja]}</a><br>#{item[:description][:ja]&.gsub(/\n/, '<br>')}<br>#{jobs[:ja]}",
              en: "<a href='http://wiki.ffo.jp/html/#{@item[:wiki_id]}.html' target='_blank'>#{item[:en]}</a><br>#{item[:description][:en]&.gsub(/\n/, '<br>')}<br>#{jobs[:en]}",
              # raw: item[:description][:ja]&.gsub(/\n/, ' ')
            })

          # get keys && values from text.
          hash = text.split(/ペット:|召喚獣:|飛竜:|オートマトン:|羅盤:/).map do |arg|
            arg.split(/\s/).flat_map do |stat|
              stat.sub(/[+-]\d+～/, '').scan(/(\D+?)([+-]?\d+)%?$/)
            end.to_h
          end
          # .to_i values && 'pet_' prefix to some keys.
          hash = hash[0].merge(hash[1]&.map { |k, v| ["ペット_#{k}", v] }.to_h).transform_values(&:to_i)
          # get key that exists in stat model.
          hash = hash.select { |k, _v| @item.stat.attributes.keys.member?(k) }
          @item.stat.update(hash)

        rescue StandardError => e
          puts e, item.inspect
        end
      end
    end
    p benchmark_result
  end

  task statlist: :environment do
    result = {}
    result.default = 0
    Item.all.each do |item|
      description = item.description.raw

      next if description.blank?
      hash = description.split(/ペット:|召喚獣:|飛竜:|オートマトン:|羅盤:/).map { |arg|
        arg.split(/\s/).flat_map { |stat|
          stat.sub(/[+-]\d+～/, '').scan(/(\D+?)([+-]?\d+)%?/)
        }.to_h
      }
      hash = hash[0].merge(hash[1]&.map { |k, v| ["ペット_#{k}", v] }.to_h).transform_values(&:to_i)
      hash.keys.each { |key| result[key] += 1 }
    end

    result = result.reject{ |k, _v| Stat.column_names.member?(k) || k.include?("スキル") }
    pp result.sort_by(&:last).to_h
  end

  task sample: :environment do
    Slot.delete_all
    Slot.create([
                  { id: 1, pos: 0, en: 'main', img: 16622 },
                  { id: 2, pos: 1, en: 'sub', img: 12332 },
                  { id: 3, pos: 2, en: 'range', img: 17174 },
                  { id: 4, pos: 3, en: 'ammo', img: 17326 },
                  { id: 5, pos: 4, en: 'head', img: 12523 },
                  { id: 6, pos: 9, en: 'neck', img: 13074 },
                  { id: 7, pos: 11, en: 'ear1', img: 13358 },
                  { id: 8, pos: 12, en: 'ear2', img: 13358 },
                  { id: 9, pos: 5, en: 'body', img: 12551 },
                  { id: 10, pos: 6, en: 'hands', img: 12679 },
                  { id: 11, pos: 13, en: 'ring1', img: 13505 },
                  { id: 12, pos: 14, en: 'ring2', img: 13505 },
                  { id: 13, pos: 15, en: 'back', img: 13606 },
                  { id: 14, pos: 10, en: 'waist', img: 13215 },
                  { id: 15, pos: 7, en: 'legs', img: 12807 },
                  { id: 16, pos: 8, en: 'feet', img: 12935 }
                ])
    Job.delete_all
    Job.create([
                 { id: 0 },
                 { id: 1, ja: '戦士', en: 'Warrior', ens: 'WAR', jas: '戦' },
                 { id: 2, ja: 'モンク', en: 'Monk', ens: 'MNK', jas: 'モ' },
                 { id: 3, ja: '白魔道士', en: 'WhiteMage', ens: 'WHM', jas: '白' },
                 { id: 4, ja: '黒魔道士', en: 'BlackMage', ens: 'BLM', jas: '黒' },
                 { id: 5, ja: '赤魔道士', en: 'RedMage', ens: 'RDM', jas: '赤' },
                 { id: 6, ja: 'シーフ', en: 'Thief', ens: 'THF', jas: 'シ' },
                 { id: 7, ja: 'ナイト', en: 'Paladin', ens: 'PLD', jas: 'ナ' },
                 { id: 8, ja: '暗黒騎士', en: 'DarkKnight', ens: 'DRK', jas: '暗' },
                 { id: 9, ja: '獣使い', en: 'Beastmaster', ens: 'BST', jas: '獣' },
                 { id: 10, ja: '吟遊詩人', en: 'Bard', ens: 'BRD', jas: '詩' },
                 { id: 11, ja: '狩人', en: 'Ranger', ens: 'RNG', jas: '狩' },
                 { id: 12, ja: '侍', en: 'Samurai', ens: 'SAM', jas: '侍' },
                 { id: 13, ja: '忍者', en: 'Ninja', ens: 'NIN', jas: '忍' },
                 { id: 14, ja: '竜騎士', en: 'Dragoon', ens: 'DRG', jas: '竜' },
                 { id: 15, ja: '召喚士', en: 'Summoner', ens: 'SMN', jas: '召' },
                 { id: 16, ja: '青魔道士', en: 'BlueMage', ens: 'BLU', jas: '青' },
                 { id: 17, ja: 'コルセア', en: 'Corsair', ens: 'COR', jas: 'コ' },
                 { id: 18, ja: 'からくり士', en: 'Puppetmaster', ens: 'PUP', jas: 'か' },
                 { id: 19, ja: '踊り子', en: 'Dancer', ens: 'DNC', jas: '踊' },
                 { id: 20, ja: '学者', en: 'Scholar', ens: 'SCH', jas: '学' },
                 { id: 21, ja: '風水士', en: 'Geomancer', ens: 'GEO', jas: '風' },
                 { id: 22, ja: '魔導剣士', en: 'RuneFencer', ens: 'RUN', jas: '剣' },
                 { id: 23 }
               ])
    User.where(id: 1).first&.delete
    User.create(id: 1).update(
      email: 'user@checkparam.com',
      password: 'password',
      # uid: 1042812468748156928,
      # provider: "twitter",
      auth: { "info": { "nickname": 'from20020516' }, "extra": { "raw_info": { "profile_image_url_https": '/icons/default_profile.png' } } }
    )
    Gearset.where(id: [1..5]).delete_all
    Gearset.create([
                     { id: 1, user_id: 1, job_id: 1, set_id: 1, main: 21758, sub: 22212, range: nil, ammo: 22281, head: 23375, neck: 25419, ear1: 14813, ear2: 27545, body: 23442, hands: 23509, ring1: 13566, ring2: 15543, back: 26246, waist: 26334, legs: 23576, feet: 23643 },
                     { id: 2, user_id: 1, job_id: 16, set_id: 1, main: 20695, sub: 20689, range: nil, ammo: 21371, head: 25614, neck: 26015, ear1: 14739, ear2: 27545, body: 25687, hands: 27118, ring1: 11651, ring2: 26186, back: 26261, waist: 28440, legs: 27295, feet: 27496 },
                     { id: 3, user_id: 1, job_id: 13, set_id: 1, main: 21907, sub: 21906, range: nil, ammo: 21391, head: 23387, neck: 25491, ear1: 14739, ear2: 14813, body: 23454, hands: 23521, ring1: 13566, ring2: 15543, back: 16207, waist: 28440, legs: 27318, feet: 23655 },
                     { id: 4, user_id: 1, job_id: 3, set_id: 1, main: 21078, sub: 27645, range: nil, ammo: 22268, head: 26745, neck: 28357, ear1: 28480, ear2: 28474, body: 26903, hands: 27057, ring1: 13566, ring2: 26200, back: 28619, waist: 28419, legs: 27242, feet: 27416 },
                     { id: 5, user_id: 1, job_id: 7, set_id: 1, main: 20687, sub: 16200, range: nil, ammo: 22279, head: 26671, neck: 26002, ear1: 28483, ear2: 27549, body: 26847, hands: 27023, ring1: 13566, ring2: 26200, back: 26252, waist: 28437, legs: 27199, feet: 27375 }
                   ])
  end

  task wiki: :environment do
    require 'csv'
    require 'open-uri'
    require 'nokogiri'
    require 'colorize'
    def parser(page_id)
      url = "http://wiki.ffo.jp/wiki.cgi?Command=ChangeList&pageid=#{page_id}"
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      Nokogiri::HTML.parse(html, nil, charset)
    end

    max = !Wiki.all.empty? ? 10 : parser(10000).xpath('//*[@id="article"]/div/dl[1]/dd[3]').children.text.delete('^0-9')
    puts [max.present?, max].to_s

    if max.present?
      (1..max.to_i).each do |page_id|
        doc = parser(page_id)
        (1..50).each do |i|
          item = doc.xpath("//*[@id='article']/div/ul/li[#{i}]/a")
          id = item.attribute('href').value.delete('^0-9')
          ja = item.children.text
          Wiki.find_or_create_by(id: id, ja: ja)
        end
      end

      Item.all.each do |item|
        next if item.wiki.present?

        wiki_exact = Wiki.find_by(ja: item.ja)
        if wiki_exact.present?
          item.update(wiki_id: wiki_exact.id)
          # puts [item.id, item.ja].to_s
        else
          wiki_alias = Wiki.find_by(ja: item.ja.gsub(/(\+[1-3]$|改$|^[真極])/, ''))
          item.update(wiki_id: wiki_alias.id)
          # puts [item.id, item.ja].to_s.colorize(:red)
        end
      end
    end
  end
end
