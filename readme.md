# accessible dotfiles

This is a collection of useful functions to improve accessibility on the terminal.

## navigation

Use the `adh` (Accessible Dotfiles Help) function to navigate the hierarchy:

List all topics:
    adh

List scripts in a topic:
    adh github

List functions in a script:
    adh github invites

## how to add new stuff

1. For a new topic, create a new folder
2. Related functions live in the same shell file
3. Add a comment directly before each function to document it:

Example:
    # Accept all pending GitHub repository invitations
    gh_accept_invites() {
      # do stuff
    }

The `adh` function will automatically display these descriptions.

## dependencies

- sudo apt install jq
- for github, install gh cli (follow their instructions)

## setup in a new machine

From your home:

1. git clone https://github.com/btraven00/accessible-dotfiles
2. source the init script from the end of your .bashrc:
   source $HOME/accessible-dotfiles/init.sh

## update

1. cd ~/accessible-dotfiles
2. git pull
3. cd ~
4. source .bashrc


## scripts

- github/invites.sh: GitHub repository invitation management
