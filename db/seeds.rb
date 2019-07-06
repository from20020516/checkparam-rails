# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

tables = ActiveRecord::Base.connection.tables - %w[schema_migrations ar_internal_metadata]
tables.each do |table|
  puts table
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
  puts [table, model.all.length].to_s
end

User.find_or_create_by(id: 1).update(
  email: 'user@checkparam.com',
  password: 'password',
  auth: { "info": { "nickname": 'from20020516' }, "extra": { "raw_info": { "profile_image_url_https": 'https://pbs.twimg.com/profile_images/1015401949636595712/Ui7wSlva_400x400.jpg' } } }
)

tables.each do |table|
  model = table.classify.constantize
  puts [table, model.all.length].to_s
end
