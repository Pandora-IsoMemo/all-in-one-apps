# All-In-One App Script

`all-in-one-app.sh` - script for working with the pandora-isomemo docker apps

**ONLY TESTED ON LINUX**

**SHOULD RUN ON MACOS**

**CURRENTLY NO SOLUTION FOR WINDOWS**

## Features

- List available Docker images and running containers
- Pull Docker images
- Start Docker containers
- Stop running Docker containers

## Usage

To use the script, follow these steps:

1. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) 
   this repository: `git clone <repository-url>` or download the
   [raw file](https://github.com/Pandora-IsoMemo/all-in-one-apps/blob/main/docker-script.sh)
2. Navigate to the directory where you saved the script: `cd <directory>`
3. Make the script executable: `chmod +x all-in-one-app.sh`
4. Run the script with sudo permissions: `sudo ./all-in-one-app.sh`

The script will present a menu with options to list Docker images and running 
containers, pull images, start containers and stop containers. Follow the 
prompts to perform the desired actions.

## Requirements

The script requires the following software to be installed:

* [docker](https://docs.docker.com/)
    * Linux: <https://docs.docker.com/desktop/install/linux-install/>
    * MacOS: <https://docs.docker.com/desktop/install/mac-install/>
* [netstat](https://linux.die.net/man/8/netstat)
    * should be installed by default on most Linux distributions and on macOS
    * Linux: `sudo apt update & sudo apt install net-tools`
    * MacOS: `brew install net-tools`



