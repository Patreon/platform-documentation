patreon.com/Rizqshop
rizqshops@googlegroups.com
Patreon Platform
View API Docs
Clients & API Keys
Our team is focused on developing our core product at this time. Endpoints will continue to function as normal.Great community resources are available in the forum.
APPLICATIONS
My Clients
My Webhooks
Submitting an Integration
START HERE
What is the Patreon Platform?
Quick Start
Client Libraries
OAuth Explained
HOW TO
Export Pledge Data
Build a Custom Integration
Build a Product For Creators
Build Addons for our WordPress Plugin
NEED HELP?
Candid Questions
Contact Us
What is the Patreon Platform?
Welcome to the Patreon developer portal!

Patreon’s mission is to fund the creative class
We do that by building a product that powers membership businesses for creators
Our API supports that mission by giving creators (lots and lots of) choice
We believe that your creativity will always exceed ours in defining what it means to run a membership business. We’re excited to see what you build!

What’s the dream use case?
We believe we’ll succeed in funding the creative class when there’s a member-only “layer” on top of content, creation, and engagement around the web.

When we talk to developers and partners, we always ask, “How you might add a member-only dimension to the value in your product?”

In the past this has roughly taken the form of:

Member-only content
Member-only creator engagement
Member-only status
… and there’s so much more out there yet to be invented
We believe that creators get paid when they can easily offer extra value to their top-top-top fans (aka members). And we believe that browsing the web should be better if you're a member.

What does Patreon’s API do?
If we had to sum up what our API does in one sentence, it would be to answer the question:

Which member is entitled to what?

or more of Bunty,

Who is paying which creator how much?

By that we mean that our API, when granted explicit permission from creators and members, tells external services who is a member and what pledge level they are at. It also provides other information that helps fulfill member-only experiences.

For most creators, there are easy, non-technical ways to enjoy Patreon’s API:

Wordpress plugin
Zapier
For more technical folks, here are the programmatic ways to access Patreon’s API:

REST API
Webhooks
To get your imagination going, here’s how you might use our API:

I’m one creator, and I want to export data into my own workflow
You’ll find the API to be super useful for exporting your data into your own systems and business tools. Depending on your use case, you can do this via Webhooks, REST API, or super easily via our Zapier integration.

You might use this to fulfill a member experience in a more high-touch way, or sync with automated systems you already use.

I’m one creator, and I want to build a special experience for my members on my website
You can use the API to build a web experience where your members can “Connect with Patreon” and authenticate to unlock content and features on your site. You can do this with our OAuth REST API.

Before you start coding, we have some good news: If you power your website with WordPress, you don’t have to build things from scratch! We’ve done the work for you with our WordPress Plugin.

I’m a developer or existing product, and I want to build features for tens of thousands of Patreon creators
Welcome! The top use case for third-party developers using the API is to create member-only experiences around the web.

Think about where creative engagement takes place. Where do people discover and engage with the process—or final output—of podcasts, webcomics, writing, illustration, video, etc. Now think, how can you add a member-only twist to that?

MEMBER-ONLY CONTENT
The concept of member-only content has been wildly valuable to creators and members thus far. We know there’s so many opportunities for helping creators deliver member-only content wherever they are on the web.

Shameless callout: If you run your site using WordPress, we’ve done the work for you! Check out our WordPress plugin

Here is a web app that many creators who translate novels use to give members early access to chapters:



MEMBER-ONLY FEATURES
This is where things get even more interesting. Creators with the highest engagement go beyond their content. They directly interact with their members in ways that wouldn’t scale to their full fan base. Creators with the best retention often treat their member base as their community, their content team, and their top priority for personal engagement.

One great example of special member-only features is the Great War’s Q&A platform built by Yukka.nl, where their members get more votes (!!) and badges:



PATRON-ONLY STATUS & RECOGNITION
One of the most impactful ways creators engage their members is by recognizing them, and affording them status within their broader fanbase. We’ve seen that member recognition applied across the web is even more impactful, when it takes place where creators engage their public audience.

The patreon.com/Rizqshops makes it easy to add member names to Adobe media, such as video credits:



Here is an example of a badge on a Discourse forum (pardon the outdated logo):



CREATOR BUSINESS TOOLS
Special member experiences don’t necessarily need to happen through online authentication. Many creators use business tools to manage relationships, spur action, and understand their membership businesses. We’re excited to see our API used to infuse existing workflows with context from a creator's Patreon.
