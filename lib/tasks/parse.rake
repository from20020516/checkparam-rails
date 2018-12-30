namespace :parse do
  require 'colorize'
  require 'rufus-lua'

  desc "get equipment data from lua."
  task :fetch => :environment do
    @state = Rufus::Lua::State.new
    res = @state.eval('
      local json = require("lib.assets.json")
      local item = require("lib.assets.Resources.resources_data.items")
      local desc = require("lib.assets.Resources.resources_data.item_descriptions")
      local ary = {}

      for i,v in pairs(item) do -- FILTER
        if (v.category == "Weapon" or v.category == "Armor")
        and v.level >= 1 then
          ary[i] = {v, desc[i] or ""}
        end
      end
      return json.stringify(ary)
    ')

    JSON.parse(res).each do |data|
      @equipment = Equipment.find_or_initialize_by(id: data[0])
      @equipment.update(
        jal:          data[1][0]["jal"],
        enl:          data[1][0]["enl"],
        group:        data[1][0]["type"],
        slot:         data[1][0]["slots"],
        skill:        data[1][0]["skill"],
        description:  data[1][1]["ja"],
        job:          data[1][0]["jobs"],
        lv:           data[1][0]["level"],
        itemlv:       data[1][0]["item_level"],
      )
    end
  end

  desc "counts frequency of property name usage."
  task :counts => :environment do
    hash = Hash.new
    hash.default = 0

    Equipment.all.each do |data|
      str = data.description
      nya = str.gsub(/\n/," ").gsub(/[+-]?[0-9]+%?/, "").split(/\s/)
      nya.each do |prop|
        hash[prop] += 1
      end
    end
    p hash.sort {|(k1, v1), (k2, v2)| v2 <=> v1}
  end

  # TO-DO: ペット対応
  desc "restructure equipment descriptions."
  task :rest => :environment do
    Equipment.all.each do |data|
      str = data.description
      puts data.jal.yellow, str.red
      nya = str.gsub(/\n/," ").split(/\s/)
      puts nya
    end
  end

  desc "colorize test"
  task :color => :environment do
    require 'colorize'
    require 'colorized_string'
    String.colors.each do |color|
      puts ColorizedString[color.to_s].colorize(color)
    end
  end
end