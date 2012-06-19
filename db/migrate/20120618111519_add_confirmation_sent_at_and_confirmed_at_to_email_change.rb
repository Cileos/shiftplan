class AddConfirmationSentAtAndConfirmedAtToEmailChange < ActiveRecord::Migration
  def change
    add_column :email_changes, :confirmation_sent_at, :datetime
    add_column :email_changes, :confirmed_at, :datetime
  end
end
