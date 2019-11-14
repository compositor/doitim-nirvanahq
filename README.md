# doitim-nirvanahq

This tool facilitates migration from doit.im to Nirvana HQ.

Nirvana HQ API is reverse engineered here https://github.com/mikesimons/nibbana/wiki/NirvanaHQ-API

I created these scripts for own migration, make sure to understand limitations. This tool might be not good enough for your data.
I use doit.im's uuid for migrated tasks, contexts, and projects. This makes calls idempotent.
Nirvana reports failures in response body, not even in HTTP code, so the script is blind to them. Make sure to glance through results.
I advise to create a temporary Nirvana account and migrate tasks into there. If that works, only then use your main Nirvana account.

# How to use
* Have `curl`, `jq`, `bash`. I used this script on Mac
* In a browser, navigate to doit.im, login, and extract `Cookie` key-value pair `autologin=<some-guid>` (example: `autologin=835a6dea-babb-4201-863e-dcb10abc6715`). Put `autologin=<some-guid>` into .env file
* Navigate to nirvana and find `authtoken` is a query parameter in any request to the API. Add it to .env

Your env file will look like:

```
autologin=d0705505-9019-43e0-b3d9-bd74b0366997
authtoken=d576a54a714843abb100cc5dfd31af37d576a54a714843abb100cc5dfd31af37
```
* Run main.sh in console.

# limitations

Only active (and someday) tasks are migrated, only active projects (I don't have others, so don't know how it treats inactive projects)
I only migrate titles, notes, contexts (become tags), start/due dates.

The biggest pain is recurring tasks. Note they require Nirvana paid account. By far I have birthday reminders so I blindly convert all repeating tasks as yearly, to reoccur on the start date every year and the start date to be the nearest date in the future with the same day and month as original Doit.im start day. Future is measured as of 13 Nov 2019 (hardcoded, easy to upgrade). That is, if I had a doit.im recurring task on March 7, 2018, it becomes recurring from March 7, 2020 (otherwise Nirvana would treat it as overdue). Recurring tasks get special "bday" tag (which you will need to create once) and do not respect context. These limitations all can be addressed but does not make much sense for one time effort.

Another biggest limitation is context. Doit.im refers a context by its uuid, and Nirvana needs the value. Therefore `tasks.jq` has a hardcoded mapping:
```
if .context == "e1c06a00-4081-11e4-8894-51e3df408535"  then "Home" else
if .context == "e1c2b3f0-4081-11e4-8894-51e3df408535"  then "Computer" else
if .context == "e1c37740-4081-11e4-8894-51e3df408535"  then "Phone" else
if .context == "e1c43a90-4081-11e4-8894-51e3df408535"  then "Errands" else
```
You need to provide your own mapping here (and balance `end` tokens).
Easiest thing is to run migration against a temporary Nirvana account and spot `data/contexts.json` file. It will contain the mapping pretty much.
Again, it could be automated but does not worse the effort.

# Contributions
Contributions are welcome
