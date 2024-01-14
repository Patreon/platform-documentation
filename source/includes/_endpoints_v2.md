# APIv2: Resource Endpoints

<aside class="aside">
APIv2 is still in beta, and while the scopes and endpoints are stable, the specific properties returned on the resources may change.
</aside>

<aside class="notice">
All API requests should use the hostname https://www.patreon.com
</aside>

With APIv2, all properties must be individually requested; there are no more default properties on resources. This is done by including the desired proprties in the fields parameter i.e.: `fields[address]=addressee,city`

## GET /api/oauth2/v2/identity

Fetches the [User](/#user-v2) resource.

Top-level `includes`: [`memberships`](/#member), [`campaign`](/#campaign-v2).

This is the endpoint for accessing information about the current [User](/#user-v2) with reference to the oauth token. With the basic scope of identity, you will receive the user’s public profile information. If you have the `identity[email]` scope, you will also get the user’s email address. You will not receive email address without that scope.

Fields for each include must be explicitly requested i.e. `fields[campaign]=summary,is_monthly&fields[user]=full_name,email` but url encode the brackets i.e.`fields%5Bcampaign%5D=summary,is_monthly&fields%5Buser%5D=full_name,email`


```json
// Sample response with email scope for (url decoded) https://www.patreon.com/api/oauth2/v2/identity?fields[user]=about,created,email,first_name,full_name,image_url,last_name,social_connections,thumb_url,url,vanity
{
    "data": {
        "attributes": {
            "email": "some_email@email.com",
            "full_name": "Platform Team"
        },
        "id": "id",
        "relationships": {
            "campaign": {
                "data": {
                    "id": "id",
                    "type": "campaign"
                },
                "links": {
                    "related": "https://www.patreon.com/api/oauth2/v2/campaigns/id"
                }
            }
        },
        "type": "user"
    },
    "included": [
        {
            "attributes": {
                "is_monthly": true,
                "summary": "Hi There"
            },
            "id": "id",
            "type": "campaign"
        }
    ],
    "links": {
        "self": "https://www.patreon.com/api/oauth2/v2/user/id"
    }
}
```

You can request related data through includes, ie, `/api/oauth2/v2/identity?include=memberships` and `/api/oauth2/v2/identity?include=campaign`.

- If you request [Campaign](/#campaign-v2) and have the campaigns scope, you will receive information about the user’s [Campaign](/#campaign-v2).
- If you request [Campaign](/#campaign-v2) and memberships, you will receive information about the user’s [memberships](/#member) and the [Campaign](/#campaign-v2)s they are [Member](/#member) of, provided you have the `campaigns` and `identity.memberships` scopes.
- If you request memberships and DON’T have the `identity.memberships` scope, you will receive data about the user’s membership to your campaign. If you DO have the scope, you will receive data about all of the user’s memberships, to all the campaigns they’re members of.

## GET /api/oauth2/v2/campaigns

Requires the `campaigns` scope. Returns a list of [Campaign](/#campaign-v2)s owned by the authorized user.

Top-level `includes`: [`tiers`](/#tier), [`creator`](/#user-v2), [`benefits`](/#benefit), [`goals`](/#goal).

Fields for each include must be explicitly requested i.e. `fields[tier]=currently_entitled_tiers` but url encode the brackets i.e.`fields%5Btier%5D=currently_entitled_tiers`


```json
//Sample response for (url decoded) https://www.patreon.com/api/oauth2/v2/campaigns?fields[campaign]=created_at,creation_name,discord_server_id,image_small_url,image_url,is_charged_immediately,is_monthly,is_nsfw,main_video_embed,main_video_url,one_liner,one_liner,patron_count,pay_per_name,pledge_url,published_at,summary,thanks_embed,thanks_msg,thanks_video_url,has_rss,has_sent_rss_notify,rss_feed_title,rss_artwork_url,patron_count,discord_server_id,google_analytics_id
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

Top-level `includes`: [`tiers`](/#tier), [`creator`](/#user-v2), [`benefits`](/#benefit), [`goals`](/#goal).

Fields for each include must be explicitly requested i.e. `fields[campaign]=created_at,creation_name` but url encode the brackets i.e.`fields%5Bcampaign%5D=created_at,creation_name`

```json
//Sample response for (url decoded) https://www.patreon.com/api/oauth2/v2/campaigns/{campaign_id}?fields[campaign]=created_at,creation_name,discord_server_id,image_small_url,image_url,is_charged_immediately,is_monthly,main_video_embed,main_video_url,one_liner,one_liner,patron_count,pay_per_name,pledge_url,published_at,summary,thanks_embed,thanks_msg,thanks_video_url
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

Top-level `includes`: [`address`](/#address) (requires `campaigns.members.address` scope), [`campaign`](/#campaign-v2), [`currently_entitled_tiers`](/#tier), [`user`](/#user-v2).

Fields for each include must be explicitly requested i.e. `fields[tier]=currently_entitled_tiers` but url encode the brackets i.e.`fields%5Btier%5D=currently_entitled_tiers`

We recommend using `currently_entitled_tiers` to see exactly what a [Member](/#member) is entitled to, either as an include on the members list or on the member get.

Returns from this endpoint have 1000 results in one page. If pledge events are requested in includes, it has 500 results in one page. Do make sure to paginate your results by using next pagination cursor and cycle until there is no next page cursor in the API return.

```json
// Sample response for (url decoded) https://www.patreon.com/api/oauth2/v2/campaigns/{campaign_id}/members?include=currently_entitled_tiers,address&fields[member]=full_name,is_follower,last_charge_date,last_charge_status,lifetime_support_cents,currently_entitled_amount_cents,patron_status&fields[tier]=amount_cents,created_at,description,discord_role_ids,edited_at,patron_count,published,published_at,requires_shipping,title,url&fields[address]=addressee,city,line_1,line_2,phone_number,postal_code,state
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
            "url": "/bePatron?c=1231345&rid=54512321",
        },
        "id": "54321",
        "type": "tier",
    }],
    "meta": {
        "pagination": {
            "cursors": {
                "next": "12345678ab1231cdefg"
            },
            "total": 100
        }
    }
}
```

## GET /api/oauth2/v2/members/{id}

Get a particular member by id. Requires the `campaigns.members` scope.

Top-level `includes`: [`address`](/#address) (requires `campaign.members.address` scope), [`campaign`](/#campaign-v2), [`currently_entitled_tiers`](/#tier), [`user`](/#user-v2).

Fields for each include must be explicitly requested i.e. `fields[address]=line_1,city` but url encode the brackets i.e.`fields%5Baddress%5D=line_1,city`

We recommend using `currently_entitled_tiers` to see exactly what a member is entitled to, either as an include on the members list or on the member get.

```json
// Sample response for (url decoded) https://www.patreon.com/api/oauth2/v2/members/{member_id}?fields[address]=line_1,line_2,addressee,postal_code,city&fields[member]=full_name,is_follower,last_charge_date&include=address,user
{
    "data": {
        "attributes": {
            "full_name": "first last",
            "is_follower": false,
            "last_charge_date": "2020-10-01T11:18:36.000+00:00"
        },
        "id": "123-456-789",
        "relationships": {
            "address": {
                "data": {
                    "id": "123",
                    "type": "address"
                },
                "links": {
                    "related": "https://www.patreon.com/api/oauth2/v2/address/123"
                }
            },
            "user": {
                "data": {
                    "id": "123",
                    "type": "user"
                },
                "links": {
                    "related": "https://www.patreon.com/api/oauth2/v2/user/123"
                }
            }
        },
        "type": "member"
    },
    "included": [
        {
            "attributes": {
                "addressee": "123",
                "city": "city",
                "line_1": "line 1",
                "line_2": "Apt. 101",
                "postal_code": "123"
            },
            "id": "123",
            "type": "address"
        },
        {
            "attributes": {},
            "id": "123",
            "type": "user"
        }
    ],
    "links": {
        "self": "https://www.patreon.com/api/oauth2/v2/members/123-456-789"
    }
}
```

## GET /api/oauth2/v2/campaigns/{campaign_id}/posts

Get a list of all the [Posts](/#post-v2) on a given [Campaign](/#campaign-v2) by campaign ID. Requires the `campaigns.posts` scope.

## GET /api/oauth2/v2/posts/{id}

Get a particular [Post](/#post-v2) by ID. Requires the `campaigns.posts` scope.
