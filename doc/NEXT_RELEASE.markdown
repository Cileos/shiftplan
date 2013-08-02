Planners and owners must be repaired because the data model has changed.
In order to do this the following rake task needs to be run:

$ bundle exec rake repair:owners_and_planners:run RAILS_ENV=<env>

Further reading:

      Owners:
      -------
      Formerly, employees were owners (account wide) if they had the role
      'owner'.

      In the new data model, employees are owners (account wide) if the
      account's owner is the employee (accounts.owner_id == employee.id)

      Planners:
      ---------
      Formally, employees where planners (account wide) if they had the role
      'planner'.

      In the new data model, employees are only planners organization wide. This
      is why a role column was added to the memberships.
      Therefore, an employee is a planner for an organization, if his/her
      membership for this organization has the role 'planner'.


      What needs to be done to migrate to new data model:

      1) Make every employee with a role 'owner' to the account's owner by
      by setting the foreign key.
      2.) Make every employee with a role 'planner' planner in every
      organization of his account by updating or creating a membership with
      the role 'planner'.
      3) Set the role of all employees to nil (column can be removed from the
      employee later).


      Sanity checks:
      --------------
      Output of the stat 'Old data model: number of owners'
      should equal
      output of the stat 'New data model: number of owners'

      and

      Output of the stat 'Old data model: number of planners for orgs'
      should equal
      output of the stat 'New data model: number of planners for orgs'

      after the task has been run.


      Running a dry run first is recommended:

        For a dry run, please issue:

        $ bundle exec rake repair:owners_and_planners:run RAILS_ENV=<env>
        and this will roll back the changes and give you the statistics

        To really persist the changes, please issue:

        $ bundle exec rake repair:owners_and_planners:run[true] RAILS_ENV=<env>

