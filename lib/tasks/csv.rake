namespace :csv do
  require 'csv'

  def tables
    ActiveRecord::Base.connection.tables - ["schema_migrations","ar_internal_metadata","users"]
  end

  task :check => :environment do
    tables.each { |table|
      model = table.classify.constantize
      puts [table, model.all.length].to_s
    }
  end

  task :export => :environment do
    tables.each { |table|
      puts table
      model = table.classify.constantize
      column_name = model.column_names - ["created_at","updated_at"]
      begin
        CSV.open("db/csv/#{table}.csv", 'wb') { |csv|
          csv << column_name
          model.all.each { |elem|
            csv << elem.slice(column_name).values
          }
        }
      rescue => e
        pp e
        break
      end
    }
  end

  task :import => :environment do
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
    }
  end
end