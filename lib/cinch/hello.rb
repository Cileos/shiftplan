class Hello
  include Cinch::Plugin

  Greeting = /\b(hello|hi|hallo|hallihallo|na|welcome|howdy|oi|greetings|fuck)\b/i

  match Greeting, :use_prefix => false

  def execute(m)
    if m.message =~ Greeting
      m.reply "#{$1} yourself, #{m.user.nick}"
    end
  end
end
