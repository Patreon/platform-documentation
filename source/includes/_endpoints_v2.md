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
In earlier versions of the beta, this was /api/oauth2/v2/me
</aside>

This is the endpoint for accessing information about the current user with reference to the oauth token. With the basic scope of identity, you will receive the user’s public profile information. If you have the `identity[email]` scope, you will also get the user’s email address. You will not receive email address without that scope.

### User Attributes

Attribute | Type | Description
--------- | ---- | -----------
email | string | The user's email address. Requires certain scopes to access. See the scopes section of this documentation.
first_name | string |  Can be null.
last_name | string |  Can be null.
full_name | string |
is_email_verified | boolean |
vanity | string | The public "username" of the user. patreon.com/<vanity> goes to this user's creator page. Non-creator users might not have a vanity. Can be null.
about | string | The user's about text, which appears on their profile. Can be null.
image_url | string | The user's profile picture URL, scaled to width 400px.
thumb_url | string | The user's profile picture URL, scaled to a square of size 100x100px.
can_see_nsfw | boolean | `true` if this user can view nsfw content. Can be null.
created | string (UTC ISO format) | Datetime of this user's account creation.
url | string | URL of this user's creator or patron profile.
like_count | integer | How many posts this user has liked.
hide_pledges | boolean | `true` if the user has chosen to keep private which creators they pledge to. Can be null.
social_connections | string | Mapping from user's connected app names to external user id on the respective app.

### User Relationships

Relationship | Type | Description
------------ | ---- | -----------
memberships | array[memberships] | Usually a zero or one-element array with the user's membership to the token creator's campaign, if they are a member. With the `identity.memberships` scope, this returns memberships to ALL campaigns the user is a member of.
campaign | campaign |


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

- If you request campaign and have the campaigns scope, you will receive information about the user’s campaign.
- If you request campaign and memberships, you will receive information about the user’s memberships and the campaigns they are members of, provided you have the `campaigns` and `identity[memberships]` scopes.
- If you request memberships and DON’T have the `identity.memberships` scope, you will receive data about the user’s membership to your campaign. If you DO have the scope, you will receive data about all of the user’s memberships, to all the campaigns they’re members of.

## GET /api/oauth2/v2/campaigns

Requires the `campaigns` scope. The listing endpoint returns all available campaigns.

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
summary | string | The creator's summary of their campaign. Can be null.
creation_name | string | The type of content the creator is creating, as in "`vanity` is creating `creation_name`". Can be null.
pay_per_name | string | The thing which patrons are paying per, as in "`vanity` is making $1000 per `pay_per_name`". Can be null.
one_liner | string | Pithy one-liner for this campaign, displayed on the creator page. Can be null.
main_video_embed | string |  Can be null.
main_video_url | string |  Can be null.
image_url | string | Banner image URL for the campaign.
image_small_url | string | URL for the campaign's profile image.
thanks_video_url | string | URL for the video shown to patrons after they pledge to this campaign. Can be null.
thanks_embed | string |  Can be null.
thanks_msg | string | Thank you message shown to patrons after they pledge to this campaign. Can be null.
is_monthly | boolean | `true` if the campaign charges per month, `false` if the campaign charges per-post.
has_rss | boolean | Whether this user has opted-in to rss feeds
has_sent_rss_notify | boolean | Whether or not the creator has sent a one-time rss notification email.
rss_feed_title | string | The title of the campaigns rss feed.
rss_artwork_url | string | The url for the rss album artwork. Can be null.
is_nsfw | boolean | `true` if the creator has marked the campaign as containing nsfw content.
is_charged_immediately | boolean | `true` if the campaign charges upfront, `false` otherwise. Can be null.
created_at | string (UTC ISO format) | Datetime that the creator first began the campaign creation process. See `published_at`.
published_at | string (UTC ISO format) | Datetime that the creator most recently published (made publicly visible) the campaign. Can be null.
pledge_url | string | Relative (to patreon.com) URL for the pledge checkout flow for this campaign.
patron_count | integer | Number of patrons pledging to this creator.
discord_server_id | string | The ID of the external discord server that is linked to this campaign. Null if none. Can be null.
google_analytics_id | string | The ID of the Google Analytics tracker that the creator wants metrics to be sent to. Null if none. Can be null.
earnings_visibility | string | Controls the visibility of the total earnings in the campaign

### Campaign Relationships

Relationship | Type | Description
------------ | ---- | -----------
tiers | array[tiers] |
creator | creator |
benefits | array[benefits] |
goals | array[goals] |

### Tier Attributes

