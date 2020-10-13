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

or push an existing repository from the command line
```
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