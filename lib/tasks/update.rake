# frozen_string_literal: true

namespace :update do

  desc "Update Items."
  task items: :environment do
    sh "wget https://github.com/ProjectTako/ffxi-addons/raw/master/equipviewer/icons.7z -O public/icons.7z && \
        7za e public/icons.7z -aos -opublic/icons/ icons/64/*.png && \
        cd Resources && git pull && cd .. && \
        rails parse:wiki && \
        rails parse:items && \
        rails csv:export"
  end
end