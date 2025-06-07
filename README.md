This is a file which is designed to be used with a already set up rclone remote.

point this script at the remote by seeting the setting RCLONE_REMOTE in the beginning of the script to the name of the remote and let it run.

designed to be called once in a while and left alone apart for that 

the universal_syncer script is a script that does the same thing, except i want it to support more than just rclone mountable things, for example git and SVN repos, maybe even scraping simple websites(in a reasonable manner) and whatnot. i plan to also add the functionality to it to keep a full edit history for every run via hardlinks, but thats not done yet



