```shell
apt-get update -y && apt-get upgrade -y
apt-add-repository ppa:brightbox/ruby-ng
apt-get install ruby2.6 ruby2.6-dev build-essential dh-autoreconf
gem sources --remove https://rubygems.org/
gem sources -a https://mirrors.aliyun.com/rubygems/
gem update
gem install jekyll
bundle exec jekyll serve
```
