# APIv2: Resource Endpoints

<aside class="aside">
APIv2 is still in beta, and while the scopes and endpoints are stable, the specific properties returned on the resources may change.
</aside>

<aside class="notice">
All API requests should use the hostname https://www.patreon.com
</aside>

With APIv2, all properties must be individually; there are no more default properties on resources.

## GET /api/oauth2/v2/me

This is the endpoint for accessing information about the current user with reference to the oauth token. With the basic scope of identity, you will receive the user’s public profile information. If you have the `identity[email]` scope, you will also get the user’s email address. You will njot receive email address without that scope.

### User Attributes

Attribute  | Type | Description
---------- | -----| -----------
id | string | Unique identifier of this user
type | string | Type of this object, value is always "user"
first_name | string |
last_name | string |
vanity | string | The public "username" of the user. patreon.com/ goes to this user's creator page. Can be `null`, since non-creator users don't need vanities.
email | string | The user's email address. Only accessible via the /me endpoint, with the `identity[email]` scope.
about | string | The user's about text, which usually appears on the left of their profile page.
image_url | string | The user's profile picture URL, scaled to width 400px.
thumb_url | string | The user's profile picture URL, scaled to a square of size 100x100px.
created | string | Datetime of this user's account creation.

### User Relationships

Relationship | Type | Description
------------ | ---- | -----------
memberships | List[Member] | *Depends on your scopes.* If you have the `identity.memberships` scope, you will receive a list of this user's memberships to all campaigns they're members of. If you lack the scope, you will receive a single-element list with the membership to your campaign only.

```json
// Sample response with email scope for https://www.patreon.com/api/oauth2/v2/me?fields[user]=about,created,email,first_name,full_name,image_url,last_name,social_connections,thumb_url,url,vanity
{
    "data": {
        "attributes":
            {
                "about": "A Patreon Platform User",
                "created": "2018-04-01T00:36:26+00:00",
                "email": "platform@patreon.com",
                "first_name": "Platform",
                "full_name": "Platform Team",
                "image_url": "https://url.example",
                "last_name": "Platform",
                "social_connections": {
                    "deviantart": null,
                    "discord": null,
                    "facebook": null,
                    "spotify": null,
                    "twitch": null,
                    "twitter": {"user_id": "12345"},
                    "youtube": null
                },
                "thumb_url": "https://url.example",
                "url": "https://www.patreon.com/example",
                "vanity": "platform"
            },
        "id": "12345",
        "type": "user",
    },
    "links": {
        "self": "https://www.patreon.com/api/user/12345"
    },
}
```

You can request related data through includes, ie, `/api/oauth2/v2/me?include=memberships` and `/api/oauth2/v2/me?include=campaign`. If you request campaign and have the campaigns scope, you will receive information about the user’s campaign.

If you request campaign and memberships, you will receive information about the user’s memberships and the campaigns they are members of.

<aside class="warning">
If you request memberships and DON’T have the `identity.memberships scope`, you will receive data about the user’s membership to your campaign. If you DO have the scope, you will receive data about all of the user’s memberships, to all the campaigns they’re members of.
</aside>

## GET /api/oauth2/v2/campaigns

Gets the campaign data for the current user’s campaign. Requires the campaigns scope.

Allowed includes: creator, rewards, goals.

```json
//Sample response for https://www.patreon.com/api/oauth2/v2/campaigns?fields[campaign]=created_at,creation_name,discord_server_id,image_small_url,image_url,is_charged_immediately,is_monthly,_is_nswf,main_video_embed,main_video_url,one_liner,one_liner,patron_count,pay_per_name,pledge_url,published_at,summary,thanks_embed,thanks_msg,thanks_video_url
{
    "data":
        [{
            "attributes": {
                "created_at": "2018-04-01T15:27:11+00:00",
                "creation_name": "online communities",
                "discord_server_id": "1234567890",
                "image_small_url": "https://example.url",
                "image_url": "https://example.url",
                "is_charged_immediately": false,
                "is_monthly": true,
                "is_nsfw": false,
                "main_video_embed": null,
                "main_video_url": null,
                "one_liner": null,
                "patron_count": 1000,
                "pay_per_name": "month",
                "pledge_url": "/bePatron?c=12345",
                "published_at": "2018-04-01T18:15:34+00:00",
                "summary": "The most creator-first API",
                "thanks_embed": "",
                "thanks_msg": null,
                "thanks_video_url": null,
            },
           "id": "12345",
           "type": "campaign"
        }],
}
```

### Campaign Attributes

Attribute | Type | Description                                                                             
--------- | ---- | -----------
id | string | Unique identifier of this campaign                                                      
type  | string | Type of this object, value is always "campaign"                                         
summary  | string | The creator's summary of their campaign.                                                
created_at  | string | Datetime that the creator first began the campaign creation process. See `published_at`.
published_at | string | Datetime that the creator most recently published (made publicly visible) the campaign. 
creation_name | string | The type of content the creator is creating, as in " is creating ". Can be `null`.      
pay_per_name | string | The thing which patrons are paying per, as in " is making $1000 per ". Can be `null`.   
one_liner | string | Pithy one-liner for this campaign, displayed on the creator page. Can be `null`.        
main_video_embed | string | can be null
main_video_url | string | can be null
patron_count | integer | Number of patrons to this creator.
pledge_url | string | URL path to the pledge checkout flow for this campaign.
discord_server_id | string | can be null
image_small_url  | string | URL for the small corner image.
image_url  | string | Banner image URL for the campaign.
is_charged_immediately | boolean | true if the campaign charges upfront, false otherwise.
is_monthly  | boolean | true if the campaign charges per month, false if the campaign charges per-post.
is_nsfw  | boolean |

