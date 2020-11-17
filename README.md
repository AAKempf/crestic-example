# crestic config example and script files

## Introduction

[Restic](https://github.com/restic/restic), a wonderful backup tool, unfortunately has no configuration file to enter some basic parameters like password, repositories and the desired backup directories.

[Crestic](https://github.com/nils-werner/crestic) is a tool, which provides these parameters as restic-wrapper.

The files of this small project can serve as an example how to work with crestic and restic.

## Example 

The data to be backed up is a root server including its website. The website has an image directory of 40 GB, which contains two subdirectories of about 30 GB. 

One repo is only used for code files, one repo for the image directory `/images` and one repo for each of the two subdirectories `/images/event` and `/images/flyer`.

```
Repo  : Directory
-----------------
code  : - html
code  :   - css
images:   - images
images:     - data
images:     - div
flyer :     - flyer
photos:     - event
images:     - website
code  :   - js
code  :   - tpl
```

It is written in `~/.config/crestic.cfg', the central configuration file of crestic. There the repos, the backup paths and exclude parameters are defined under their own name. Additionally there are global parameters, including the link to the password file, the --keep-* parameters and some more.

The backup is started like this:

`$ crestic code@cloud backup`

The snapshots can be displayed this way:

`$ crestic code@cloud snapshots`

## Scripts

To automate the whole thing as much as possible, there are three scripts:

 `cr_backup.sh`
  The backup script. It is suitable as a cronjob. The script writes a log in (changeable) `var/log/restic_backup.log` that records the duration per repo and the total duration. It also calls the following script:

 `cr_forget.sh`
This script executes a 'forget'. In principle like `cr_multi.sh forget`, but there is a weekly check whether `--prune' should be executed additionally.

`cr_multi.sh [command]`
 This script calls all repos and executes an "unlock". If a restic command is passed, it will be executed.
 Before the first backup, for example, all repos must be initialized. This can be done with `cr_multi.sh init`. Or if an overview of all snapshots is desired, `cr_multi.sh snapshots` is used.
 
To avoid having to enter the repos to be backed up in all three files, they can be stored centrally in the file
`./.config/restic/backups`. 


## Usage

If you want to use these scripts to backup a root server, you should install them in the /root directory.

Additionally the file `crestic.cfg` and the files in the directory `.config/restic/` should be adapted to your own needs.
