# Run this in hostside crontab.
wget https://github.com/ProjectTako/ffxi-addons/raw/master/equipviewer/icons.7z -O public/icons.7z
7za e public/icons.7z -aos -opublic/icons/ icons/64/*.png
git submodule update -i
docker-compose run app rails parse:items
docker-compose run app rails csv:export