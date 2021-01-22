# Checkparam
> a Web site that provides gearset save and share for Final Fantasy XI.

## Requirements:
-   [Mac | Windows10 ver.2004+(WSL2)](https://code.visualstudio.com/docs/remote/containers#_getting-started)
-   [Docker Desktop](https://www.docker.com/products/docker-desktop)
-   [Visual Studio Code](https://code.visualstudio.com/)
-   [Twitter API Key](https://developer.twitter.com/en/application/use-case)

## Usage:
- [Cloning and Open this repository in VSCode.](https://code.visualstudio.com/docs/editor/versioncontrol#_cloning-a-repository)
- [Install Remote Development Extension](https://code.visualstudio.com/docs/remote/remote-overview)
- `Remote-Containers: Rebuild and Reopen in Container` (Found on Ctrl+Shift+P OR ⌘+Shift+P)
- Add `.env` file with your Twitter API keys. (Callback URI: `http://localhost:3000/users/auth/twitter/callback`)
- Exec commands inside devcontainer.
```
bundle
mysql -hmysql -uroot --password=secret checkparam < .devcontainer/checkparam.sql
rails update:items
rails s
```

## Docs:
-   [Remote - Containers](https://code.visualstudio.com/docs/remote/containers)
