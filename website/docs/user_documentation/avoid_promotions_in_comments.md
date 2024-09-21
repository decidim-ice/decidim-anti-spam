---
sidebar_position: 10
title: Avoid promotional links
description: Example to avoid promotional links in comments
---
# Use case: Avoid promotional links in comments
Promotional links often use strange domain names, like `.finance`. With the anti-spam module, we can avoid this kind of link. Here, we will avoid `.finance` and `.shop` domains from being used, and when someone tries, we will signal the user to an admin.

<div class="full">
![General flow for this use case](./images/avoid_promotions_in_comments.png)
</div>

---

## Set up a detection for forbidden domains
First, we will define a detection to identify what is forbidden to write as a comment.

Once in your administration panel, you will see the Anti-Spam icon:  <br />
![Anti-Spam Tab](./screenshots/anti-spam-tab.png)

From there, you can add a detection in the Comment Section.  <br />
![Button + in front of Detection header to add a detection](./screenshots/new-detection.png)

Choose the Forbidden TLDs detection; we will avoid links with the `.finance` and `.shop` domain names.  <br />
![Select the forbidden TLDs scan](./screenshots/forbidden_tlds.png)

Add: `.finance, .shop` and save.  <br />
![Add the forbidden domains](./screenshots/detection-edit.png)

## Set up a spam rule
To be as flexible as possible, this module offers a way to define complex rules.  
For now, we will add just one rule that will forbid the user from saving the comment.

In the Rules > SPAM section, click on the `+OR` sign.  <br />
![Select the forbidden TLDs scan](./screenshots/new-spam-rule.png)

Define the rule to be active when the detection raises a `Forbidden domain extensions (TLDs) found`. Save.  <br />
![Click on the Forbidden domain extension](./screenshots/rule-edit.png)

Now, when `.finance` or `.shop` links are detected in a comment, they will pass to the rule with a `Forbidden domain extensions (TLDs) found`. The rule will evaluate as "active" and will continue the flow to the agent section. The agent will define __how to react to this__.

## Define the agent
An agent defines the action to be applied to the user or the comment saved. You can configure what to do in specific situations.

In the Agent > When SPAM section, click on the pencil icon.  <br />
![Click on the Forbidden domain extension](./screenshots/new-agent.png)

Select the Report agent.  <br />
![Click on the report agent button](./screenshots/new-report-agent.png)

Define the options of the agent. Save.<br />
![List of options available in the agent](./screenshots/report-agent-config.png)

## Conclusion
You can see that from the first flow we designed, we can define it in three simple steps inside the anti-spam module.

<div class="full">
![General flow for this use case](./images/avoid_promotions_in_comments.png)
![Final configurations](./screenshots/final.png)
</div>

You now have a very basic protection in the comment section of Decidim for some obvious links. You can, of course, improve this configuration to define more complex detections or rules.
