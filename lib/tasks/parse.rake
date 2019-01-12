namespace :parse do
  require 'colorize'
  require 'colorized_string'
  require 'rufus-lua'

  desc "get Items from lua."
  task :items => :environment do
    @state = Rufus::Lua::State.new
    res = @state.eval('
      local json = require("lib.assets.json")
      local item = require("lib.assets.Resources.resources_data.items")
      local desc = require("lib.assets.Resources.resources_data.item_descriptions")
      local ary = {}

      for i,v in pairs(item) do -- FILTER
        if (v.category == "Weapon" or v.category == "Armor") then
          ary[i] = {v, desc[i] or ""}
        end
      end
      return json.stringify(ary)
    ')

    keep_list = [
      "守りの指輪",
      "妖蟲の髪飾り+1","アルコンリング",
      "胡蝶のイヤリング","素破の耳","磁界の耳","幽界の耳","ラジャスリング","ブルタルピアス","ロケイシャスピアス","エボカーリング",
      "八輪の帯","火輪の帯","土輪の帯","水輪の帯","風輪の帯","氷輪の帯","雷輪の帯","光輪の帯","闇輪の帯",
      "フォシャゴルゲット","フォシャベルト","ノーヴィオピアス","ノーヴィアピアス","ニヌルタサッシュ",
      "ガネーシャマーラー","ウィトフルベルト","インカントストーン","ジーゲルサッシュ","ストロファデピアス","プロリクスリング",
      "シェルターリング","ブラキュラピアス",
      "エフェドラリング","ハオマリング","マリソンメダル","デビリスメダル",
      "エポナリング","ギフトピアス","ヘカテーピアス",
      "ラベジャーゴルジェ","タントラネックレス","オリゾンケープ","ゴエティアチェーン","エストクルカラー","レイダーベルト","クリードカラー","ベイルベルト","フェリンマント","アエドベルト","シルバンスカーフ","雲海喉輪","伊賀襟巻","ランサートルク","コーラーサッシュ","マーヴィスカーフ","ナバーチチョーカー","チルコネックレス","カリスネックレス","サバントテーシス","ラベジャーオーブ","タントラタスラム","オリゾンロケット","ゴエティアマント","エストクルケープ","レイダーブーメラン","クリードボードリエ","ベイルチョーカー","フェリンネックレス","アエドマティネ","シルバンクラミュス","雲海菅蓑","伊賀道中合羽","ランサーペルリーヌ","コーラーペンダント","マーヴィタスラム","ナバーチマント","チルコサッシュ","カリスフェザー","サバントチェーン","ラベジャーピアス","タントラピアス","オリゾンピアス","ゴエティアピアス","エストクルピアス","レイダーピアス","クリードピアス","ベイルピアス","フェリンピアス","アエドピアス","シルバンピアス","雲海耳飾","伊賀耳飾","ランサーピアス","コーラーピアス","マーヴィピアス","ナバーチピアス","チルコピアス","カリスピアス","サバントピアス"
    ]

    ignore_list = [
      20792,20793,22117,21260,21261,21267,20880,20881,21264,21265,21269,20653,20654,21070,11927,20839,20840,20486,20487,20645,
      20646,20753,11926,20747,20748,20561,20562,21246,21247,21266,20790,20791,21064,21065,21212,21213,22116,21135,21136,20482,
      20483,20925,20926,20837,20838,20480,20481,20651,20652,20557,20558,21262,21263,21268,21137,21138,20563,20564,21141,21142,
      21067,21068,21069,20794,20795,21485,21143,21144,20835,20836,20649,20650,20555,20556,20647,20648,21060,21061,21062,21063,
      20745,20746,20884,20885,20882,20883,20750,20751,21139,21140,20929,20930,20559,20560,21210,21211,22115,20484,20485,20972,
      20973,21015,21016,21017,21018,21019,21020,20974,20975,20927,20928,20970,20971,27846,23125,23460,28129,23259,23594,27702,
      23058,23393,28262,23326,23661,27982,23192,23527,18571,18572] # Old RMEs and Male DNC.

    JSON.parse(res).each do |data|
      if (data[1][0]["item_level"] == 119 ||
          # NON-IL slots and Instrument, Bell.
          data[1][0]["level"] == 99 && ([2,8,512,1024,6144,24576,32768].include?(data[1][0]["slots"]) || [41,42,45].include?(data[1][0]["skill"])) ||
          keep_list.include?(data[1][0]["ja"])) &&
        !ignore_list.include?(data[0].to_i)

        @item = Item.find_or_initialize_by(id: data[0])
        @item.update(
          ja:     data[1][0]["ja"],
          en:     data[1][0]["en"],
          group:  data[1][0]["type"],
          slot:   data[1][0]["slots"],
          skill:  data[1][0]["skill"],
          job:    data[1][0]["jobs"],
          lv:     data[1][0]["level"],
          itemlv: data[1][0]["item_level"],
        )
  
        @description = Description.find_or_initialize_by(id: data[0])
        @description.update(
          ja:  data[1][1]["ja"] || "",
          en:  data[1][1]["en"] || "",
        )
      end
    end
  end

  # TO-DO: ペット対応
  desc "restructure equipment descriptions."
  task :rest => :environment do
    Description.all.each do |data|
      puts data.id.to_s.light_black, data.ja.yellow
      nya = data.ja.gsub(/\n/," ").split(/\s/)
      for t in nya
        p t.scan(/([+-]?[0-9]+)%?/)
      end
    end
  end

  desc "get JSON from specific lua table."
  task :job => :environment do
    @state = Rufus::Lua::State.new
    res = @state.eval('
      local json = require("lib.assets.json")
      local table = require("lib.assets.Resources.resources_data.jobs")
      return json.stringify(table)
    ')
    JSON.parse(res).each do |data|
      @job = Job.find_or_initialize_by(id: data[0])
      @job.update(
        ja:   data[1]["ja"],
        en:   data[1]["en"],
        jas:  data[1]["jas"],
        ens:  data[1]["ens"],        
      )
    end
  end

  desc "counts frequency of property name usage."
  task :property => :environment do
    hash = Hash.new
    hash.default = 0

    Description.all.each do |data|
      str = data.ja
      nya = str.gsub(/\n/," ").gsub(/[+-]?[0-9]+%?/, "").split(/\s/)
      nya.each do |prop|
        hash[prop] += 1
      end
    end
    p hash.sort {|(k1, v1), (k2, v2)| v2 <=> v1}
  end

  desc "TEST Colorize"
  task :color => :environment do
    String.colors.each do |color|
      puts ColorizedString[color.to_s].colorize(color)
    end
  end
end