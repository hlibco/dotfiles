### Env

My Environment Setup
---

1. Backup these items from your previous machine and copy to your new machine:

```
~/.aws
~/.bash_profile
~/.npmrc
~/.ssh
```

2. Clone this repo:

```
git clone https://github.com/caarlos0/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod -R +x ./
```

3. Review all files and adjust them to your needs.


4. Run `./setup.sh` in your terminal (inside this project folder)

```
./setup.sh
```


### MacOS defaults

You use it by running:

```
$DOTFILES/macos/set-defaults.sh
```

## Tmux
https://github.com/gpakosz/.tmux


---

## TODO


- Clone repos
- Run npm install after clone repoo
- Restore .env
- Nginx
- PHP

- Setup tmux
- Double check mac defaults
- Setup DB users / connections

- Mongodb
- Redis



PROBLEMS:

1. my.cnf.j2 is not being copied to the destination
2. Review: mariadb.yml
