# frozen_string_literal: true

namespace :update do

  desc "Update Item."
  task item: :environment do
    sh "wget https://github.com/ProjectTako/ffxi-addons/raw/master/equipviewer/icons.7z -O public/icons.7z && \
        7za e public/icons.7z -aos -opublic/icons/ icons/64/*.png && \
        git submodule foreach git pull origin master && \
        rails parse:items && \
        rails csv:export"
  end
end