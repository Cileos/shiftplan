class Color
  class << self
    # taken with heavy refactorings and slight adjustments
    # from http://www.youngcoders.com/general-programming/29744-conversion-hsv-hsl-back.html
    # def hsl_to_rgb(h, s, l)
    #   return [l, l, l] if s == 0
    # 
    #   q = l < 0.5 ? l * (1 + s) : l + s - (l * s)
    #   p = 2 * l - q
    #   hk = h / 360.0 # normalized
    #   t = hk + 1 / 3.0, hk, hk - 1 / 3.0
    # 
    #   color = t.collect do |c|
    #     c += 1 if c < 0
    #     c -= 1 if c > 1
    # 
    #     if c < 1 / 6.0
    #       p + ((q - p) * 6 * c)
    #     elsif c < 1 / 2.0
    #       q
    #     elsif c < 2 / 3.0
    #       p + ((q - p) * 6 * (2 / 3.0 - c))
    #     else
    #       p
    #     end
    #   end
    # 
    #   color.map { |c| (c * 255).floor }
    # end

    # according to http://en.wikipedia.org/wiki/HSL_and_HSV#Conversion_from_HSV_to_RGB
    def hsv_to_rgb(h, s, v)
      h_i = (h / 60.0).floor % 6
      f = h / 60.0 - (h / 60.0).floor
      p = v * (1 - s)
      q = v * (1 - f * s)
      t = v * (1 - (1 - f) * s)

      case h_i
      when 0 then [v, t, p]
      when 1 then [q, v, p]
      when 2 then [p, v, t]
      when 3 then [p, q, v]
      when 4 then [t, p, v]
      else
        [v, p, q]
      end.map { |c| (c * 255).floor }
    end

    def rgb_to_hex(r, g, b)
      [r, g, b].map { |c| c.to_s(16) }.join
    end
  end
end