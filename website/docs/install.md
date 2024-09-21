---
sidebar_position: 2
slug: /install
title: Installation
description: How to install the module
---

### Support Table
| Decidim Version | Supported?  |
|-----------------|-------------|
| 0.24            | no          |
| 0.26            | yes         |
| 0.27            | yes         |
| 0.28            | coming soon |
| 0.29            | coming soon |

# Install the anti-spam

**Add the gem to your Gemfile**<br />
```ruby
gem "decidim-spam_signal", "~> 0.3.3"
```

**Install the module**<br />
```ruby
bundle install
```

**Copy migrations files**<br />
```ruby
bundle exec rails decidim_spam_signal_admin:install:migrations
```

**Migrate**<br />
```ruby
bundle exec rails db:migrate
```
(you can make sure migrations pass with bundle exec rails db:migrate:status)

**Set an email accountable to manage spam moderation**<br />
```bash
# Save it as environment variables
export ANTISPAM_ADMIN=myemail@example.org
```
