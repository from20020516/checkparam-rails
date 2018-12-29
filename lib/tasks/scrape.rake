namespace :scrape do

  desc "get lua tables."
  task :sample => :environment do

    require 'rufus-lua'
    @state = Rufus::Lua::State.new
    res = @state.eval('
      local json = require("lib.assets.json")
      local item = require("lib.assets.Resources.resources_data.items")
      local desc = require("lib.assets.Resources.resources_data.item_descriptions")
      local ary = {}

      for i,v in pairs(item) do -- FILTER
        if v.category == "Weapon"
        and v.item_level
        and v.item_level == 119 then
          ary[i] = {v, desc[i]}
        end
      end
      return json.stringify(ary)
    ')
    JSON.parse(res).each do |data|
      @equipment = Equipment.find(data[0]).update(
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
end