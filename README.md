# unix_scripts
Unix scripts to fix stuff, bulk edit, gain time

Those scripts were written for Facebook to support a project to migrate files to Sharepoint.

As NTFS filesystems are set to unsupport basename file with more than 256 characters in the basename. short.sh is identifying them and tagging them using the tag features in Mac OS X. It also provides statistics infos on the basename files lenght.

NTFS also hates those "illegals" characters: [?<>\\:*#|\%"]. illegal.sh gives the ability to removes all the characters we want from basenames, those characters inputted interactively by the user.


