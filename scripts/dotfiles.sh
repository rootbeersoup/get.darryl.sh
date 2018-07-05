#!/bin/sh
#
#     /\\\                                  /\\\\\        /\\\\\\                              
#     \/\\\                                /\\\///   /\\\ \////\\\                              
#      \/\\\                  /\\\         /\\\      \///     \/\\\                              
#       \/\\\     /\\\\\    /\\\\\\\\\\\ /\\\\\\\\\ /\\\\\\    \/\\\       /\\\\\\\\   /\\\\\\\\\\
#   /\\\\\\\\\   /\\\///\\\ \////\\\//// \////\\\// \////\\\    \/\\\     /\\\/////\\\ \/\\\//////
#   /\\\////\\\  /\\\  \//\\\   \/\\\        \/\\\      \/\\\    \/\\\    /\\\\\\\\\\\  \/\\\\\\\\\\
#   \/\\\  \/\\\ \//\\\  /\\\    \/\\\ /\\    \/\\\      \/\\\    \/\\\   \//\\///////   \////////\\\
#    \//\\\\\\\/\\ \///\\\\\/     \//\\\\\     \/\\\      \/\\\    \/\\\\\\ \//\\\\\\\\\\  /\\\\\\\\\\
#      \///////\//    \/////        \/////      \///       \///     \//////   \//////////  \//////////
#
#
# dotfiles installation script
# Author: Darryl Abbate
# https://github.com/rootbeersoup/dotfiles
#
# Install by running this command:
# curl get.darryl.sh | sh


# Exit if a dotfiles directory already exists

if [ -d "$HOME/dotfiles" ]; then
  printf "\033[31mERROR:\033[0m dotfiles is already installed on this system. Exiting.\n" >&2
  exit 1
fi


# Keep sudo alive for the entire session

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# Display info

printf "\n\033[1mDOTFILES\033[0m\n"
printf "\n\033[31mWARNING:\033[0m This will install new files and may overwrite\nsome existing files in your home directory.\n"
printf "\nContinue? (y/n)\n"
read -s -n 1 REPLY
if ! [ $REPLY = Y -o $REPLY = y ]; then
  printf "\nProcess terminated by user.\n" >&2
  exit 1
else
  printf "\nInstalling dotfiles...\n"
fi


# Install git if not already installed
# Install Homebrew on macOS since it installs Xcode Command-Line Tools automatically

if ! [ -x "$(command -v git)" ]; then
  if [ "$(uname -s)" = "Darwin" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install git
  elif [ "$(uname -s)" = "Linux" ]; then
    sudo apt-get install git -y
  fi
fi


# Clone the dotfiles repository from GitHub and invoke the Makefile

git clone --recursive https://github.com/rootbeersoup/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
make