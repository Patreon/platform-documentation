# APIv2: Resource Endpoints

<aside class="aside">
APIv2 is still in beta, and while the scopes and endpoints are stable, the specific properties returned on the resources may change.
</aside>

<aside class="notice">
All API requests should use the hostname https://www.patreon.com
</aside>

With APIv2, all properties must be individually requested; there are no more default properties on resources.

## GET /api/oauth2/v2/identity

Fetches the [User](/#user-v2) resource.

Top-level `include`s: [`memberships`](/#member), [`campaign`](/#campaign-v2).

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
}
```

You can request related data through includes, ie, `/api/oauth2/v2/identity?include=memberships` and `/api/oauth2/v2/identity?include=campaign`.

- If you request [Campaign](/#campaign-v2) and have the campaigns scope, you will receive information about the user’s [Campaign](/#campaign-v2).
- If you request [Campaign](/#campaign-v2) and memberships, you will receive information about the user’s [memberships](/#member) and the [Campaign](/#campaign-v2)s they are [Member](/#member) of, provided you have the `campaigns` and `identity[memberships]` scopes.
- If you request memberships and DON’T have the `identity.memberships` scope, you will receive data about the user’s membership to your campaign. If you DO have the scope, you will receive data about all of the user’s memberships, to all the campaigns they’re members of.

## GET /api/oauth2/v2/campaigns

Requires the `campaigns` scope. Returns a list of [Campaign](/#campaign-v2)s owned by the authorized user.

Top-level `include`s: [`tiers`](/#tier), [`creator`](/#user-v2), [`benefits`](/#benefit), [`goals`](/#goal).

```json
//Sample response for https://www.patreon.com/api/oauth2/v2/campaigns?fields[campaign]=created_at,creation_name,discord_server_id,image_small_url,image_url,is_charged_immediately,is_monthly,is_nsfw,main_video_embed,main_video_url,one_liner,one_liner,patron_count,pay_per_name,pledge_url,published_at,summary,thanks_embed,thanks_msg,thanks_video_url,has_rss,has_sent_rss_notify,rss_feed_title,rss_artwork_url,patron_count,discord_server_id,google_analytics_id,earnings_visibility
{
    "data": [
        {
            "attributes": {
                "created_at": "2018-05-04T23:34:08+00:00",
                "creation_name": "online communities",
                "discord_server_id": "1234567890",
                "google_analytics_id": "1234567890",
                "has_rss": true,
                "has_sent_rss_notify": true,
                "image_small_url": "https://example.url",
                "image_url": "https://example.url",
                "is_charged_immediately": false,
                "is_monthly": false,
                "is_nsfw": false,
                "main_video_embed": null,
                "main_video_url": "https://example.url",
                "one_liner": null,
                "patron_count": 2,
                "pay_per_name": "creation",
                "pledge_url": "/bePatron?c=1234560",
                "published_at": "2018-05-09T17:12:01+00:00",
                "rss_artwork_url": "https://example.url",
                "rss_feed_title": "My custom feed",
                "summary": "Putting the internet to work for creators.",
                "thanks_embed": null,
                "thanks_msg": null,
                "thanks_video_url": null
            },
            "id": "1234560",
            "type": "campaign"
        }
    ],
    "meta": {
        "pagination": {
            "total": 1
        }
    }
}
```

## GET /api/oauth2/v2/campaigns/{campaign_id}

Requires the `campaigns` scope. The single resource endpoint returns information about a single [Campaign](/#campaign-v2), fetched by campaign ID.

Top-level `include`s: [`tiers`](/#tier), [`creator`](/#user-v2), [`benefits`](/#benefit), [`goals`](/#goal).

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

Gets the [Members](/#member) for a given [Campaign](/#campaign-v2). Requires the `campaigns.members` scope.

Top-level `include`s: [`address`](/#address) (requires `campaign.members.address` scope), [`campaign`](/#campaign-v2), [`currently_entitled_tiers`](/#tier), [`user`](/#user-v2).

We recommend using `currently_entitled_tiers` to see exactly what a [Member](/#member) is entitled to, either as an include on the members list or on the member get.

```json
// Sample response for https://www.patreon.com/api/oauth2/v2/campaigns/{campaign_id}/members?include=currently_entitled_tiers,address&fields[member]=full_name,is_follower,last_charge_date,last_charge_status,lifetime_support_cents,currently_entitled_amount_cents,patron_status&fields[tier]=amount_cents,created_at,description,discord_role_ids,edited_at,patron_count,published,published_at,requires_shipping,title,url
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
                "address": {
                    "data": {
                        "id": "12345",
                        "type": "address"
                    }
                },
                "currently_entitled_tiers": {
                    "data": [{
                        "id": "54321",
                        "type": "tier",
                    }]
                }
           },
           "type": "member",
        },
        ...other members...,    
    ],
    "included": [
        {
            "attributes": {
                "addressee": "Platform Team",
                "city": "San Francisco",
                "confirmed": true,
                "confirmed_at": null,
                "country": "US",
                "created_at": "2018-06-03T16:23:38+00:00",
                "line_1": "555 Main St",
                "line_2": "",
                "phone_number": null,
                "postal_code": "94103",
                "state": "CA"
            },
            "id": "12345",
            "type": "address"
        },{
        "attributes": {
            "amount_cents": 100,
            "created_at": "2018-04-01T04:15:41.403645+00:00",
            "description": "A tier",
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
        "type": "tier",
    }],
    "links": {
        "next": "https://www.patreon.com/api/oauth2/v2/campaigns/{campaign_id}/members?page%5Bcursor%5D=12345678abcdefg",
    },
    "meta": {
        "pagination": {
            "cursors": {
                "next": "12345678abcdefg"
            },
            "total": 100
        }
    }
}
```

## GET /api/oauth2/v2/members/{id}

Get a particular member by id. Requires the `campaigns.members` scope.

Top-level `include`s: [`address`](/#address) (requires `campaign.members.address` scope), [`campaign`](/#campaign-v2), [`currently_entitled_tiers`](/#tier), [`user`](/#user-v2).


We recommend using `currently_entitled_tiers` to see exactly what a member is entitled to, either as an include on the members list or on the member get.

```json
// Sample response for https://www.patreon.com/api/oauth2/v2/members/03ca69c3-ebea-4b9a-8fac-e4a837873254?fields[member]=full_name,is_follower,email,last_charge_date,last_charge_status,lifetime_support_cents,patron_status,currently_entitled_amount_cents,pledge_relationship_start,will_pay_amount_cents&fields%5Btier%5D=title&fields%5Buser%5D=full_name,hide_pledges
{
    "data": {
        "attributes": {
            "full_name": "Platform Team",
            "email": "platform@team.com,
            "is_follower": false,
            "last_charge_date": "2018-04-01T21:28:06+00:00",
            "last_charge_status": "Paid",
            "lifetime_support_cents": 400,
            "patron_status": "active_patron",
            "currently_entitled_amount_cents": 100,
            "pledge_relationship_start": "2018-04-01T16:33:27.861405+00:00",
            "will_pay_amount_cents": 100},
       "id": "03ca69c3-ebea-4b9a-8fac-e4a837873254",
       "relationships": {
            "address": {
                "data": {
                    "id": "123456",
                    "type": "address"
                }
            },
            "currently_entitled_tiers": {
                "data": [
                    {
                        "id": "99001122",
                        "type": "tier"
                    }
                ]
            },
            "user": {
                "data": {
                    "id": "654321",
                    "type": "user"
                }
            }
       },
       "type": "member",
    },
    "included": [
        {
            "attributes": {
                "addressee": "Platform Team",
                "city": "San Francisco",
                "confirmed": true,
                "confirmed_at": null,
                "country": "US",
                "created_at": "2018-06-03T16:23:38+00:00",
                "line_1": "555 Main St",
                "line_2": "",
                "phone_number": null,
                "postal_code": "94103",
                "state": "CA"
            },
            "id": "123456",
            "type": "address"
        },
        {
            "attributes": {
                "full_name": "Platform Team",
                "hide_pledges": false,
            },
            "id": "654321",
            "type": "user"
        },
        {
            "attributes": {
                "title": "Tshirt Tier"
            },
            "id": "99001122",
            "type": "tier"
        }
    ]
}
```
