# How to make a release

1. Move all tickets in the "Merge" column in Kanbanery, that are ready(marked green), to
   the "Release" column. (Btw: The Release column should be empty before starting a new
   release.)

2. Make sure the develop and the master branches have green builds on the CI Server.

3. Update your local develop and master branches:

   $ git checkout master
   $ git pull --rebase
   $ git checkout develop
   $ git pull --rebase

4. Check if the rake db:seed task successfully runs locally. (We need the task after
   deploying to staging.

5. Fetch all tags that have been created so far:

   $ git fetch --tags


6. List all tags:

   $ git tag


7. Create a new release with an incremented version number. Increment the highest tag
   number you get from 'git tag'(see 5.) after you have updated the tags by
   'git fetch --tags'(see 4.). Compare this version number with the current version in the
    CHANGELOG and VERSION files.

   $ git flow release start <new-version-nummer>
   e.g.
   $ git flow release start 1.0.5


8. Bump the version in the VERSION file:
   e.g. replace 1.0.4 with 1.0.5

9. Update the CHANGELOG file with important changes (Pull requests, Merges, Hotfixes) To
   easily get a list of all Merges/Pull requests/Hotfixes from the current master until
   the current develop branch execute:

   $ git log --oneline master..develop | grep Merge | grep -v -e "Merge branch '\(develop\|master\)' of github"

   Then update the CHANGELOG file in the following format by copy pasting the output you
   got from git log(see above):

   Release 0.1.0 2013-10-16 20:19
   ------------------------------
   * 13feaa5 Merge pull request #47 from Siewert-Kau/feature/copy-text-changes-kw21
   * 3e987f0 Merge pull request #46 from Siewert-Kau/feature/search-by-manufacturers
   * 302bf95 Merge branch 'feature/copy-text-changes-kw21' of github.com:Siewert-Kau/b2c into feature/copy-text-changes-kw21
   * f747a71 Merge branch 'hotfix/export-company-to-navision' into develop
   * 1b6aa06 Merge pull request #45 from Siewert-Kau/feature/staging-config
   * 8f7918d Merge pull request #44 from Siewert-Kau/feature/timestamp_in_logs
   * 587f7af Merge branch 'hotfix/no_cleanup_for_cart_with_finished_order' into develop
   * c305c05 Merge pull request #40 from Siewert-Kau/feature/schedule-backup
   * ba4f466 Merge pull request #39 from Siewert-Kau/feature/cnet-manufacturers-overhaul
   * d22f6ba Merge pull request #41 from Siewert-Kau/feature/ssl-everywhere
   * 9743ad4 Merge branch 'hotfix/fix-fact-finder-export' into develop


10. Commit all local changes(at least VERSION and CHANGELOG should have changes).

11. Finish your release with:

    $ git flow release finish <new-version-number>

    e.g.

    $ git flow release finish 1.0.5

    If you have merge conflicts, resolve them and then issue:

    $ git commit

    Then issue git flow command again:

    $ git flow release finish <new-version-number>

    Enter a tag message. This should be the "Best Of" the changelog, e.g., the most
    important change.  E.g. enter: Search products by cnet manufacturers

    If everything went fine, your should see an output like the following in your terminal:

    Summary of actions:
    - Latest objects have been fetched from 'origin'
    - Release branch has been merged into 'master'
    - The release was tagged '1.0.13'
    - Release branch has been back-merged into 'develop'
    - Release branch 'release/1.0.13' has been deleted


12. You should be on the develop branch then. Push both the master and develop branches:

    $ git push

    Make sure that both branches have been pushed.

13. Review the Notes for the next deployment. These are located in
    "doc/NEXT_RELEASE.markdown". It's fine if the document is empty, just check if there
    is anything special to be done before/during/after the actual deployment. A typical next
    release note is that certain yaml files need to be changed on the servers before
    deploying. The file doc/NEXT_RELEASE.markdown should be emptied immediately after
    a successful release in the develop branch. (see 18.)

14. Before deploy check the diff if any gitignored .yml files have been changed. If yes,
    amend relevant files on staging and production to reflect the new structure.
    It is also a good idea to briefly take a look at each Kanbanery ticket that is to be
    released and check comments for important information.

15. Wait for the master branch build on the CI Server to finish. If it is green, deploy
    the master to staging with:

    $ cap staging deploy:migrations BRANCH=master

    Then seed the staging database with:

    $ cap staging deploy:seed

    Check if everything went fine on staging and briefly take a look at each feature just
    released and deployed.

16. If the deployment to staging was successful, deploy the master to production with:

    $ cap production deploy:migrations

17. After the deployment, check all release tickets in the Kanbanery "Release" column to
    mark them as ready/deployed.

18. Check if everything went fine on production and briefly take a look at each feature
    just released and deployed. If a ticket looks fine on production, move it to the
    Kanbanery "Done" column.

18. Tags have to be pushed explicitely with git, otherwise the other developers won't see
    them when executing 'git tag'. Push tags with:

    $ git push --tags

19. If the doc/NEXT_RELEASE.markdown included some TODOs/notes for the last release,
    please empty this file now on the develop branch.
