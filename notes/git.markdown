---
layout: post
title: git
---

# git

Git is a version control system (VCS) that allows you to keep track of changes to your code. In this class, you will use git to submit your project code. Git is widely used in industry, so it's a good idea to
learn it early and use it often.

## Git installation

### Linux

If you use Ubuntu or some other Debian variant, this should work:

    sudo apt-get install git

For other distributions, refer to Google, or ask me.

### Windows

Download [msysGit](http://msysgit.github.io/). Use the default
options. Run the "Git Bash" program that's installed in order to use
git commands.

### Mac OS X

You can install git by installing "Xcode command line tools" with the
following command in a terminal:

    xcode-select --install

Or, download directly from the
[git project](http://git-scm.com/download/mac).

### Post-installation configuration

You'll need to tell git your name and email. Every commit is recorded
with a name and email. You should use the same email address you used
when you created a BitBucket account.

Execute these commands (**use your own name and email!**):

    git config --global user.name "Joshua Eckroth"
    git config --global user.email "jeckroth@stetson.edu"

## Basic concepts

- **repository**: git stores data about versions in a repository. If
  you put your files in a folder called, for example, `project-01`, and
  next run the `git init` command (described below), then the
  repository will be created in a special hidden folder `.git` inside
  the `project-01` folder. You can look in this folder if you want;
  just don't change anything (except possibly the `config` file, in
  special circumstances).
  
- **commit**: a snapshot of your files; these snapshots are made when
  you run the `git commit` command. Usually, a commit has a message
  that you type when you run that command; the message describes the
  changes you have made to your files since the prior commit.

## Basic workflow

Comments are shown after the `#` on each line. These commands should work on Linux/Mac OS X/Windows, assuming you have installed Git.

    mkdir project-01                      # create a new directory
    cd project-01                         # go into that directory
    git init                              # create a new empty git repository

    (...create BitBucket repository, send an "invitation" to me...)

    # next, register the BitBucket repository;
    # of course, CHANGE THIS EXAMPLE to your repository location!
    git remote add origin git@bitbucket.org:joshuaeckroth/csci201-demo.git

    (...write some code...)

    git add myfile1.txt myfile2.txt       # indicate which files to save in the commit
    git commit -m "My first commit!"      # do the commit

    (...write some code...)

    git commit -a -m "My second commit!"  # record all changed files in the second commit
    git push                              # upload commits to BitBucket



