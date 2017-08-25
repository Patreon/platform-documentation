# Use Cases
## Gating content for patrons only on my website
Gating content on your site is a very common use case for the Patreon API. There are a few ways of doing this using the patreon platform.

### WordPress
If you have a wordpress website, we recommend using the Patreon wordpress plugin. It does all of the heavy lifting for you, all you have to do is install the plugin and enter your API Client information.

### Custom
If you are looking for a more custom solution, the API provides enough functionality to make gating on external websites possible. You will need to implement the following.

1. Register an [API Client](#clients-and-api-keys)
2. Implement [OAuth](#oauth)
3. When a patron logs in via OAuth, you will receive a token.
4.  [Fetch the patron's profile](#fetching-a-patron-39-s-profile-info) which includes their pledge.
5. Use this data to show or hide the desired content.
