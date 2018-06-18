# APIv2: OAuth

<aside class="aside">
APIv2 is still in beta, and while the scopes and endpoints are stable, the specific properties returned on the resources may change.
</aside>

Getting access to a Patreon user’s account in V2 works much the same as it did for V1, but we have reworked what scopes are available in the API to provide better access for developers and better security for our users. When using V2, make sure to request all required scopes when implementing OAuth. The creator’s access token will automatically have V2 scopes associated with it.

You will be able to request tokens with any set of APIv2 scopes from your existing APIv1 client. If you choose to create an APIv2-specific client in the developer portal, that client will only be able to request V2 scopes.

## Scopes

Scope | Description
----- | -----------
identity | Provides read access to data about the user. See the /me endpoint documentation for details about what data is available.
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
pledges | campaigns.members campaigns.members[email] campaigns.members.address
pledges-to-me | identity.memberships
users | identity identity[email]