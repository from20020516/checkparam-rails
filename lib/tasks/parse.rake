namespace :parse do
  task :init => :environment do
    sh 'rails db:migrate:reset && rails db:seed && rails parse:items && rails parse:sample && rails parse:stats'
  end

  task :items => :environment do
    @state = Rufus::Lua::State.new
    res = @state.eval('
      local json = require("lib.assets.json")
      local item = require("Resources.resources_data.items")
      local desc = require("Resources.resources_data.item_descriptions")
      local ary = {}

      for i,v in pairs(item) do -- FILTER
        if (v.category == "Weapon" or v.category == "Armor") then
          ary[i] = {v, desc[i] or ""}
        end
      end
      return json.stringify(ary)
    ')

    keep_list = [
      'クラーケンクラブ','玄武盾',
      '守りの指輪',
      '妖蟲の髪飾り+1', 'アルコンリング',
      '胡蝶のイヤリング', '素破の耳', '磁界の耳', '幽界の耳', 'ラジャスリング', 'ブルタルピアス', 'ロケイシャスピアス', 'エボカーリング', 'ラジャスリング',
      '八輪の帯', '火輪の帯', '土輪の帯', '水輪の帯', '風輪の帯', '氷輪の帯', '雷輪の帯', '光輪の帯', '闇輪の帯',
      'フォシャゴルゲット', 'フォシャベルト', 'ノーヴィオピアス', 'ノーヴィアピアス', 'ニヌルタサッシュ',
      'ガネーシャマーラー', 'ウィトフルベルト', 'インカントストーン', 'ジーゲルサッシュ', 'ストロファデピアス', 'プロリクスリング',
      'シェルターリング', 'ブラキュラピアス',
      'エフェドラリング', 'ハオマリング', 'マリソンメダル', 'デビリスメダル',
      'エポナリング', 'ギフトピアス', 'ヘカテーピアス',
      'ラベジャーゴルジェ', 'タントラネックレス', 'オリゾンケープ', 'ゴエティアチェーン', 'エストクルカラー', 'レイダーベルト', 'クリードカラー', 'ベイルベルト', 'フェリンマント', 'アエドベルト', 'シルバンスカーフ', '雲海喉輪', '伊賀襟巻', 'ランサートルク', 'コーラーサッシュ', 'マーヴィスカーフ', 'ナバーチチョーカー', 'チルコネックレス', 'カリスネックレス', 'サバントテーシス', 'ラベジャーオーブ', 'タントラタスラム', 'オリゾンロケット', 'ゴエティアマント', 'エストクルケープ', 'レイダーブーメラン', 'クリードボードリエ', 'ベイルチョーカー', 'フェリンネックレス', 'アエドマティネ', 'シルバンクラミュス', '雲海菅蓑', '伊賀道中合羽', 'ランサーペルリーヌ', 'コーラーペンダント', 'マーヴィタスラム', 'ナバーチマント', 'チルコサッシュ', 'カリスフェザー', 'サバントチェーン', 'ラベジャーピアス', 'タントラピアス', 'オリゾンピアス', 'ゴエティアピアス', 'エストクルピアス', 'レイダーピアス', 'クリードピアス', 'ベイルピアス', 'フェリンピアス', 'アエドピアス', 'シルバンピアス', '雲海耳飾', '伊賀耳飾', 'ランサーピアス', 'コーラーピアス', 'マーヴィピアス', 'ナバーチピアス', 'チルコピアス', 'カリスピアス', 'サバントピアス',
    ]

    ignore_list = %w[
      20792 20793 22117 21260 21261 21267 20880 20881 21264 21265 21269 20653 20654 21070 11927 20839 20840 20486 20487 20645
      20646 20753 11926 20747 20748 20561 20562 21246 21247 21266 20790 20791 21064 21065 21212 21213 22116 21135 21136 20482
      20483 20925 20926 20837 20838 20480 20481 20651 20652 20557 20558 21262 21263 21268 21137 21138 20563 20564 21141 21142
      21067 21068 21069 20794 20795 21485 21143 21144 20835 20836 20649 20650 20555 20556 20647 20648 21060 21061 21062 21063
      20745 20746 20884 20885 20882 20883 20750 20751 21139 21140 20929 20930 20559 20560 21210 21211 22115 20484 20485 20972
      20973 21015 21016 21017 21018 21019 21020 20974 20975 20927 20928 20970 20971 27846 23125 23460 28129 23259 23594 27702
      23058 23393 28262 23326 23661 27982 23192 23527 18571 18572
    ] # Old RMEs and Male DNC. Class "String".

    def convert_job(jobs)
      if jobs == 8388606
        ['All Jobs', 'All Jobs']
      else
        bin = ('%#024b' % jobs).split('').map(&:to_i).reverse
        [Job.pluck("jas").zip(bin).to_h.select { |_k, v| v == 1 }.keys.join, Job.pluck("ens").zip(bin).to_h.select { |_k, v| v == 1 }.keys.join('/')]
      end
    end

    JSON.parse(res).each do |data|
      # IL119 gears and slots w/o IL or Instrument, Bell
      if (data[1][0]['item_level'] == 119 || data[1][0]['level'] == 99 && ([2, 8, 512, 1024, 6144, 24576, 32768].include?(data[1][0]['slots']) || [41, 42, 45].include?(data[1][0]['skill'])) || keep_list.include?(data[1][0]['ja'])) && !ignore_list.include?(data[0])

        jobs = convert_job(data[1][0]['jobs'])
        Item.find_or_initialize_by(id: data[0]).update(
          slot: data[1][0]['slots'],
          job: data[1][0]['jobs'],
          ja: data[1][0]['ja'],
          en: data[1][0]['en'],
          description: {
            ja: "<b>#{data[1][0]['ja']}</b><br>#{data[1][1]['ja']&.gsub(/\n/, '<br>')}<br>#{jobs[0]}",
            en: "<b>#{data[1][0]['en']}</b><br>#{data[1][1]['en']&.gsub(/\n/, '<br>')}<br>#{jobs[1]}",
            data: data[1][1]['ja']&.gsub(/\n/, ' ')
          },
        )
      end
    end
  end

  task :stats => :environment do
    allow_stat = Stat.attribute_names
    Item.all.each do |item|
      Stat.find_or_create_by(id: item.id)
      .update(item.description["data"]
        .split(/ペット:|召喚獣:|飛竜:|オートマトン:|羅盤:/)[0] #TO-DO: ペット対応 >> split with "pet:" and adds prefix to each.
        .split(/\s/)
        .select{|str| value = str.split(/([+-]?[0-9]+)%?$/)
            value if value.length == 2}
        .map{|str|str.scan(/(.+?)([+-]?[0-9]+)%?$/)[0]}
        .select{|i| allow_stat.include?(i[0])}
        .to_h) if item.description["data"].present?
    end
  end

  task :statlist => :environment do
    h = Hash.new
    h.default = 0
    allow_stats = Stat.column_names
    Item.all.each do |item|
      item.description["ja"] = item.description["ja"].split(/ペット:|召喚獣:|飛竜:|オートマトン:|羅盤:/)[0]
      item.description["ja"].split(/<br>|\s/).each {|str|
        stats = str.split(/([+-]?[0-9]+)%?$/)
        h[stats[0]] += 1 if stats.length == 2
      }
    end
    h.sort {|(_k1, v1),(_k2, v2)|v2 <=> v1}.reverse.each {|stat|
      p stat unless allow_stats.include?(stat[0]) || stat[0].match(/スキル/)
    }
  end

  task :sample => :environment do
    User.find_or_initialize_by(id: 1).update(email: 'user@checkparam.com', password: 'password') #, uid: 1042812468748156928, provider: "twitter")
    Gearset.find_or_initialize_by(id: 1).update(id: 1, user_id: 1, job_id: 1, set_id: 1, main: 21758, sub: 22212, range: nil, ammo: 22281, head: 23375, neck: 25419, ear1: 14813, ear2:
      27545, body: 23442, hands: 23509, ring1: 13566, ring2: 15543, back: 26246, waist: 26334, legs: 23576, feet: 23643)
    Gearset.find_or_initialize_by(id: 2).update(id: 2, user_id: 1, job_id: 16, set_id: 1, main: 20695, sub: 20689, range: nil, ammo: 21371, head: 25614, neck: 26015, ear1: 14739, ear2: 27545, body: 25687, hands: 27118, ring1: 11651, ring2: 26186, back: 26261, waist: 28440, legs: 27295, feet: 27496)
    Gearset.find_or_initialize_by(id: 3).update(id: 3, user_id: 1, job_id: 13, set_id: 1, main: 21907, sub: 21906, range: nil, ammo: 21391, head: 23387, neck: 25491, ear1: 14739, ear2: 14813, body: 23454, hands: 23521, ring1: 13566, ring2: 15543, back: 16207, waist: 28440, legs: 27318, feet: 23655)
    Gearset.find_or_initialize_by(id: 4).update(id: 4, user_id: 1, job_id: 3, set_id: 1, main: 21078, sub: 27645, range: nil, ammo: 22268, head: 26745, neck: 28357, ear1: 28480, ear2: 28474, body: 26903, hands: 27057, ring1: 13566, ring2: 26200, back: 28619, waist: 28419, legs: 27242, feet: 27416)
  end
end
