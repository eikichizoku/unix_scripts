# unix_scripts
Unix scripts to fix stuff, bulk edit, gain time

Those scripts were written for Facebook to support a project to migrate files to Sharepoint.

short.sh
As NTFS filesystems are set to unsupport basename file with more than 256 characters in the basename. short.sh is identifying them and tagging them using the tag features in Mac OS X. It also provides statistics infos on the basename files lenght.

illegal.sh
NTFS also hates those "illegals" characters: [?<>\\:*#|\%"]. illegal.sh gives the ability to removes all the characters we want from basenames, those characters inputted interactively by the user.

sleepwatcher.command
There is a bug related to Active Directory and Mac Os on the way Mac bind to it. The native opendirectoryd daemon loose connection with AD after each sleep/wake and the only solutions are to unbind/rebind - Activate the fast user switching in User account preferences or kill the opendirectoryd daemon, which will reinitiate the connection with AD. 
This Simple script install, set and creates files to get sleepwatcher killing opendirectoryd everytime the computer goes out of sleep

nomorespace.sh
Simple utility that help to find out what is the heaviest file (folder/file) in a the current user's home directory or under a folder unputted.
May more reliable way to quickly find why your computer is welling there's no space anymore in the local storage.
