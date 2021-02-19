# frozen_string_literal: true

namespace :csv do
  require 'csv'

  def tables
    ActiveRecord::Base.connection.tables - %w[schema_migrations ar_internal_metadata encrypted_password]
  end

  desc "show table names."
  task status: :environment do
    tables.each do |table|
      model = table.classify.constantize
      puts [table, model.all.length].to_s
    end
  end

  desc "export DB to csv."
  task :export, ['name'] => :environment do |_, args|
    t = args.name ? [args.name] : tables
    t.each do |table|
      puts "[Export] #{table}.csv"
      model = table.classify.constantize
      column_names = model.column_names - %w[created_at updated_at]
      begin
        current_csv = CSV.generate do |csv|
          csv << column_names
          model.all.each do |elem|
            csv << elem.slice(column_names).values
          end
        end
        File.open("db/csv/#{table}.csv", 'w') do |file|
          file.write(current_csv)
        end
      rescue StandardError => e
        pp e, hash
        break
      end
    end
  end

  desc "import csv to DB."
  task :import, ['name'] => :environment do |_, args|
    t = args.name ? [args.name] : tables
    t.each do |table|
      puts "[Import] #{table}.csv"
      model = table.classify.constantize
      primary_key = model.primary_key.to_sym
      column_names = (model.column_names - %w[created_at updated_at]).map(&:to_sym)
      begin
        CSV.foreach("db/csv/#{table}.csv", headers: true, header_converters: :symbol) do |row|
          hash = row.to_h.slice(*column_names)
          p [model, hash[primary_key]] if hash[primary_key] % 1000 == 0
          model.find_or_initialize_by(primary_key => hash[primary_key]).update(hash)
        rescue StandardError => e
          pp "ERR: #{e}", hash
          break
        end
      rescue StandardError => e
        pp "ERR: #{e}"
      end
    end
  end
end
