# Track Git Tag

A simple tool to track GitHub repository releases via tags.

## Table of Contents
- [Description](#description)
- [Prerequisites](#prerequisites)
- [Install](#install)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Description

Track Git Tag is a utility that helps you monitor version updates for your favorite GitHub repositories. It provides a graphical interface to:

- Track multiple GitHub repositories
- Check for new releases/tags
- Add new repositories to monitor
- Update tracked versions

## Prerequisites

The following packages are required:

```bash
sudo apt-get install git
sudo apt-get install zenity
sudo apt-get install jq
```

## Install

In a folder of your choice:

```bash
git clone https://github.com/Acktarius/track_git.git
cd track_git
./shortcut_creator.sh
```

Note, make sure `shortcut_installer_.sh` and `track_git_tag.sh` are executable, if not:

```bash
chmod 755 shortcut_installer.sh
chmod 755 track_git_tag.sh
```

## Run

Click on the created icon:
- The script will compare if there is a new tag since your last check.
- If you update a repo in regard to the new release, you can check the box and click on update.
- You can click add to add a new repo to track, URLs are in the following format: `https://github.com/Acktarius/track_git.git`
- You can also manually intervene on the JSON file, as long as you respect the format.

## Usage

Here's a quick example of how you might use Track Git Tag:
- Open the application.
- At a glance monitor a repository for new tags/releases since last record.
- Add a repository by entering its URL.
- No need to have the repository clone on the computer, this way you can track release for your phone apk for example.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the BSD 3-Clause License. See the LICENSE file for details.

## Contact

For questions or support, join us on Discord [https://discord.gg/DckYXrFK](https://discord.gg/DckYXrFK).
