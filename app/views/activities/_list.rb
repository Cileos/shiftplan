class Activities::List < Minimal::Template
  def content
    ul :id => 'activities' do
      activities.each do |activity|
        render :partial => "activities/#{activity.object_type.underscore}", :locals => { :activity => activity }
      end
    end unless activities.empty?
  end
end