---
sidebar_position: 6
title: Sign Out & Lock
description: Configure the agent "Sign Out & Lock"
---
# Sign Out & Lock Agent
This agent will sign out the user and send them unlock instructions. If the user clicks on the unlock link, they will be able to sign in again.

**When to use**  
If you want to discourage a spammer by making their life more complicated, this is a good option. However, you need to be extra careful about the rule you apply, as this agent can discourage legitimate users from using the platform. This agent is designed to be effective after a spam detection, so use it with care.

**Options**  
- _Avoid the user to save this data_: If checked, the content won't be saved. For comments, for example, this prevents emails from being sent to followers with spam content.
- _After locking the account, report it_: If checked, the user will appear in the Participants > Reported Users page of the Decidim Administration.
- _After locking the user, hide all their comments_: This will hide all content the user has written from this point forward. Administrators can manually unhide comments from the Global Moderation > Hidden section.
