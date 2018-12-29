namespace :scrape do

  desc "get lua tables."
  task :sample => :environment do

    require 'rufus-lua'
    @state = Rufus::Lua::State.new
    res = @state.eval('
      local res = require("lib.assets.Resources.resources_data.elements")
      local json = require("lib.assets.json")
      return json.stringify(res)
    ')
    JSON.parse(res).each do |data|
      p data[1]
    end
  end
end