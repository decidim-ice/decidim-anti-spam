<h1 align="center"><img src="https://github.com/octree-gva/meta/blob/main/decidim/static/header.png?raw=true" alt="Decidim - Octree Participatory democracy on a robust and open source solution" /></h1>
<h4 align="center">
    <a href="https://www.octree.ch">Octree</a> |
    <a href="https://octree.ch/en/contact-us/">Contact Us</a> |
    <a href="https://blog.octree.ch">Our Blog (FR)</a><br/><br/>
    <a href="https://decidim.org">Decidim</a> |
    <a href="https://docs.decidim.org/en/">Decidim Docs</a> |
    <a href="https://meta.decidim.org">Participatory Governance (meta decidim)</a><br/><br/>
    <a href="https://matrix.to/#/+decidim:matrix.org">Decidim Community (Matrix+Element.io)</a>
</h4>
<p align="center">
<a href="https://participer.lausanne.ch"><img src="https://github.com/octree-gva/meta/blob/main/decidim/static/participer_lausanne/chip.png?raw=true" alt="Lausanne Participe — Une plateforme de participation pour imaginer et réaliser ensemble" /></a>
</p>


# Spammer Signaler
An automation to verify and signaler users spammers, sponsored by the [Participer Lausanne](https://participer.lausanne.ch). 

## Why


## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-spam_signal", git: "https://github.com/octree-gva/decidim-module-spam_signal"
```

Then execute:

```bash
bundle
```

## Config ENVs
```bash
export USER_BOT_EMAIL='bot@example.ch' # user-bot used for signaling the spammers
export UNCHECKABLE_EMAIL_DOMAIN='@example.ch' # email domain from administrators 
```

## Testing
The [Rakefile](Rakefile) is shipped with a `test_app` using `docker-compose` to run a database.
If you haven't done it already, [install](https://docs.docker.com/get-docker/) docker](https://docs.docker.com/get-docker/). 
```
    bundle exec rake test_app
```

## Contributing
This repository is not yet ready for contributions.

## License
This engine is distributed under the [GNU AFFERO GENERAL PUBLIC LICENSE](LICENSE.md).


<br /><br />
<p align="center">
    <img src="https://raw.githubusercontent.com/octree-gva/meta/main/decidim/static/octree_and_decidim.png" height="90" alt="Decidim Installation by Octree" />
</p>