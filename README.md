<h1 align="center">
    <img
        src="https://github.com/octree-gva/meta/blob/main/decidim/static/header.png?raw=true"
        alt="Decidim - Octree Participatory democracy on a robust and open source solution" />
</h1>
<h4 align="center">
    <a href="https://www.octree.ch">Octree</a> |
    <a href="https://octree.ch/en/contact-us/">Contact Us</a> |
    <a href="https://blog.octree.ch">Our Blog (FR)</a><br/><br/>
    <a href="https://decidim.org">Decidim</a> |
    <a href="https://docs.decidim.org/en/">Decidim Docs</a> |
    <a href="https://meta.decidim.org">Participatory Governance (META DECIDIM)</a><br/><br/>
    <a href="https://matrix.to/#/+decidim:matrix.org">Decidim Community (Matrix+Element.io)</a>
</h4>
<p align="center">
    <a href="https://participer.lausanne.ch">
        <img
            src="https://github.com/octree-gva/meta/blob/main/decidim/static/participer_lausanne/chip.png?raw=true"
            alt="Lausanne Participe — Une plateforme de participation pour imaginer et réaliser ensemble" />
    </a>
    <a href="https://participer.ge.ch">
        <img
            src="https://github.com/octree-gva/meta/blob/main/decidim/static/participerge/chip.png?raw=true"
            alt="Participer Genève — The public platform for citizen participation in Geneva and it's region" />
    </a>
    <a href="https://opencollective.com/voca">
        <img
            src="https://github.com/octree-gva/meta/blob/main/decidim/static/opencollective_chip.png?raw=true"
            alt="Voca – Open-Source SaaS platform for Decidim" />
    </a>
</p>
<br /><br />

# Anti-Spam for decidim

Flexible detection and reaction on spam for Decidim, sponsored by:

