ActionView::Template.register_template_handler('rb', Minimal::Template::Handler)
Minimal::Template.send(:include, Minimal::Template::FormBuilderProxy)