## GET /api/oauth2/v2/members
Gets the members for the token user’s campaign. Requires the `campaigns.members` scope.

Allowed includes: address (requires scope), currently_entitled_rewards, campaign

We recommend using `currently_entitled_rewards` to see exactly what a member is entitled to, either as an include on the members list or on the member get.

```json
// Sample response for https://www.patreon.com/api/oauth2/v2/members?fields[member]=full_name,is_follower,last_charge_date,last_charge_status,lifetime_support_cents,currently_entitled_amount_cents,patron_status&include=currently_entitled_rewards&fields[reward]=amount,amount_cents,created_at,description,discord_role_ids,edited_at,patron_count,published,published_at,requires_shipping,title,url
{
    "data": [
        {
            "attributes": {
                "full_name": "Platform Team",
                "is_follower": false,
                "last_charge_date": "2018-04-01T21:28:06+00:00",
                "last_charge_status": "Paid",
                "lifetime_support_cents": 400,
                "currently_entitled_amount_cents": 400,
                "patron_status": "active_patron",
           },
           "id": "03ca69c3-ebea-4b9a-8fac-e4a837873254",
           "relationships": {
                "currently_entitled_rewards": {
                    "data": [{
                        "id": "54321",
                        "type": "reward",
                    }]
                }
           },
           "type": "member",
        },
        ...other members...,    
    ],
    "included": [{
        "attributes": {
            "amount": 100,
            "amount_cents": 100,
            "created_at": "2018-04-01T04:15:41.403645+00:00",
            "description": "A reward",
            "discord_role_ids": ["1234567890"],
            "edited_at": "2018-04-01T02:55:36.963334+00:00",
            "patron_count": 32,
            "published": true,
            "published_at": "2018-04-01T02:55:36.938342+00:00",
            "requires_shipping": false,
            "title": "Patron",
            "url": "/bePatron?c=12345&rid=54321",
        },
        "id": "54321",
        "type": "reward",
    }],
    "links": {
        "next": "https://www.patreon.com/api/oauth2/v2/members?page%5Bcursor%5D=12345678abcdefg",
    },
    "meta": {
        "pagination": {"cursors": {"next": "q349287429sdfjhskdfjh"}}
    }
}
```

### Member Attributes

Attribute | Type | Description
--------- | ---- | -----------
id | string | Unique identifier of this member
type | string | Type of this object, value is always "member"
patron_status | string | The current relationship of the member to the campaign. Always one of `['active_patron', 'declined_patron', 'former_patron', '']`.
is_follower | boolean | true if the member is a follower and NOT a patron
full_name | string | Full name of the member user
last_charge_date | string | Datetime of last attempted charge. `null` if never charged.
last_charge_status | string | The result of the last attempted charge. Possible values are `['Paid', 'Declined', 'Deleted', 'Pending', 'Refunded', 'Fraud', 'Other', null]`. The only successful status is `Paid`. `null` if never charged.
lifetime_support_cents | integer | The total amount that the member has ever paid to the campaign. `0` if never paid.
pledge_relationship_start | string | Datetime of beginning of most recent pledge chain from this member to the campaign. Pledge updates do not change this value.
email | string | The member's email address. Requires the `campaigns.members[email]` scope. 
discord_vanity | string | The Discord vanity (username) of the member's linked Discord account, if it exists. Otherwise, `null`.
note | string | The creator's notes on the member. Can be `null`.
currently_entitled_amount_cents | integer | The amount in cents that the member is entitled to. This includes a current pledge, or payment that covers the current payment period.

### Member Relationships

Relationship | Type | Description
------------ | -----| -----------
address | Address | The member's shipping address that they entered for the campaign. Requires the `campaign.members.address` scope
campaign | Campaign | The campaign that the membership is for.
currently_entitled_rewards | List[Reward] | The rewards that the member is entitled to. This includes a current pledge, or payment that covers the current payment period.
user | User | The user who is pledging to the campaign.

## GET /api/oauth2/v2/members/{id}

Get a particular member by id. Requires the `campaigns.members` scope.

Allowed includes: address (requires scope), currently_entitled_rewards, campaign

We recommend using `currently_entitled_rewards` to see exactly what a member is entitled to, either as an include on the members list or on the member get.

```json
// Sample response for https://www.patreon.com/api/oauth2/v2/members/03ca69c3-ebea-4b9a-8fac-e4a837873254/?fields[member]=full_name,is_follower,last_charge_date,last_charge_status,lifetime_support_cents,patron_status,currently_entitled_amount_cents,pledge_cap_amount_cents,pledge_relationship_start
{
    "data": {
        "attributes": {
            "full_name": "Platform Team",
            "is_follower": false,
            "last_charge_date": "2018-04-01T21:28:06+00:00",
            "last_charge_status": "Paid",
            "lifetime_support_cents": 400,
            "patron_status": "active_patron",
            "currently_entitled_amount_cents": 100,
            "pledge_cap_amount_cents": 100,
            "pledge_relationship_start": "2018-04-01T16:33:27.861405+00:00"},
       "id": "03ca69c3-ebea-4b9a-8fac-e4a837873254",
       "type": "member",
    },
}
```