* [Participer Lausanne](https://participer.lausanne.ch)
* [Genève Participe](https://participer.ge.ch)

## Available Detection
This anti-spam gem comes with three core detection for spam: 

* Allowed TLDs: A list of all extensions (like `.com`) that are allowed. If an extension not present in the list is detected, a `Not Allowed Tlds Found` is raised
* Forbidden TLDs: A list of all extensions (like `.finance`) that are forbidden. If an extension not present in the list is detected, a `Forbidden Tlds Found` is raised
* Words: A dictionnary of forbidden word. If a forbidden word is found, a `Word Found` is raised.

## Rules
A rule is a link between the detection and what you do with the user (the agent).
We work on two sets of rules: SPAM and SUSPICIOUS. You can this way define two kinds of actions and have a more fine-grained spam policy.  For example, you could: 

* When a `.xxx` domain is found, Lock the user
* When a domain that is not `.com, .ch, .eu, .io`, Signalize the user to the admins.

## Agent
An agent is activated by a rule with a detected content. We have for now two agent: 

1. Lock: Use the `Devise::Lockable` strategy to lock the user, and send unlock instructions by email
2. Sinalize: Do nothing, but sinalize the user to the admins

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-spam_signal', '~> 0.3.1'
```
or 

```ruby
gem install decidim-spam_signal
```

Then execute:

```bash
bundle
bundle exec rails decidim_spam_signal:install:migrations
bundle exec rails db:migrate
```

## Local development
For decidim version 0.27, use Gemfile.0.27. For version 0.26, use Gemfile.0.26
```
cp Gemfile.0.27 Gemfile
``` 

First, you need to run an empty database with a decidim dev container which runs nothing.
```
docker-compose down -v --remove-orphans
docker-compose up -d
```

Once created, you access the decidim container
```
# Get the id of the decidim dev container
docker ps --format {{.ID}} --filter=label=org.label-schema.name=decidim
# 841ae977c7da
docker exec -it 841ae977c7da bash
```
You are now in bash, run manually. This will check your environment and do migrations if needed
```
bundle exec rake decidim_spam_signal_admin:install:migrations
docker-entrypoint
```

You are now ready to use your container in the way you want for development:

* Run a rails seed: `bundle exec rails db:seed`
* Have live-reload on your assets: `bin/webpack-dev-server`
* Execute tasks, like `bundle exec rails g migration AddSomeColumn`
* Run the rails server: `bundle exec rails s -b 0.0.0.0`
* etc.

To stop everything, uses:
- `docker-compose down` to stop the containers
- `docker-compose down -v` to stop the containers and remove all previously saved data.

### Debugging
To debug something on the container:
1. Ensure `decidim-app` is running
```bash
docker ps --all
#   CONTAINER ID   IMAGE                           COMMAND                  CREATED        STATUS        PORTS                                            NAMES
#   841ae977c7da   decidim-module-spam_signal-decidim-app   "sleep infinity"   32 minutes ago   Up 29 minutes   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp, 0.0.0.0:3035->3035/tcp, :::3035->3035/tcp   decidim-spam_signal-app <-------- THIS ONE
#   b56adf6404d8   decidim-geo-development-app     "bin/webpack-dev-ser…"   54 seconds ago   Up 46 seconds   0.0.0.0:3035->3035/tcp   decidim-webpacker                                       decidim-installer
#   bc1e912c3d8a   postgis/postgis:14-3.3-alpine   "docker-entrypoint.s…"   13 hours ago   Up 13 hours   0.0.0.0:5432->5432/tcp                           decidim-module-geo-pg-1
```

2. In another terminal, run `docker exec -it 841ae977c7da bash`
3. Run
    - `tail -f $ROOT/log/development.log` to **access logs**
    - `bundle exec rails restart` to **restart rails server AND keeps webpacker running**
    - `cd $ROOT` to access the `development_app`
    - `cd $ROOT/../decidim_module_geo` to access the module directory

## Environment Variable

```bash
export USER_BOT_EMAIL='bot@example.org' # user-bot used for signaling the spammers
```

## Scripting
We don't have UI for this (and probably won't), so here some useful script: 

Who is locked for more than a month and didn't unlock their account (CSV)?
```ruby
require "csv"
headers=["id", "nickname", "email", "vérouillé le"]
CSV.open("locked-users.csv", "w") do |csv|
  csv << headers
  Decidim::User.where("locked_at < ?", 31.days.ago).pluck(:id, :nickname, :email, :locked_at).each {|usr| csv << usr }
end
```


Apply your spam strategy to existing data?
```ruby
Decidim::User.all.each {|user| user.valid? }
Decidim::Comments::Comment.all.each {|comment| comment.valid? }
```

## Contributing
You are welcome to fill issues in this repo, and help if you have time. 


# Add your own detection 
An agent have two classes: A command class, and a form class (for settings). 

For `Command`, here some restrictions:

* You need to define a form to a `Decidim::Form` class, with absolute `::<name>` namespace. You will have trouble with memory allocation if you don't
* You need to suffix your command with `ScanCommand` name. That's a convention we use to avoid configurations.
* call must broadcast :ok or one of the `output_symbols` defined 

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

* You need to include the module `Decidim::SpamSignal::SettingsForm` to make the whole thing work
* We have special naming rules on how you name your attributes:
    * if its start with `is_` or end with `_enabled`, you will have a checkbox
    * if its ends with `_csv` you will have a textarea
    * the rest is like default decidim's form builder.

```ruby
class CustomSettingsForm < Decidim::Form
    include Decidim::SpamSignal::SettingsForm
    attribute :foo_enabled, Boolean, default: false
    # You can add validation here ;)
end
```

And now, you can register your command in an initializer: 
```ruby
Decidim::SpamSignal::Scans::ScansRepository.instance.register(:custom, ::CustomScanCommand)
```

And set the i18n fields: 
* `decidim.spam_signal.scans.custom.name`
* `decidim.spam_signal.scans.custom.description`
* `decidim.spam_signal.forms.custom.custom_settings_form.foo_enabled`


# Add your own agent
We won't advise you create your own agent, as it seems the Lock agent as the strongest agent is already a good compromise for spam control. If you really want it, that's simple, it's almost like detection:

* Use `CopCommand` to suffix your command
* Add a `self.form` to your settings (it can returns `nil`)
* Use these different attributes: 
    * `suspicious_user` the user that have done something wrong
    * `admin_reporter` an admin user only used to report spam
    * `errors` an ActiveRecord error, to forbid saving (@see [Working With Validation Errors in Rails Guides](https://guides.rubyonrails.org/active_record_validations.html#working-with-validation-errors))

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

Settings are exactly the same logic, and i18n fields: 
* `decidim.spam_signal.cops.custom.name`
* `decidim.spam_signal.cops.custom.description`
* `decidim.spam_signal.forms.custom.custom_settings_form.foo_enabled`

To register it in an initializer:
```ruby
Decidim::SpamSignal::Cops::CopsRepository.instance.register(:custom, ::CustomCopCommand)
```


**N.B** You will find in the code the term `cop` to refer an agent. 
This is provocative on purpose: participation must be as inclusive as possible, restricting participation is _BAD_. You are warned, be your own cop.


## License

This engine is distributed under the [GNU AFFERO GENERAL PUBLIC LICENSE](LICENSE.md).

<br /><br />

<p align="center">
    <img
        src="https://github.com/octree-gva/meta/blob/main/decidim/static/spam-signal/spam-signal-1.png?raw=true"
        alt="Anti Spam for Decidim, screenshot" />
</p>
<p align="center">
    <img
        src="https://github.com/octree-gva/meta/blob/main/decidim/static/spam-signal/spam-signal-2.png?raw=true"
        alt="Anti Spam for Decidim, screenshot" />
</p>

<br /><br />

<p align="center">
    <img src="https://raw.githubusercontent.com/octree-gva/meta/main/decidim/static/octree_and_decidim.png" height="90" alt="Decidim Installation by Octree" />
</p>
