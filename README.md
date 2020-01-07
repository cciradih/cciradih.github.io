```shell
apt-get update -y && apt-get upgrade -y
apt-add-repository ppa:brightbox/ruby-ng
apt-get update
apt-get install ruby2.6 ruby2.6-dev build-essential dh-autoreconf
gem update
gem install jekyll bundler
bundle exec jekyll serve
```
