class Color
  class << self
    # taken with heavy refactorings and slight adjustments
    # from http://www.youngcoders.com/general-programming/29744-conversion-hsv-hsl-back.html
    def hsl_to_rgb(h, s, l)
      return [l, l, l] if s == 0

      q = l < 0.5 ? l * (1 + s) : l + s - (l * s)
      p = 2 * l - q
      hk = h / 360 # normalized
      t = hk + 1 / 3.0, hk, hk - 1 / 3.0

      color = t.collect do |c|
        c += 1 if c < 0
        c -= 1 if c > 1

        if c < 1 / 6.0
          p + ((q - p) * 6 * c)
        elsif c < 1 / 2.0 && c >= 1 / 6.0
          q
        elsif c < 2 / 3.0 && c >= 1 / 2.0
          p + ((q - p) * 6 * (2 / 3.0 - c))
        else
          p
        end
      end

      color.map { |c| (c * 255).round.to_s(16) }
    end
  end
end