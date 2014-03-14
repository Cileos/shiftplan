# encoding: utf-8
class ReportFilter < RecordFilter

  def records
    fetch_records
  end

    private

  def fetch_records
    base.schedulings
  end
end
