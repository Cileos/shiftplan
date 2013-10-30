@javascript
Feature: Attached documents
  In order to give my employees additional instruction and guidance
  As a planer
  I want to upload files of several types and attach it to a Plan, and to an optional Milestone

  Scenario: Upload to plan, do not attach to milestone
     Given the situation of a nuclear reactor
       And I am on the page of the plan
      When I follow "Dokument hochladen"
       And I wait for the modal box to appear
       And I attach the file "factories/attached_documents/howto.docx" to "Datei"
       And I press "Hochladen"
       And I wait for the modal box to disappear
      Then I should see a list of the following attached_documents:
        | Name       | Size   |
        | howto.docx | 3,6 KB |
