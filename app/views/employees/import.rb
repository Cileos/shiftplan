module Employees
  class Import < Minimal::Template
    def to_html
      form_tag(upload_employees_path, :multipart => true) do
        label_tag('file', t(:file))
        file_field_tag('file')
        submit_tag(t(:upload))
      end
    end
  end
end