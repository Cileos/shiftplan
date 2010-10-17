# FasterCSV would try to convert tokens starting with a number to Floats which
# would raise a nasty warning, so we silence it
# FasterCSV::Converters[:silence] = lambda { |value| value }
# CSV::Converters[:silence] = lambda { |value| value }

class Account < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  has_many :employees
  has_many :workplaces
  has_many :qualifications
  has_many :plans

  has_many :activities

  validates_presence_of :name

  validates_presence_of   :subdomain
  validates_uniqueness_of :subdomain, :case_sensitive => false
  validates_format_of     :subdomain, :with => /^[A-Za-z0-9-]+$/

  # TODO:
  # return some kind of status for imported/not imported employees?
  # maybe even detailed information (like "Couldn't import the following lines: - 12: Email can't be blank.")
  def import_employees_from_file(file, options = {})
    options.reverse_merge!(:headers => true, :converters => :all, :col_sep => ';', :converters => :silence)

    FasterCSV.foreach(file.path, options) do |row|
#    CSV.foreach(file.path, options) do |row|
      attributes = row.to_hash

      if token = attributes.delete('token')
        # if token starts with a -, employee should be deleted
        delete, token = true, token[1..-1] if token.starts_with?('-')

        if employee = employees.find_by_token(token)
          delete ? employee.destroy : employee.update_attributes(attributes)
        else
          # skipped ... should probably do something here
        end
      else
        employees.create(attributes)
      end
    end
    1 # should probably return [number_inserted, number_in_file]
  end

  def admin=(user)
    user = user.is_a?(User) ? user : User.create!(user)
    user.confirm!

    memberships.build(
      :account => self,
      :user => user,
      :admin => true
    ) if new_record?
  end
end
