# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
## Model: Slot, Job, User, Gearset

Slot.delete_all
Slot.create([
  {id: 1, pos: 0, en: "main", img: 16622},
  {id: 2, pos: 1, en: "sub", img: 12332},
  {id: 3, pos: 2, en: "range", img: 17174},
  {id: 4, pos: 3, en: "ammo", img: 17326},
  {id: 5, pos: 4, en: "head", img: 12523},
  {id: 6, pos: 9, en: "neck", img: 13074},
  {id: 7, pos: 11, en: "ear1", img: 13358},
  {id: 8, pos: 12, en: "ear2", img: 13358},
  {id: 9, pos: 5, en: "body", img: 12551},
  {id: 10, pos: 6, en: "hands", img: 12679},
  {id: 11, pos: 13, en: "ring1", img: 13505},
  {id: 12, pos: 14, en: "ring2", img: 13505},
  {id: 13, pos: 15, en: "back", img: 13606},
  {id: 14, pos: 10, en: "waist", img: 13215},
  {id: 15, pos: 7, en: "legs", img: 12807},
  {id: 16, pos: 8, en: "feet", img: 12935},
])

Job.delete_all
Job.create([
  {id: 0},
  {id: 1, ja: "戦士", en: "Warrior", ens: "WAR", jas: "戦"},
  {id: 2, ja: "モンク", en: "Monk", ens: "MNK", jas: "モ"},
  {id: 3, ja: "白魔道士", en: "WhiteMage", ens: "WHM", jas: "白"},
  {id: 4, ja: "黒魔道士", en: "BlackMage", ens: "BLM", jas: "黒"},
  {id: 5, ja: "赤魔道士", en: "RedMage", ens: "RDM", jas: "赤"},
  {id: 6, ja: "シーフ", en: "Thief", ens: "THF", jas: "シ"},
  {id: 7, ja: "ナイト", en: "Paladin", ens: "PLD", jas: "ナ"},
  {id: 8, ja: "暗黒騎士", en: "DarkKnight", ens: "DRK", jas: "暗"},
  {id: 9, ja: "獣使い", en: "Beastmaster", ens: "BST", jas: "獣"},
  {id: 10, ja: "吟遊詩人", en: "Bard", ens: "BRD", jas: "詩"},
  {id: 11, ja: "狩人", en: "Ranger", ens: "RNG", jas: "狩"},
  {id: 12, ja: "侍", en: "Samurai", ens: "SAM", jas: "侍"},
  {id: 13, ja: "忍者", en: "Ninja", ens: "NIN", jas: "忍"},
  {id: 14, ja: "竜騎士", en: "Dragoon", ens: "DRG", jas: "竜"},
  {id: 15, ja: "召喚士", en: "Summoner", ens: "SMN", jas: "召"},
  {id: 16, ja: "青魔道士", en: "BlueMage", ens: "BLU", jas: "青"},
  {id: 17, ja: "コルセア", en: "Corsair", ens: "COR", jas: "コ"},
  {id: 18, ja: "からくり士", en: "Puppetmaster", ens: "PUP", jas: "か"},
  {id: 19, ja: "踊り子", en: "Dancer", ens: "DNC", jas: "踊"},
  {id: 20, ja: "学者", en: "Scholar", ens: "SCH", jas: "学"},
  {id: 21, ja: "風水士", en: "Geomancer", ens: "GEO", jas: "風"},
  {id: 22, ja: "魔導剣士", en: "RuneFencer", ens: "RUN", jas: "剣"},
  {id: 23},
])

begin
  User.create(
    id: 1,
    email: 'user@checkparam.com',
    password: 'password',
    # uid: 1042812468748156928,
    # provider: "twitter",
    auth: {"info": {"nickname": "from20020516"}, "extra": {"raw_info": {"profile_image_url_https": "/default_profile_400x400.png"}}})
rescue => e
  puts e
end

Gearset.create([
  {id: 1, user_id: 1, job_id: 1, set_id: 1, main: 21758, sub: 22212, range: nil, ammo: 22281, head: 23375, neck: 25419, ear1: 14813, ear2: 27545, body: 23442, hands: 23509, ring1: 13566, ring2: 15543, back: 26246, waist: 26334, legs: 23576, feet: 23643},
  {id: 2, user_id: 1, job_id: 16, set_id: 1, main: 20695, sub: 20689, range: nil, ammo: 21371, head: 25614, neck: 26015, ear1: 14739, ear2: 27545, body: 25687, hands: 27118, ring1: 11651, ring2: 26186, back: 26261, waist: 28440, legs: 27295, feet: 27496},
  {id: 3, user_id: 1, job_id: 13, set_id: 1, main: 21907, sub: 21906, range: nil, ammo: 21391, head: 23387, neck: 25491, ear1: 14739, ear2: 14813, body: 23454, hands: 23521, ring1: 13566, ring2: 15543, back: 16207, waist: 28440, legs: 27318, feet: 23655},
  {id: 4, user_id: 1, job_id: 3, set_id: 1, main: 21078, sub: 27645, range: nil, ammo: 22268, head: 26745, neck: 28357, ear1: 28480, ear2: 28474, body: 26903, hands: 27057, ring1: 13566, ring2: 26200, back: 28619, waist: 28419, legs: 27242, feet: 27416},
  {id: 5, user_id: 1, job_id: 7, set_id: 1, main: 20687, sub: 16200, range: nil, ammo: 22279, head: 26671, neck: 26002, ear1: 28483, ear2: 27549, body: 26847, hands: 27023, ring1: 13566, ring2: 26200, back: 26252, waist: 28437, legs: 27199, feet: 27375}
])