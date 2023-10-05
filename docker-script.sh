#!/bin/bash
# 
# Pandora-Isomemo HelperScript:
# This script can be used to pull, start & stop docker images 
# of the Pandora-Isomemo Apps 

# List of applications
apps=(
# new names
  #"BMSC-S"
  #"Bpred"
  #"DSSM"
  #"MapR"
  #"OsteoBioR"
  #"PlotR"
  #"ReSources"
# old names 
  "bmsc-app"
  "bpred"
  "iso-app"
  "osteo-bior"
  "plotr"
  "resources"
)

function check_root(){
  if [ "$EUID" -ne 0 ]; then
    echo >&2 "Please run as root";
    exit 1;
  fi
}

function check_requirements() {
  req_warning='The required ss tool is not installed. Please install it and run the script again.'
    
  command -v ss >/dev/null 2>&1 || 
    {
      echo >&2 "$req_warning"; 
      exit 1; 
    }
}

function get_free_port() {
    local port=3838
    while true; do
        if ss -ltn | grep -q ":$port "; then
            port=$((port+1))
        else
            echo $port
            break
        fi
    done
}

function pull_image() {
  docker pull ghcr.io/pandora-isomemo/$app:main
  docker pull ghcr.io/pandora-isomemo/$app:beta
}

function start_container() {
    version="main"
    port=$(get_free_port)
    container_name="ghcr.io/pandora-isomemo/$app"
    
    echo "Starting Docker image $app:$version"
    
    if docker run -d -q -p $port:3838 $container_name:$version; then
      echo "Docker image $app:$version started successfully"
      echo "Please open your web browser and visit: http://localhost:$port"
      printf "\n"
    else
      echo "Error starting Docker image $app:$version. Please ensure the image has been pulled and the port $port is free."
    fi
}

function select_apps() {
  clear
  echo "Available Apps:"
  printf "\n"

  # Display all available apps
  for i in "${!apps[@]}"; do
      index=$((i + 1))
      echo "$index. ${apps[$i]}"
  done

  # Prompt the user to enter subset of apps
  printf "\n"
  read -p "Please enter your choices [space-separated list of integer or 'all']: " -a choices
  printf "\n"

  for choice in "${choices[@]}"; do
    if [[ "$choice" == "all" ]]; then
      # Execute the command for all apps
      for app in "${apps[@]}"; do
          # Replace 'your_command' with the actual command you want to run
          $cmd_to_run
      done

      printf "\n"
      read -p "$cmd_to_run for all apps finished. [Press Any Key]"
      break

    elif [[ $choice =~ ^[0-9]+$ ]] && 
    [[ $choice -ge 1 ]] && 
    [[ $choice -lt ${#apps[@]} ]]; then
      app="${apps[$choice - 1]}"
      if [ -z "$app" ]; then
        read -p "Invalid option $choice. Ignoring. [Press Any Key]"
      else
        # Execute the command for the selected app
        # Replace 'your_command' with the actual command you want to run
        $cmd_to_run
      fi
      
      printf "\n"
      read -p "$cmd_to_run for $app finished. [Press Any Key]"
    else
      read -p "Invalid choice: $choice. Ignoring. [Press Any Key]"
    fi
  done
}

clear
check_root
check_requirements

while true
do
  echo "Pandora-Isomemo Helper Script:"; printf "\n";
  echo "1. List all local pandora-isomemo images"
  echo "2. Pull docker images";
  echo "3. Start docker container";
  echo "4. Stop running docker container":
  echo "5. Exit script"; printf "\n"

  read -rep $'Please enter your choice [Press 1-5]: ' choice

  case $choice in
      1)
        clear
        
        echo "List of all local pandora-isomemo images"; printf "\n"
        docker images "ghcr.io/pandora-isomemo/*" \
          | (read -r; printf "%s\n" "$REPLY"; sort)
        printf "\n"
        
        echo "List of all running pandora-isomemo container"; printf "\n"
        docker ps
        printf "\n"
        
        read -p "Go back to menu [Press Any Key]"
        clear
        ;;
      2) 
        cmd_to_run="pull_image"
        select_apps
        clear
        ;;
      3)
        cmd_to_run="start_container"
        select_apps
        clear
        ;;
      4)
        cmd_to_run="stop_container"
        #ToDo: stop container
        echo $cmd_to_run
        read -p "docker container stopped!"
        #for container_id in $(docker ps --filter "name=myapp" --format "{{.ID}}"); do
        #  docker stop $container_id 
        #done
        #clear
        ;;
      5)
        # ToDo Warning for running container
        echo "Exiting script. Bye!"
        exit 0
        ;;
      *)
        read -p "Invalid option. try again. [Press Any Key]";
        clear;
        ;;
  esac
done

#############

#    running_container=$(docker ps | grep "ghcr.io/pandora-isomemo/*" )
#           clear
#           echo "There are $(echo $running_container | wc -l) running pandora-isomemo container"
#           read -p "Do you wanna stop them [y/n]: " yn
#           case $yn in
#             y)
#               docker stop $(echo $running_container | cut -d " " -f1)
#               echo "All pandora-isomemo container stopped"
#               ;;
#             n)
#               echo "All pandora-isomemo container stopped"
#               ;;
#             *)
#               read -p "Invalid option. try again. [Press Any Key]"
#               ;;
#           esac

