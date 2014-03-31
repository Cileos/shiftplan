class ReportDecorator < RecordDecorator

  def is_chunky?
    current_chunk_sizes.present?
  end

  def chunks
    current_chunk_sizes + ['all']
  end

  def chunky_link(chunk)
    h.link_to chunk, { report: report_params.merge(limit: chunk) }, class: active_or_not(chunk)
  end

    private

  def active_or_not(chunk)
    if current_chunk
      current_chunk == chunk.to_s ? 'active' : 'false'
    elsif chunk == first_chunk
      'active'
    else
      'false'
    end
  end

  def report_params
    h.params[:report] || {}
  end

  def first_chunk
    current_chunk_sizes.first
  end

  def current_chunk_sizes
    chunk_sizes.select { |n| n < total_number_of_records }
  end

  def current_chunk
    report_params.try(:[], :limit)
  end
end
