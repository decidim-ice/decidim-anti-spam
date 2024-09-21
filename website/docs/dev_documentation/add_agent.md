---
sidebar_position: 7
description: How to develop a new Agent
---
# Develop your own Agent
:::warning
We don't advise creating your own agent, as the current Lock agent is already a good compromise for spam control.
:::

To create a new agent, it's quite simple, almost like creating a detection:

* Use `CopCommand` to suffix your command.
* Add a `self.form` to define your cop settings (or `nil` if no settings are needed).
* Use these different attributes: 
    * `suspicious_user` - the user who has done something wrong.
    * `admin_reporter` - an admin user used only to report spam.
    * `reportable` - the resource that has been reported.
    * `errors` - an ActiveRecord error, to forbid saving (see [Working With Validation Errors in Rails Guides](https://guides.rubyonrails.org/active_record_validations.html#working-with-validation-errors)).


```ruby
class CustomCopCommand < Decidim::SpamSignal::Cops::CopHandler
    def self.form
        ::CustomSettingsForm
    end

    def call
        suspicious_user.lock_access! # or do whatever with the admin
    end
end
```

Settings follow the same logic, including i18n fields: 
* `decidim.spam_signal.cops.custom.name`
* `decidim.spam_signal.cops.custom.description`
* `decidim.spam_signal.forms.custom.custom_settings_form.foo_enabled`

To register it in an initializer:
```ruby
Decidim::SpamSignal::Cops::CopsRepository.instance.register(
    :custom, 
    ::CustomCopCommand
)
```

:::info
You will find the term `cop` in the code to refer to an agent.  
This is provocative on purpose: participation must be as inclusive as possible, and restricting participation is _BAD_.  <br />
You are warned—be your own cop.
:::