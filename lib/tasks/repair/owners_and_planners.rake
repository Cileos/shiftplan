require 'repair_stats'

namespace :repair do
  namespace :owners_and_planners do

    def log(message)
      STDERR.puts "  #{message}"
      Rails.logger.info message
    end

    desc <<-EODESC
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

    EODESC


    task :run, [:really] => :environment do |t,args|
      args.with_defaults(:really => false)
      stats = RepairStats.new do |s|

        s.dim 'Old data model: number of owners' do
          Employee.where(role: 'owner').count
        end
        s.dim 'New data model: number of owners' do
          Account.joins(:owner).count
        end

        s.dim 'Old data model: number of planners for orgs' do
          planners = Employee.where(role: 'planner')
          planners.map {|p| p.account.organizations.count }.inject(0) do |sum, n|
            sum + n
          end
        end
        s.dim 'New data model: number of planners for orgs' do
          Membership.where(role: 'planner').count
        end
      end

      stats.run(args[:really]) do
        employees = Employee.all

        employees.each do |employee|
          if employee.role == 'owner'
            account = employee.account
            account.owner_id = employee.id
            account.save!
          elsif employee.role == 'planner'
            account = employee.account
            account.organizations.each do |organization|
              membership = employee.memberships.find_by_organization_id(organization.id)
              if membership
                membership.role = 'planner'
                membership.save!
              else
                employee.memberships.create!(organization: organization, role: 'planner')
              end
            end
          end

          employee.role = nil
          employee.save!
        end

        log "fixed #{employees.size} employee(s)"
      end
    end
  end
end
