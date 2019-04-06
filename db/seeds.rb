# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ pos:,name: 'Star Wars' }, { pos:,name: 'Lord of the Rings' }])
#   Character.create(pos:,name: 'Luke', movie: movies.first)

Slot.delete_all
Slot.create([
  {id:1,pos:0,name:{en:"main",ja:"メイン"},img:16622},
  {id:2,pos:1,name:{en:"sub",ja:"サブ"},img:12332},
  {id:3,pos:2,name:{en:"range",ja:"レンジ"},img:17174},
  {id:4,pos:3,name:{en:"ammo",ja:"矢弾"},img:17326},
  {id:5,pos:4,name:{en:"head",ja:"頭"},img:12523},
  {id:6,pos:9,name:{en:"neck",ja:"首"},img:13074},
  {id:7,pos:11,name:{en:"ear1",ja:"左耳"},img:13358},
  {id:8,pos:12,name:{en:"ear2",ja:"右耳"},img:13358},
  {id:9,pos:5,name:{en:"body",ja:"胴"},img:12551},
  {id:10,pos:6,name:{en:"hands",ja:"両手"},img:12679},
  {id:11,pos:13,name:{en:"ring1",ja:"左指"},img:13505},
  {id:12,pos:14,name:{en:"ring2",ja:"右指"},img:13505},
  {id:13,pos:15,name:{en:"back",ja:"背"},img:13606},
  {id:14,pos:10,name:{en:"waist",ja:"腰"},img:13215},
  {id:15,pos:7,name:{en:"legs",ja:"両脚"},img:12807},
  {id:16,pos:8,name:{en:"feet",ja:"両足"},img:12935},
])

Job.delete_all
Job.create([
  {id:0},
  {id:1,name:{ja:"戦士",en:"Warrior"},ens:"WAR",jas:"戦"},
  {id:2,name:{ja:"モンク",en:"Monk"},ens:"MNK",jas:"モ"},
  {id:3,name:{ja:"白魔道士",en:"WhiteMage"},ens:"WHM",jas:"白"},
  {id:4,name:{ja:"黒魔道士",en:"BlackMage"},ens:"BLM",jas:"黒"},
  {id:5,name:{ja:"赤魔道士",en:"RedMage"},ens:"RDM",jas:"赤"},
  {id:6,name:{ja:"シーフ",en:"Thief"},ens:"THF",jas:"シ"},
  {id:7,name:{ja:"ナイト",en:"Paladin"},ens:"PLD",jas:"ナ"},
  {id:8,name:{ja:"暗黒騎士",en:"DarkKnight"},ens:"DRK",jas:"暗"},
  {id:9,name:{ja:"獣使い",en:"Beastmaster"},ens:"BST",jas:"獣"},
  {id:10,name:{ja:"吟遊詩人",en:"Bard"},ens:"BRD",jas:"詩"},
  {id:11,name:{ja:"狩人",en:"Ranger"},ens:"RNG",jas:"狩"},
  {id:12,name:{ja:"侍",en:"Samurai"},ens:"SAM",jas:"侍"},
  {id:13,name:{ja:"忍者",en:"Ninja"},ens:"NIN",jas:"忍"},
  {id:14,name:{ja:"竜騎士",en:"Dragoon"},ens:"DRG",jas:"竜"},
  {id:15,name:{ja:"召喚士",en:"Summoner"},ens:"SMN",jas:"召"},
  {id:16,name:{ja:"青魔道士",en:"BlueMage"},ens:"BLU",jas:"青"},
  {id:17,name:{ja:"コルセア",en:"Corsair"},ens:"COR",jas:"コ"},
  {id:18,name:{ja:"からくり士",en:"Puppetmaster"},ens:"PUP",jas:"か"},
  {id:19,name:{ja:"踊り子",en:"Dancer"},ens:"DNC",jas:"踊"},
  {id:20,name:{ja:"学者",en:"Scholar"},ens:"SCH",jas:"学"},
  {id:21,name:{ja:"風水士",en:"Geomancer"},ens:"GEO",jas:"風"},
  {id:22,name:{ja:"魔導剣士",en:"RuneFencer"},ens:"RUN",jas:"剣"},
  {id:23},
])