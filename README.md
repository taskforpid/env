# env
create a new repository on the command line

```
$ echo "# env" >> README.md
$ git init
$ git add README.md
$ git commit -m "first commit"
$ git branch -M main
$ git remote add origin https://github.com/taskforpid/env.git
$ git push -u origin main
```               

update
```
$ git add .
$ git restore .
$ git commit -m "update"
$ git branch -M main
$ git remote add origin https://github.com/taskforpid/env.git
$ git branch -M main
$ git push -u origin main
```

worktree - you are not currently on a branch git pull
```
$ git checkout -b newbranch
$ git checkout master
$ git merge newbranch
$ git branch -d newbranch
```
Please upgrade to Python 3.6+.

```
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.6
```