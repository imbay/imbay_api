####**Linux Ubuntu 16.04.3 LTS (Xenial) x64**

---
##### Install Ruby
```
sudo apt-add-repository ppa:brightbox/ruby-ng &&\
sudo apt update &&\
sudo apt install libxml2-dev libssl-dev zlib1g-dev imagemagick sqlite3 libsqlite3-dev ruby2.4 ruby2.4-dev
```
##### Install NodeJS & NPM
```
sudo apt install curl &&\
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - &&\
sudo apt update &&\
sudo apt install -y nodejs=6.11.*
```
##### Install Ruby on Rails
```
sudo gem install bundler:1.15.3 rails:5.1.2 --no-ri --no-rdoc
```
##### Install PostgreSQL
```
touch /etc/apt/sources.list.d/pgdg.list && echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/pgdg.list wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \ apt-key add - apt-get update && apt-get install postgresql-9.6 libpq-dev pgadmin3
```
##### Create database in PostgreSQL
```
sudo su postgres
psql
CREATE USER nurasyl WITH PASSWORD '12345';
ALTER ROLE nurasyl SET client_encoding TO 'utf8';
ALTER ROLE nurasyl SET default_transaction_isolation TO 'SERIALIZABLE';
ALTER ROLE nurasyl SET timezone TO 'UTC';
CREATE DATABASE imaby;
CREATE DATABASE imaby_test;
CREATE DATABASE imaby_development;
GRANT ALL PRIVILEGES ON DATABASE imaby, imaby_test, imaby_development TO nurasyl;
\du
q
psql -d imbay -U nurasyl -h 127.0.0.1 -p 5432
\c
\q
exit
```
##### Install redis
```
wget http://download.redis.io/releases/redis-4.0.1.tar.gz
tar xzf redis-4.0.1.tar.gz
cd redis-4.0.1
make
sudo cp src/redis-server /usr/local/bin/
sudo cp src/redis-cli /usr/local/bin/
```
##### Run redis server
```
redis-server ./redis.conf
```
##### Install gems.
```
bundle install
bundle update
```
##### Test
```
bundle exec rake
bundle exec rspec
```
##### Migration
```
rake db:seed RAILS_ENV=production
rake db:migrate RAILS_ENV=production
```

##### Run RoR server
```
RAILS_ENV=production bundle exec passenger start
```
