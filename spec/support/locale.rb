# When you tests depend on the current locale.
#
#     describe "german error messages" do
#       in_locale :de
#       it "should sound like stachenblocken"
#     end
#
module RSpecLocale
  def in_locale(wanted)
    old = nil
    before :each do
      old = I18n.locale
      I18n.locale = wanted
    end

    after :each do
      I18n.locale = old
    end
  end
end
