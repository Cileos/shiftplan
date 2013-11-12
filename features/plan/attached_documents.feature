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
      Then I should see "Neues Dokument hochladen" within the modal box title
       And I attach the file "factories/attached_documents/howto.docx" to "Datei"
       And I press "Hochladen"
       And I wait for the modal box to disappear
      Then I should see flash notice "Dokument howto.docx erfolgreich hochgeladen"
      Then I should see a list of the following attached_documents:
        | Name       | Size   | Uploader          |
        | howto.docx | 3,6 KB | von Planner Burns |

  Scenario: Upload to plan, attach to milestone
     Given the situation of a nuclear reactor
       And a milestone exists with name: "Weltherrschaft", plan: the plan
       And I am on the page of the plan
      When I follow "Dokument hochladen"
       And I wait for the modal box to appear
       And I attach the file "factories/attached_documents/howto.docx" to "Datei"
       And I select "Weltherrschaft" from "Meilenstein"
       And I press "Hochladen"
       And I wait for the modal box to disappear
      Then I should see a list of the following attached_documents:
        | Name       | Size   | Milestone      | Uploader          |
        | howto.docx | 3,6 KB | Weltherrschaft | von Planner Burns |

  Scenario: Delete an attached document
     Given the situation of a nuclear reactor
       And an attached howto document exists with plan: the plan
       And I am on the page of the plan
       And I deactivate all confirm dialogs
      When I follow "Löschen" within the attached_documents list
      Then I should see flash notice "Dokument howto.docx gelöscht"
       And I should be somewhere under the page of the plan
       And I should not see "howto.docx" within the sidebar
