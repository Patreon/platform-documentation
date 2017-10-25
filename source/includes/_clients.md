# Clients and API Keys

In order to authenticate with OAuth and interact with the Patreon API, you'll have to [register your Client(s)](https://www.patreon.com/platform/documentation/clients). This involves signing up on patreon.com and making a [creator account](https://www.patreon.com/create-on-patreon).

[Register your client here](https://www.patreon.com/platform/documentation/clients)

Once you've registered a Client you'll have access to a:

- **Client ID** – Used to identify your application/tool with the client you registered.
- **Client Secret** – Used to authenticate your application/tool with the client you registered.
- **Creator's Access Token** – Which can be used to access the API in the context of the creator you account you made when registering a client.
- **Creator's Refresh Token** – Can be used to refresh new access tokens.

<aside class="warning">
Note: Please never reveal your <strong>Client Secret(s)</strong>. If the secret is compromised, the attacker could get access to your campaign info, all of your patrons' profile info, email addresses, and their pledge amounts. If you fear your secret has been compromised, please let us know, and we will look into granting you a new id/secret pair.
</aside>
