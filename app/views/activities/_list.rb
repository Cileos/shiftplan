module Activities
  class List < Minimal::Template
    def to_html
      ul :id => 'activities' do
        activities.each do |activity|
          render :partial => "activities/#{activity.activity_object_type.underscore}", :locals => { :activity => activity }
        end
      end unless activities.empty?
    end
  end
end