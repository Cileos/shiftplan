class Hello
  include Cinch::Plugin

  match /\b(?:hello|hi|hallo|na)\b/, :use_prefix => false

  def execute(m)
    m.reply "Hello, #{m.user.nick}"
  end
end
