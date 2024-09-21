---
sidebar_position: 6
description: How to develop a new detection
---
# Develop your own Detection
A detection is made up of two classes: a Command class and a Form class (for settings).

For the `Command` class, here are some restrictions:

* You need to define a form for a `Decidim::Form` class, with an absolute `::<name>` namespace. **You will run into memory allocation issues if you don't.**
* You need to suffix your command with the `ScanCommand` name. This is a convention we use to avoid configuration overrides.
* The call must broadcast `:ok` or one of the `output_symbols` defined.

```ruby
class CustomScanCommand < Decidim::SpamSignal::Scans::ScanHandler
    def self.form
        ::CustomSettingsForm
    end
    def self.output_symbols
        [:foo]
    end
    def call
        return broadcast(:foo) if config["foo_enabled"]
        broadcast(:ok)
    end
end
```


For Settings:

* You need to include the module `Decidim::SpamSignal::SettingsForm` to make everything work.
* We have special naming rules for your attributes:
    * If it starts with `is_` or ends with `_enabled`, it will generate a checkbox.
    * If it ends with `_csv`, it will generate a textarea.
    * The rest follows Decidim's default form builder conventions.
```ruby

class CustomSettingsForm < Decidim::Form
    include Decidim::SpamSignal::SettingsForm
    attribute :foo_enabled, Boolean, default: false
    # You can add validation here ;)
end
```

Now, you can register your command in an initializer:
```ruby
Decidim::SpamSignal::Scans::ScansRepository.instance.register(:custom, ::CustomScanCommand)
```

And set the i18n fields: 

* `decidim.spam_signal.scans.custom.name`
* `decidim.spam_signal.scans.custom.description`
* `decidim.spam_signal.forms.custom.custom_settings_form.foo_enabled`
* And one key per output:
    * `decidim.spam_signal.scans.outputs.foo`
    * `decidim.spam_signal.scans.outputs.whatever_is_your_detection_output`