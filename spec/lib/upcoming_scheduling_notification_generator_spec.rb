require 'spec_helper'
require 'upcoming_scheduling_notification_generator'

describe UpcomingSchedulingNotificationGenerator do

  let(:current_date_string)  { '2012-12-12' }
  let(:current_time_string)  { "#{current_date_string} 14:30:00" }
  let(:current_date)         { Date.parse(current_date_string) }
  let(:current_time)         { Time.parse(current_time_string) }
  let(:bart)                 { create(:employee, first_name: 'Bart', user: create(:confirmed_user)) }

  before(:each) do
    Timecop.freeze(current_time)
  end

  context ".generate!" do

    let!(:scheduling_beginning_in_less_than_24_hours) do
      start = current_time + 23.hours + 59.minutes
      create(:scheduling, starts_at: start, ends_at: start + 8.hours, employee: bart)
    end

    let!(:scheduling_beginning_in_more_than_24_hours) do
      start = current_time + 24.hours + 1.minute
      create(:scheduling, starts_at: start, ends_at: start + 8.hours, employee: bart)
    end

    let!(:scheduling_beginning_in_the_past) do
      start = current_time - 1.minute
      create(:scheduling, starts_at: start, ends_at: start + 8.hours, employee: bart)
    end

    it "creates notifications for all schedulings beginning in the next 24 hours" do
      expect do
        described_class.generate!
      end.to change(Notification::UpcomingScheduling, :count).from(0).to(1)

      notification = Notification::UpcomingScheduling.first
      notification.notifiable.should == scheduling_beginning_in_less_than_24_hours
      notification.employee.should == bart
    end

    it "does not create another notification if the scheduling has not changed" do
      expect do
        described_class.generate!
        described_class.generate!
      end.to change(Notification::UpcomingScheduling, :count).from(0).to(1)
    end

    it "creates another notification if the scheduling has changed" do
      expect do
        described_class.generate!
        Timecop.freeze(current_time + 1.minute)
        scheduling_beginning_in_less_than_24_hours.touch(:updated_at)
        described_class.generate!
      end.to change(Notification::UpcomingScheduling, :count).from(0).to(2)
    end

    it "delivers an email for each notification exactly once" do
      Notification::UpcomingScheduling.any_instance.should_receive(:deliver!).once
      described_class.generate!
      described_class.generate!
    end

    shared_examples :a_generator_creating_no_upcoming_scheduling_notifications do
      it "does not create a notification" do
        expect do
          described_class.generate!
        end.to_not change(Notification::UpcomingScheduling, :count)
      end
    end

    context "when scheduling has no employee" do
      let!(:scheduling_beginning_in_less_than_24_hours) do
        super().tap do |s|
          s.employee = nil
          s.save!
        end
      end

      it_behaves_like :a_generator_creating_no_upcoming_scheduling_notifications
    end

    context "when scheduling has an employee without user" do
      let(:bart) { create(:employee, user: nil) }

      it_behaves_like :a_generator_creating_no_upcoming_scheduling_notifications
    end

    context "when scheduling has an employee with an unconfirmed user" do
      let(:bart) { create(:employee, user: create(:user)) }

      it_behaves_like :a_generator_creating_no_upcoming_scheduling_notifications
    end
  end
end
