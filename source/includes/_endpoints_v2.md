# APIv2: Endpoints (beta)

<aside class="warning">
Warning! APIv2 is still in beta, and while the scopes and endpoints are mostly stable, the docs are subject to change.
</aside>

<aside class="notice">
All API requests should use the hostname https://www.patreon.com
</aside>

## GET /api/oauth2/v2/me

This is the endpoint for accessing information about the current user with reference to the oauth token. With the basic scope of identity, you will receive the user’s public profile information. If you have the `identity[email]` scope, you will also get the user’s email address.

```json
// Sample response with email scope
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
//Sample response
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

## GET /api/oauth2/v2/members
Gets the members for the current user’s campaign. Requires the `campaigns.members` scope.

Allowed includes: address (requires scope), currently_entitled_rewards, campaign

We recommend using `currently_entitled_rewards` to see exactly what a member is entitled to, either as an include on the members list or on the member get.

```json
// Sample response with include=currently_entitled_rewards
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
            "image_url": null,
            "patron_count": 32,
            "post_count": 1,
            "published": true,
            "published_at": "2018-04-01T02:55:36.938342+00:00",
            "remaining": null,
            "requires_shipping": false,
            "title": "Patron",
            "unpublished_at": null,
            "url": "/bePatron?c=12345&rid=54321",
            "user_limit": null
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

## GET /api/oauth2/v2/members/{id}

Get a particular member by id. Requires the `campaigns.members` scope.

Allowed includes: address (requires scope), currently_entitled_rewards, campaign

We recommend using `currently_entitled_rewards` to see exactly what a member is entitled to, either as an include on the members list or on the member get.

```json
// Sample response:
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

## GET /api/oauth2/v2/webhooks

Get the webhooks for the current user's campaign created by the API client. You will only be able to see webhooks created by your client. Requires the `w:campaigns.webhook` scope.

```json
// Sample response:
{
    "data": [
        {
            "attributes": {
                "last_attempted_at": "2018-04-01T20:09:18+00:00",
                "num_consecutive_times_failed": 0,
                "paused": false,
                "secret": "hereisaverycomplexsecret",
                "triggers": [
                    "members:create",
                    "members:delete",
                    "members:update"
                ],
                "uri": "https://requestb.in/123456"},
            "id": "2793",
            "type": "webhook",
        },
    ],
}
```

## POST /api/oauth2/v2/webhooks
Create a webhook on the current user’s campaign. Requires the `w:campaigns.webhook` scope.

### Triggers

Trigger | Cause
------- | -----
members:create | Triggered when a new member is created. Note that you may get more than one of these per patron if they delete and renew their membership. Member creation only occurs if there was no prior payment between patron and creator.
members:update | Triggered when the membership information is changed. Includes updates on payment charging events
members:delete | Triggered when a membership is deleted. Note that you may get more than one of these per patron if they delete and renew their membership. Deletion only occurs if no prior payment happened, otherwise pledge deletion is an update to member status.

<aside class="notice">
Note: When the webhooks API was made available in a limited beta to API v1 customers, we allowed triggers on the pledge model. In API v2, pledge has been deprecated and member is the resource of record. Any existing webhooks on pledge will continue to work until API v1 is deprecated.
</aside>

```json
// Example POST Payload
{
  "data": {
    "type": "webhook",
    "attributes": {
      "triggers": ["members:create", "members:update", "members:delete"],
      "uri": "https://www.example.com",
    },
    "relationships": {
      "campaign": {
        "data": {"type": "campaign", "id": "foo"},
      },
    },
  },
}

// Example API response
{  
   "data":{  
      "attributes":{  
         "enabled":true,
         "num_consecutive_times_failed":0,
         "secret":"abcdefghiklmnopqrstuvwyz",
         "trigger":"pledges:create",
         "triggers":[  
            "pledges:create"
         ],
         "uri":"https://example.com/hooks/patreon"
      },
      "id":"3955",
      "type":"webhook"
   },
   "links":{  
      "self":"https://www.patreon.com/api/webhooks/3955"
   }
}
```

### Webhook Responses

When a webhook fires, the data will look something like this. Note that there will be a `X-Patreon-Signature` header, which is the HEX digest of the message body HMAC signed (with MD5) using your webhook's secret. We suggest you use this to verify authenticity of the webhook event. Webhook secrets should not be shared.

```json
{
  "data": {
    "attributes": {
      "currently_entitled_amount_cents": null,
      "full_name": "Platform",
      "is_follower": true,
      "last_charge_date": null,
      "last_charge_status": null,
      "lifetime_support_cents": 0,
      "note": "",
      "patron_status": null,
      "pledge_relationship_start": null
    },
    "id": "d485d5ac-6c82-42c6-9c08-c50cf01b73d7",
    "relationships": {
      "address": {
        "data": null
      },
      "campaign": {
        "data": {
          "id": "123456",
          "type": "campaign"
        },
        "links": {
          "related": "https://www.patreon.com/api/campaigns/123456"
        }
      },
      "currently_entitled_rewards": {
        "data": []
      },
      "user": {
        "data": {
          "id": "987654321",
          "type": "user"
        },
        "links": {
          "related": "https://www.patreon.com/api/user/987654321"
        }
      }
    },
    "type": "member"
  },
  "included": [
    ...campaign data...
    ...user data...
  ],
  "links": {
    "self": "https://www.patreon.com/api/members/d485d5ac-6c82-42c6-9c08-c50cf01b73d7"
  }
}
```

## PATCH /api/oauth2/v2/webhooks/{id}

Update a webhook with the given id, if the webhook was created by your client. Requires the `w:campaigns.webhook scope.`

<aside class="notice">
NOTE: If and only if `num_consecutive_times_failed` > 0, you have unsent events due to your webhook being unreachable on our last attempt. To send all your queued events, you can `PATCH /api/oauth2/v2/webhooks/<webhook_id>` with attribute `is_paused: false`. We’ll attempt to send you all unsent events and report back with your client’s response to us.
</aside>

```json
// Sample PATCH payload
{
  "data": {
    "id": "1234567",
    "type": "webhook",
    "attributes": {
      "triggers": ["members:create", "members:delete"],
      "uri": "https://www.example2.com",
      "is_paused": "false" // <- do this if you’re attempting to send missed events, see NOTE in Example Webhook Payload
    },
  },
}
```




