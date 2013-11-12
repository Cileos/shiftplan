class AttachedDocumentDecorator < RecordDecorator
  def selector_for(name, *a)
    case name
    when :attached_documents_list
      '#attached-documents ul'
    else
      super
    end
  end

  def update_list(items)
    select(:attached_documents_list).refresh_html list_items(items)
  end

  def list_items(items)
    if items.empty?
      ''
    else
      h.render partial: 'attached_documents/item', collection: items
    end
  end

end
