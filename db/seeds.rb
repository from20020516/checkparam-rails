# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

tables = ActiveRecord::Base.connection.tables - ["schema_migrations","ar_internal_metadata","wikis"]
tables.each { |table|
  puts table
  model = table.classify.constantize
  begin
    CSV.foreach("db/csv/#{table}.csv", headers: true) do |row|
      begin
        hash = row.to_h
        model.find_or_create_by(hash)
      rescue => e
        pp e
        break
      end
    end
  rescue => e
    pp e
  end
  puts [table, model.all.length].to_s
}

tables.each { |table|
  model = table.classify.constantize
  puts [table, model.all.length].to_s
}