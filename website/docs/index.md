---
sidebar_position: 1
id: my-home-doc
slug: /
---

# How does it work?

Behind the scenes, Decidim works with `Ruby on Rails`, which has a really nice way to validate things before saving them. For example:

- A user saves their profile
- Rails runs all validators
- If it's valid, it saves. If not, it shows an error

This module will __add dynamic and configurable validators__ for some of the most critical resources of Decidim: 

- The user's profiles
- The user's personal URL
- The writing of comments

With this anti-spam module, validators will always follow the same flow:

- Take the content to be saved
- Execute the rules you have configured
- If your rules classify the content as `spam` -> execute a `spam` procedure (agent)
- If your rules classify the content as `suspicious` -> execute a `suspicious` procedure

This will allow you to add as few rules as possible at the beginning of the installation and change your rules according to spammers' pressure.
