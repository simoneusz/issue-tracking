[Heroku](https://obscure-dawn-98567-a80256b30b28.herokuapp.com/)

# Requirements

- Ruby: 3.4.2
- Rails: 8.x
- PostgreSQL: latest stable
- Node.js & Yarn: for assets compilation

# Installation guide

clone the repo:
```
git clone git@github.com:simoneusz/issue-tracking.git
cd issue-tracking
```
bundle install:
```
bundle install
```
copy env vars:
```
cp example.env .env
```
db setup:
```
rails db:create
rails db:migrate
rails db:seed
```
run the server:
```
rails server
```

# Project gallery: 

## Projects intex page
![alt text](https://github.com/simoneusz/issue-tracking/blob/main/git-images/3.png?raw=true)

## Project show page
![alt text](https://github.com/simoneusz/issue-tracking/blob/main/git-images/4.png?raw=true)

## Project create
![alt text](https://raw.githubusercontent.com/simoneusz/issue-tracking/refs/heads/main/git-images/6.png)

## Issue show
![alt text](https://raw.githubusercontent.com/simoneusz/issue-tracking/refs/heads/main/git-images/5.png)

## Issue new
![alt text](https://raw.githubusercontent.com/simoneusz/issue-tracking/refs/heads/main/git-images/7.png)

## Tests, Lint
run the specs:
```
bundle exec rspec
```
![alt text](https://github.com/simoneusz/issue-tracking/blob/main/git-images/2.png?raw=true)

Rubocop:
![alt text](https://github.com/simoneusz/issue-tracking/blob/main/git-images/1.png?raw=true)
