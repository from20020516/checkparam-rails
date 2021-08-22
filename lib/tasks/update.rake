# frozen_string_literal: true

namespace :update do

  desc "Update Items"
  task items: :environment do
    sh "git submodule update --remote && \
        rails parse:wiki && \
        rails parse:items"
  end

  desc "Update Icons"
  task icons: :environment do
    sh "wget https://github.com/ProjectTako/ffxi-addons/raw/master/equipviewer/icons.7z -O .aws-cdk/icons.7z && \
        7za e .aws-cdk/icons.7z -aos -o.aws-cdk/s3/ 32/*.png"
  end
end
