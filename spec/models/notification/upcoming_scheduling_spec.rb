describe Notification::UpcomingScheduling do

  let(:scheduling) do
    build(:scheduling, employee: build(:employee, user: build(:user)))
  end
  let(:subject) do
    described_class.new(notifiable: scheduling, employee: scheduling.employee)
  end

  it_behaves_like :updating_new_notifications_count_for_user do
    let(:notifiable) { scheduling }
  end

  context "destroyed with its scheduling" do
    let(:scheduling)    { create(:scheduling, employee: employee) }
    let(:employee)      { create(:employee, user: create(:user)) }
    let!(:notification)  { described_class.create(notifiable: scheduling, employee: employee) }

    it 'is destroyed with its post' do
      expect do
        scheduling.destroy
      end.to change { Notification::UpcomingScheduling.count }.from(1).to(0)
    end
  end
end
