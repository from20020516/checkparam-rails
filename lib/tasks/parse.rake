namespace :parse do
  require 'colorize'
  require 'colorized_string'
  require 'rufus-lua'

  desc "get Items from lua."
  task :fetch => :environment do
    @state = Rufus::Lua::State.new
    res = @state.eval('
      local json = require("lib.assets.json")
      local item = require("lib.assets.Resources.resources_data.items")
      local desc = require("lib.assets.Resources.resources_data.item_descriptions")
      local ary = {}

      for i,v in pairs(item) do -- FILTER
        if (v.category == "Weapon" or v.category == "Armor")
        and v.level >= 1
        and v.item_level == 118
        then
          ary[i] = {v, desc[i] or ""}
        end
      end
      return json.stringify(ary)
    ')

    JSON.parse(res).each do |data|
      @item = Item.find_or_initialize_by(id: data[0])
      @item.update(
        jal:    data[1][0]["jal"],
        enl:    data[1][0]["enl"],
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

  desc "counts frequency of property name usage."
  task :counts => :environment do
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