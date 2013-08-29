require 'spec_helper'
require 'upcoming_scheduling_notification_generator'

describe UpcomingSchedulingNotificationGenerator do

  let(:current_date_string)  { '2012-12-12' }
  let(:current_time_string)  { "#{current_date_string} 14:30:00" }
  let(:current_date)         { Date.parse(current_date_string) }
  let(:current_time)         { Time.parse(current_time_string) }
  let(:bart)                 { create(:employee, first_name: 'Bart') }

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

    it "delivers an email for each notification via delayed job" do
      expect do
        described_class.generate!
      end.to change(Delayed::Job, :count).from(0).to(1)

      payload_object = Delayed::Job.first.payload_object
      payload_object.object.should == Notification::UpcomingScheduling.last
      payload_object.method_name.should == :deliver_without_delay!
    end

    it "only delivers the email once" do
      expect do
        described_class.generate!
        described_class.generate!
      end.to change(Delayed::Job, :count).from(0).to(1)
    end
  end
end
