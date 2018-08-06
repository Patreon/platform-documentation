# APIv2: OAuth

<aside class="aside">
APIv2 is still in beta, and while the scopes and endpoints are stable, the specific properties returned on the resources may change.
</aside>

### What's new?
At a high level, the main differences between APIv1 and APIv2 are:

1. The Pledges resource has been replaced by the Members resource. Members return more data about the relationship between a patron and a creator, including charge status and membership lifetime.
2. **All data attributes and relationships must be explicitly requested** with the `fields` and `include` [query params](/#requesting-specific-data). In the past, the server would return certain attributes and relationships by default, whereas some had to be requested explicitly, which was confusing.
3. The scopes have been improved. We have reworked what scopes are available in the API to provide better access for developers and better security for our users.
4. Developers can now create webhooks on campaigns on behalf of the creator, so your application can get real-time updates about a creator's campaign.

### What stays the same?

1. Getting access to a Patreon user’s account via OAuth works much the same. Just make sure to request all required scopes.
2. The client creator’s access token will automatically have all V2 scopes associated with it.
3. We will not be deprecating APIv1 in the next year at least.

### Note to those with V1 tokens:

You will be able to request tokens with any set of APIv2 scopes from your existing APIv1 client. If you choose to create an APIv2-specific client in the developer portal, that client will only be able to request V2 scopes.

## Scopes

Scope | Description
----- | -----------
identity | Provides read access to data about the user. See the /identity endpoint documentation for details about what data is available.
identity[email] | Provides read access to the user’s email.
identity.memberships | Provides read access to the user’s memberships.
campaigns | Provides read access to basic campaign data. See the /campaign endpoint documentation for details about what data is available.
w:campaigns.webhook | Provides read, write, update, and delete access to the campaign’s webhooks created by the client.
campaigns.members | Provides read access to data about a campaign’s members. See the /members endpoint documentation for details about what data is available. Also allows the same information to be sent via webhooks created by your client.
campaigns.members[email] | Provides read access to the member’s email. Also allows the same information to be sent via webhooks created by your client.
campaigns.members.address | Provides read access to the member’s address, if an address was collected in the pledge flow. Also allows the same information to be sent via webhooks created by your client.

## Using APIv2 with APIv1

During the transitionary period, when APIv1 and APIv2 are both available, it is possible to make requests against APIv1 endpoints with APIv2 clients and tokens. APIv2 has more controls around private information, so a fuller set of APIv2 scopes is needed to access V1 resources.

V1 Scope | V2 Scopes Required
-------- | ------------------
campaigns | campaigns
my-campaign | campaigns
pledges | campaigns.members, campaigns.members[email], campaigns.members.address
pledges-to-me | identity.memberships
users | identity, identity[email]
