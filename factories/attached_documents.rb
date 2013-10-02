FactoryGirl.define do
  factory :attached_document do
    plan
    file { File.open Rails.root.join('factories/attached_documents/howto.docx') }
  end
end
