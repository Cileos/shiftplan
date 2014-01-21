class Volksplaner::Undo::Step

  # give transactions like
  #    create: [record1, record2]
  def self.build(*a)
    new.tap do |undo|
      undo.add(*a)
    end
  end

  attr_reader :created_records
  attr_reader :flash
  attr_reader :location

  def initialize
    @created_records = {}
  end

  def add(tracts={})
    tracts.each do |action, things|
      case action
      when :create
        things.flatten.each { |m| create_record m }
      when :flash
        @flash = things[:notice]
      when :flash_message
        @flash_message = things unless things.blank? # I18n may return nil
      when :redirect
        @location = things
      end
    end
  end

  def flash_message
    @flash_message || I18n.translate('flash', scope: i18n_scope, what: flash)
  end

  def human_title
    I18n.translate 'title', scope: i18n_scope, what: flash
  end

  def redirectable?
    @location.present?
  end

  def execute!
    @created_records.each do |klass_name, ids|
      ids.each do |id|
        if record = load_record(klass_name, id)
          record.destroy
        end
      end
    end
  end

  private

  def create_record(record)
    @created_records[record.class.model_name.to_s] ||= []
    @created_records[record.class.model_name.to_s] << record.id
  end

  def load_record(klass_name, id)
    klass_name.constantize.where(id: id).first
  end

  def i18n_scope
    'volksplaner.undo'
  end

end