Attribute | Type | Description
--------- | ---- | -----------
amount_cents | integer | Monetary amount associated with this tier (in U.S. cents).
user_limit | integer | Maximum number of patrons this tier is limited to, if applicable. Can be null.
remaining | integer | Remaining number of patrons who may subscribe, if there is a `user_limit`. Can be null.
description | string | Tier display description.
requires_shipping | boolean | `true` if this tier requires a shipping address from patrons.
created_at | string (UTC ISO format) | Date this tier was created.
url | string | Fully qualified URL associated with this tier.
patron_count | integer | Number of patrons currently registered for this tier.
post_count | integer | Number of posts published to this tier. Can be null.
discord_role_ids | string | The discord role IDs granted by this tier. Null if None. Can be null.
title | string | Tier display title.
image_url | string | Full qualified image URL associated with this tier. Can be null.
edited_at | string (UTC ISO format) | Date tier was last modified.
published | boolean | `true` if the tier is currently published.
published_at | string (UTC ISO format) | Date this tier was last published. Can be null.
unpublished_at | string (UTC ISO format) | Date tier was unpublished, while applicable. Can be null.

### Tier Relationships

Relationship | Type | Description
------------ | ---- | -----------
campaign | campaign |
tier_image | tier_image |
benefits | array[benefits] |

### Benefit Attributes

Attribute | Type | Description
--------- | ---- | -----------
title | string | Benefit display title.
description | string | Benefit display description. Can be null.
benefit_type | string | Type of benefit, such as `custom` for creator-defined benefits. Can be null.
rule_type | string | A rule type designation, such as `eom_monthly` or `one_time_immediate`. Can be null.
created_at | string (UTC ISO format) | Date this benefit was created.
delivered_deliverables_count | integer | Number of deliverables for this benefit that have been marked complete.
not_delivered_deliverables_count | integer | Number of deliverables for this benefit that are due, for all dates.
deliverables_due_today_count | integer | Number of deliverables for this benefit that are due today specifically.
next_deliverable_due_date | string (UTC ISO format) | The next due date (after EOD today) for this benefit. Can be null.
tiers_count | integer | Number of tiers containing this benefit.
is_deleted | boolean | `true` if this benefit has been deleted.

### Benefit Relationships

Relationship | Type | Description
------------ | ---- | -----------
tiers | array[tiers] |
deliverables | array[deliverables] |
campaign | campaign |

## GET /api/oauth2/v2/campaigns/{campaign_id}

Requires the `campaigns` scope. The single resource endpoint returns information about a single campaign, fetched by campaign ID.

Allowed includes: creator, rewards, goals.

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
In earlier versions of the beta, this was /api/oauth2/v2/members
</aside>

Gets the members for a given campaign. Requires the `campaigns.members` scope.

Allowed includes: address (requires scope), currently_entitled_rewards, campaign

We recommend using `currently_entitled_rewards` to see exactly what a member is entitled to, either as an include on the members list or on the member get.

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

### Member Attributes

Attribute | Type | Description
--------- | ---- | -----------
patron_status | string |  Can be null.
is_follower | boolean | The user is not a pledging patron but has subscribed to updates about public posts.
full_name | string | Full name of the member user.
email | string | The member's email address. Requires the `campaigns.members[email]` scope.
pledge_relationship_start | string (UTC ISO format) | Datetime of beginning of most recent pledge chainfrom this member to the campaign. Pledge updates do not change this value. Can be null.
lifetime_support_cents | integer | The total amount that the member has ever paid to the campaign. `0` if never paid.
currently_entitled_amount_cents | integer | The amount in cents that the member is entitled to.This includes a current pledge, or payment that covers the current payment period.
last_charge_date | string (UTC ISO format) | Datetime of last attempted charge. `null` if never charged. Can be null.
last_charge_status | string | The result of the last attempted charge. Possible values are `['Paid', 'Declined', 'Deleted', 'Pending', 'Refunded', 'Fraud', 'Other', null]`. The only successful status is `Paid`. `null` if never charged. Can be null.
note | string | The creator's notes on the member.
will_pay_amount_cents | integer | The amount in cents the user will pay at the next pay cycle

### Member Relationships

Relationship | Type | Description
------------ | ---- | -----------
address | address | The member's shipping address that they entered for the campaign.Requires the `campaign.members.address` scope.
campaign | campaign | The campaign that the membership is for.
currently_entitled_tiers | array[currently_entitled_tiers] | The tiers that the member is entitled to. This includes a current pledge, or payment that covers the current payment period.
user | user | The user who is pledging to the campaign.

### Address Attributes

Attribute | Type | Description
--------- | ---- | -----------
addressee | string | Full recipient name Can be null.
line_1 | string | First line of street address Can be null.
line_2 | string | Second line of street address Can be null.
postal_code | string | Postal or zip code Can be null.
city | string | City
state | string | State or province name Can be null.
country | string | Country
phone_number | string | Telephone number Can be null.
created_at | string (UTC ISO format) |
confirmed | boolean | Whether the address was confirmed post creation
confirmed_at | string (UTC ISO format) | When this address was last confirmed, set by `confirmed` action attribute Can be null.

### Address Relationships

Relationship | Type | Description
------------ | ---- | -----------
user | user |
campaigns | array[campaigns] |

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
