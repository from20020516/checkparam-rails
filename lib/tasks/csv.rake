namespace :csv do
  require 'csv'
  require 'byebug'

  def tables
    ActiveRecord::Base.connection.tables - %w[schema_migrations ar_internal_metadata encrypted_password]
  end

  task :check => :environment do
    tables.each { |table|
      model = table.classify.constantize
      puts [table, model.all.length].to_s
    }
  end

  task :export, ['name'] => :environment do |_, args|
    t = args.name ? [args.name] : tables
    t.each { |table|
      puts table
      model = table.classify.constantize
      column_name = model.column_names - %w[created_at updated_at]
      begin
        current_csv = CSV.generate(force_quotes: true) { |csv|
          csv << column_name
          model.all.each { |elem|
            csv << elem.slice(column_name).values
          }
        }
        File.open("db/csv/#{table}.csv", 'w') { |file|
          file.write(current_csv)
        }

        # CSV.open("db/csv/#{table}.csv", 'w', quote_char) { |csv|
        #   csv << column_name
        #   model.all.each { |elem|
        #     csv << elem.slice(column_name).values
        #   }
        # }
      rescue => e
        pp e
        break
      end
    }
  end

  task :import, ['name'] => :environment do |_, args|
    t = args.name ? [args.name] : tables
    t.each { |table|
      puts table
      model = table.classify.constantize
      column_name = model.column_names - %w[created_at updated_at]
      begin
        CSV.foreach("db/csv/#{table}.csv", headers: true, header_converters: :symbol) do |row|
          begin
            hash = row.to_h.slice(*column_name.map(&:to_sym))
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