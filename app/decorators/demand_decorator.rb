class DemandDecorator < RecordDecorator
  def quantity_and_qualification
    if qualification
      "#{quantity} x #{qualification.name}"
    else
      "#{quantity} x"
    end
  end
end
