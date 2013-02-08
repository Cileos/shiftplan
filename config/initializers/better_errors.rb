ed = case ENV['USER']
  when 'rwrede' then :macvim
  when 'tatze' then :sublime
  # when 'niklas' then :frøbel_yourself_a_linux_vim
  else 'false'
end

if ed
  BetterErrors.editor = ed if defined? BetterErrors
end
