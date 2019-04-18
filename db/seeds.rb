# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

tables = ActiveRecord::Base.connection.tables - ["schema_migrations","ar_internal_metadata"]
tables.each { |table|
  puts table
  model = table.classify.constantize
  begin
    CSV.foreach("db/csv/#{table}.csv", headers: true) do |row|
      begin
        hash = row.to_h.reject{ |k,_v| !model.column_names.member?(k) }
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

User.find_or_create_by(id: 1).update(
  email: 'user@checkparam.com',
  password: 'password',
  auth: {"info": {"nickname": "from20020516"}, "extra": {"raw_info": {"profile_image_url_https": "/icons/default_profile.png"}}}
)

tables.each { |table|
  model = table.classify.constantize
  puts [table, model.all.length].to_s
}