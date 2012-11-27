# cannot load in lib/volksplaner, because the application is initialized yet (and neither is autoloading)
SimpleForm::FormBuilder.send :include, Volksplaner::FormButtons
