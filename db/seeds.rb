# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Import CSV.
tables = ActiveRecord::Base.connection.tables - %w[schema_migrations ar_internal_metadata]
tables.each do |table|
  model = table.classify.constantize
  begin
    CSV.foreach("db/csv/#{table}.csv", headers: true) do |row|
      hash = row.to_h.select { |k, _v| model.column_names.member?(k) }
      model.find_or_create_by(hash)
    rescue StandardError => e
      pp e
      break
    end
  rescue StandardError => e
    pp e
  end
  puts "Import #{table}.csv (#{model.all.length} Records)"
end

User.find_or_create_by(id: 1).update(
  email: 'user@checkparam.com',
  password: 'password',
  auth: { "info": { "nickname": 'from20020516' }, "extra": { "raw_info": { "profile_image_url_https": 'https://pbs.twimg.com/profile_images/1015401949636595712/Ui7wSlva_400x400.jpg' } } }
)

AFs = [
  { id: 1, user_id: 1, job_id: 1, set_id: 1, main: 21758, sub: 22212, range: nil, ammo: 22281, head: 23375, neck: 25419, ear1: 14813, ear2: 27545, body: 23442, hands: 23509, ring1: 13566, ring2: 15543, back: 26246, waist: 26334, legs: 23576, feet: 23643 },
  { id: 2, user_id: 1, job_id: 16, set_id: 1, main: 20695, sub: 20689, range: nil, ammo: 21371, head: 25614, neck: 26015, ear1: 14739, ear2: 27545, body: 25687, hands: 27118, ring1: 11651, ring2: 26186, back: 26261, waist: 28440, legs: 27295, feet: 27496 },
  { id: 3, user_id: 1, job_id: 13, set_id: 1, main: 21907, sub: 21906, range: nil, ammo: 21391, head: 23387, neck: 25491, ear1: 14739, ear2: 14813, body: 23454, hands: 23521, ring1: 13566, ring2: 15543, back: 16207, waist: 28440, legs: 27318, feet: 23655 },
  { id: 4, user_id: 1, job_id: 3, set_id: 1, main: 21078, sub: 27645, range: nil, ammo: 22268, head: 26745, neck: 28357, ear1: 28480, ear2: 28474, body: 26903, hands: 27057, ring1: 13566, ring2: 26200, back: 28619, waist: 28419, legs: 27242, feet: 27416 },
  { id: 5, user_id: 1, job_id: 7, set_id: 1, main: 20687, sub: 16200, range: nil, ammo: 22279, head: 26671, neck: 26002, ear1: 28483, ear2: 27549, body: 26847, hands: 27023, ring1: 13566, ring2: 26200, back: 26252, waist: 28437, legs: 27199, feet: 27375 }
]

Gearset.where(id: [1..5]).delete_all
Gearset.create(AFs)
