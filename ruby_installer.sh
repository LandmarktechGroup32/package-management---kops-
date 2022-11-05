#!/bin/bash

curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
\curl -sSL https://get.rvm.io | bash -s stable
source /home/ec2-user/.rvm/scripts/rvm
echo `rvm --version` is now installed
rvm install 2.6.3
