## Macbook Pro / Development Environment Setup

1. Backup these items from your previous machine and copy to your new machine:

```
~/.aws
~/.bash_profile
~/.npmrc
~/.ssh
```

2. Clone this repo:

```
git clone https://github.com/hlibco/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod -R +x ./
```

3. Review all files and adjust them to your needs.

4. Create a file `~/dotfiles/vars/repos.yml` with a content in the following format:

```
repos:
  - { src: repo_name, dest: checkout_folder_name }
````

4. Run `./setup.sh` in your terminal (inside this project folder)

```
./setup.sh
```


## Manual setup

- iTerm2: Preferences > General > Import
- Sequel Pro: Connections
- Login:
  - Google Chrome
  - Insomnia
  - Slack
- Restore .env (dotenv/install.sh)

---

## Run

Mongo DB:

```
mongod --dbpath ~/data/db
```

## TODO

- Redis
- Docker
 - Nginx
 - PHP
 - MySQL
- Double check mac defaults

1. Review my.cnf.j2 to add better settings

2. Review how to store git repos

3. Fix: Some repos are not installing dependencies due to NPM_TOKEN

http://codeheaven.io/15-things-you-should-know-about-ansible/
