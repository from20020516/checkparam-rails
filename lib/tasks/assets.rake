namespace :assets do
  task non_digested: :environment do
    assets = Dir.glob(File.join(Rails.root, 'public/assets/**/*'))
    regex = /(-{1}[a-z0-9]{32}*\.{1}){1}/
    assets.each do |file|
      next if File.directory?(file) || file !~ regex

      source = file.split('/')
      source.push(source.pop.gsub(regex, '.'))

      FileUtils.cp(file, File.join(source))
      FileUtils.cp(file, "./.aws-cdk/s3/assets/#{source.last}")
    end
  end
end
