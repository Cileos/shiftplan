class Account < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  has_many :employees
  has_many :workplaces
  has_many :qualifications
  has_many :plans

  validates_presence_of :name

  # TODO: return some kind of status for imported/not imported employees?
  def import_employees_from_file(file, options = {})
    options.reverse_merge!(:headers => true)
    FasterCSV.foreach(file.path, options) { |row| employees.create(row.to_hash) }
    1 # should probably return [number_inserted, number_in_file]
  end

  def admin=(attributes)
    user = User.create!(attributes)
    user.confirm!

    memberships.build(
      :account => self,
      :user => user,
      :admin => true
    ) if new_record?
  end
end
