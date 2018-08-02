# APIv2: Resource Endpoints

<aside class="aside">
APIv2 is still in beta, and while the scopes and endpoints are stable, the specific properties returned on the resources may change.
</aside>

<aside class="notice">
All API requests should use the hostname https://www.patreon.com
</aside>

With APIv2, all properties must be individually requested; there are no more default properties on resources.

## GET /api/oauth2/v2/identity

<aside>
In earlier versions of the beta, this was /api/oauth2/v2/me. This is currently available at /api/oauth2/vNext/identity until the public beta goes live.
</aside>

Fetches the [User](/#user-v2) resource. Top-level `include`s: [`memberships`](/#member), [`campaign`](/#campaign-v2).

This is the endpoint for accessing information about the current [User](/#user-v2) with reference to the oauth token. With the basic scope of identity, you will receive the user’s public profile information. If you have the `identity[email]` scope, you will also get the user’s email address. You will not receive email address without that scope.

```json
// Sample response with email scope for https://www.patreon.com/api/oauth2/v2/identity?fields[user]=about,created,email,first_name,full_name,image_url,last_name,social_connections,thumb_url,url,vanity
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

You can request related data through includes, ie, `/api/oauth2/v2/identity?include=memberships` and `/api/oauth2/v2/identity?include=campaign`.

- If you request [Campaign](/#campaign-v2) and have the campaigns scope, you will receive information about the user’s [Campaign](/#campaign-v2).
- If you request [Campaign](/#campaign-v2) and memberships, you will receive information about the user’s [memberships](/#member) and the [Campaign](/#campaign-v2)s they are [Member](/#member) of, provided you have the `campaigns` and `identity[memberships]` scopes.
- If you request memberships and DON’T have the `identity.memberships` scope, you will receive data about the user’s membership to your campaign. If you DO have the scope, you will receive data about all of the user’s memberships, to all the campaigns they’re members of.

## GET /api/oauth2/v2/campaigns

<aside>
This is also available at /api/oauth2/vNext/campaigns/{campaign_id} until the public beta goes live.
</aside>

Requires the `campaigns` scope. The listing endpoint returns all available [Campaign](/#campaign-v2)s. Top-level `include`s: [`tiers`](/#tier), [`creator`](/#user), [`benefits`](/#benefit), [`goals`](/#goal).

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

## GET /api/oauth2/v2/campaigns/{campaign_id}

<aside>
This is currently available at /api/oauth2/vNext/campaigns/{campaign_id} until the public beta goes live.
</aside>

Requires the `campaigns` scope. The single resource endpoint returns information about a single [Campaign](/#campaign-v2), fetched by campaign ID.

Top-level `include`s: [`tiers`](/#tier), [`creator`](/#user), [`benefits`](/#benefit), [`goals`](/#goal).

```json
//Sample response for https://www.patreon.com/api/oauth2/v2/campaigns/{campaign_id}?fields[campaign]=created_at,creation_name,discord_server_id,image_small_url,image_url,is_charged_immediately,is_monthly,_is_nswf,main_video_embed,main_video_url,one_liner,one_liner,patron_count,pay_per_name,pledge_url,published_at,summary,thanks_embed,thanks_msg,thanks_video_url
{
    "data":
        {
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
        },
}
```

## GET /api/oauth2/v2/campaigns/{campaign_id}/members

<aside>
In earlier versions of the beta, this was /api/oauth2/v2/members. This is currently available at /api/oauth2/vNext/campaigns/{campaign_id}/members until the public beta goes live.
</aside>

Gets the [Members](/#member) for a given [Campaign](/#campaign-v2). Requires the `campaigns.members` scope. Top-level `include`s: [`address`](/#address) (requires `campaign.members.address` scope), [`campaign`](/#campaign-v2), [`currently_entitled_tiers`](/#tier), [`user`](/#user).

We recommend using `currently_entitled_tiers` to see exactly what a [Member](/#member) is entitled to, either as an include on the members list or on the member get.

```json
// Sample response for https://www.patreon.com/api/oauth2/v2/campaigns/{campaign_id}/members?fields[member]=full_name,is_follower,last_charge_date,last_charge_status,lifetime_support_cents,currently_entitled_amount_cents,patron_status&include=currently_entitled_rewards&fields[reward]=amount,amount_cents,created_at,description,discord_role_ids,edited_at,patron_count,published,published_at,requires_shipping,title,url
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
        "next": "https://www.patreon.com/api/oauth2/v2/campaigns/{campaign_id}/members?page%5Bcursor%5D=12345678abcdefg",
    },
    "meta": {
        "pagination": {"cursors": {"next": "q349287429sdfjhskdfjh"}}
    }
}
```

## GET /api/oauth2/v2/members/{id}

<aside>
This is currently available at /api/oauth2/vNext/members/{member_id}/members until the public beta goes live.
</aside>

Get a particular member by id. Requires the `campaigns.members` scope. Top-level `include`s: [`address`](/#address) (requires `campaign.members.address` scope), [`campaign`](/#campaign-v2), [`currently_entitled_tiers`](/#tier), [`user`](/#user).


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
