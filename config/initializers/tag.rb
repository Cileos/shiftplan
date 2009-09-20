ActionController::Dispatcher.to_prepare do
  Tag.class_eval do
    before_create :generate_color

    def color
      @color ||= begin
        color = read_attribute(:color)
        "##{color}" unless color.blank? || color.starts_with?('#')
      end
    end

    protected

      # FIXME we only need this for qualifications
      def generate_color
        step_width = 30
        hue = 15 + Tag.maximum('id').to_i * step_width # FIXME: adjust starting point for > 12 qualifications
        saturation = 0.75
        value = 1

        color = Color.rgb_to_hex(*Color.hsv_to_rgb(hue, saturation, value))
        write_attribute(:color, color)
      end
  end
end