#!/bin/sh

sudo apt install -y trash-cli
sudo sh -c "echo alias rm='trash' >> /etc/profile"

# use gnome settings -> privacy -> history & trash to set autoclean
