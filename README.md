<h1 align="center"><img src="https://github.com/octree-gva/meta/blob/main/decidim/static/header.png?raw=true" alt="Decidim - Octree Participatory democracy on a robust and open source solution" /></h1>
<h4 align="center">
    <a href="https://git.octree.ch/decidim/vocacity/decidim-modules/decidim-module-spam_signal/issues">Issues</a>  |
    <a href="https://decidim-ice.github.io/decidim-anti-spam/">Documentation</a>  <br/><br />
    <a href="https://crowdin.com/project/decidim-spam-module"><img src="https://badges.crowdin.net/decidim-spam-module/localized.svg" /></a><br /><br />
    <a href="https://www.octree.ch">Octree</a> |
    <a href="https://octree.ch/en/contact-us/">Contact Us</a><br/><br/>
    <a href="https://decidim.org">Decidim</a> |
    <a href="https://docs.decidim.org/en/">Decidim Docs</a> |
    <a href="https://meta.decidim.org">Participatory Governance (meta Decidim)</a><br/><br/>
    <a href="https://matrix.to/#/+decidim:matrix.org">Decidim Community (Matrix+Element.io)</a><br /><br />
</h4><br />

# Anti-spam For Decidim
This module integrates a new administration tab to manage and configure a Decidim anti-spam. 

**Avoid Spammy Comment Creation**  
This module will prevent spam or commercial content before a comment is even saved.

**Mass-reporting**  
This module can automatically report users and send reports to a single email (and not all the admins).

**Detect Bad User Profiles**  
With this module, you will be able to detect URLs of strange domains and commercial content in the profile description (about section). This allows stopping spammers earlier.

To know more about features and configurations, visit the [decidim-anti-spam documentation website](https://decidim-ice.github.io/decidim-anti-spam/).

---

The philosophy of this module is to adapt rules to each situation, and it has been greatly influenced by [the Pol.is moderation good practices guide](https://compdemocracy.org/Moderation/).

## Documentation
You can consult our documentation on the [decidim-anti-spam documentation website](https://decidim-ice.github.io/decidim-anti-spam/).

## Contributions
This module is maintained by [Octree](https://octree.ch). We plan work and releases on our self-hosted GitLab.

**New ideas**  
New ideas are welcome on our [feedback page](https://feedback.voca.city/?tags=decidim-anti-spam). We manage co-financing and release planning there.
For technical aspects (contributions, code, issues), take a look at our [GitLab](https://git.octree.ch/decidim/vocacity/decidim-modules/decidim-module-spam_signal).

## Development and checks (Docker)

Who reads this: gem contributors running checks before a merge request.

### GitLab CI locally (`docker-compose.ci.yml`)

Same images and commands as `.gitlab-ci.yml` (`ruby:3.4.7`, `node:20`, `postgres:17`, `redis`). From the repository root:

```bash
docker compose -f docker-compose.ci.yml run --rm --no-deps rubocop
docker compose -f docker-compose.ci.yml run --rm --no-deps erblint
docker compose -f docker-compose.ci.yml run --rm --no-deps prettier
docker compose -f docker-compose.ci.yml run --rm rspec
```

Crowdin / gem publish jobs need secrets and stay GitLab-only.

### Interactive development (`docker-compose.yml`)

Toolchain versions match the **`spam_signal`** Compose image (`octree/decidim-dev`), not your laptop. **Do not run** `rubocop`, `erblint`, `rspec`, `prettier`, or `rake test_app` on the host unless you maintain a separate, documented setup.

```bash
docker compose up -d
docker compose exec spam_signal bash -lc 'cd /home/module && bundle install'
```

Generate the dummy app once (set `DISABLED_DOCKER_COMPOSE=true` so the Rake task does not restart Compose), then create the test database and run specs (unset `DATABASE_URL` so the dummy app’s `config/database.yml` is used):

```bash
docker compose exec spam_signal bash -lc 'cd /home/module && export DISABLED_DOCKER_COMPOSE=true && bundle exec rake test_app'
docker compose exec spam_signal bash -lc 'cd /home/module/spec/decidim_dummy_app && unset DATABASE_URL && export DISABLE_SPRING=1 && RAILS_ENV=test bundle exec rails db:create db:migrate'
docker compose exec spam_signal bash -lc 'cd /home/module && unset DATABASE_URL && export RAILS_ENV=test && bundle exec rspec spec/models spec/lib spec/commands spec/i18n_spec.rb'
```

## License
This engine is distributed under the [GNU AFFERO GENERAL PUBLIC LICENSE](LICENSE.md).

<br /><br />

<h3>With the support of</h3>
<p>
        <img
            src="https://git.octree.ch/decidim/vocacity/decidim-modules/decidim-module-spam_signal/-/raw/main/website/static/decidim_anti_spam_supports.png?raw=true"
            alt="City of Lausanne and State of Geneva" />
</p>
