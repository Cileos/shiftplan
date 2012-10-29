Then /^no modal box should be open$/ do
  page.should have_no_css( selector_for('the modal box') )
end
