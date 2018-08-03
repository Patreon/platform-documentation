# APIv2: Webhook Endpoints

<aside class="aside">
APIv2 is still in beta, and while the scopes and endpoints are stable, the specific properties returned on the resources may change.
</aside>

## GET /api/oauth2/v2/webhooks

Get the [Webhooks](/#webhook) for the current user's [Campaign](/#campaign-v2) created by the API client. You will only be able to see webhooks created by your client. Requires the `w:campaigns.webhook` scope.

Top-level `include`s: [`client`](/#oauthclient), [`campaign`](/#campaign-v2).

```json
// Sample response https://www.patreon.com/api/oauth2/v2/webhooks/?fields[webhook]=last_attempted_at,num_consecutive_times_failed,paused,secret,triggers,uri
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
Create a [Webhook](/#webhook) on the current user’s campaign. Requires the `w:campaigns.webhook` scope.

## Triggers

Trigger | Cause
------- | -----
members:create | Triggered when a new member is created. Note that you may get more than one of these per patron if they delete and renew their membership. Member creation only occurs if there was no prior payment between patron and creator.
members:update | Triggered when the membership information is changed. Includes updates on payment charging events
members:delete | Triggered when a membership is deleted. Note that you may get more than one of these per patron if they delete and renew their membership. Deletion only occurs if no prior payment happened, otherwise pledge deletion is an update to member status.
members:pledge:create | Triggered when a new pledge is created for a member. This includes when a member is created through pledging, and when a follower becomes a patron.
members:pledge:update | Triggered when a member updates their pledge.
members:pledge:delete | Triggered when a member deletes their pledge.

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
        "data": {"type": "campaign", "id": "12345"},
      },
    },
  },
}

// Example API response
{  
   "data":{  
      "attributes":{  
         "last_attempted_at": null,
         "paused":false,
         "num_consecutive_times_failed":0,
         "secret":"abcdefghiklmnopqrstuvwyz",
         "triggers":[
            "members:create",
            "members:update",
            "members:delete"
         ],
         "uri":"https://example.com/hooks/patreon"
      },
      "id":"3955",
      "type":"webhook"
   }
}
```

## Webhook Responses

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
        }
      },
      "currently_entitled_tiers": {
        "data": []
      },
      "user": {
        "data": {
          "id": "987654321",
          "type": "user"
        }
      }
    },
    "type": "member"
  },
  "included": [
    ...campaign data...
    ...user data...
  ]
}
```

## PATCH /api/oauth2/v2/webhooks/{id}

Update a webhook with the given id, if the webhook was created by your client. Requires the `w:campaigns.webhook scope.`

- NOTE: If and only if `num_consecutive_times_failed` > 0, you have unsent events due to your webhook being unreachable on our last attempt. To send all your queued events, you can `PATCH /api/oauth2/v2/webhooks/{webhook_id}` with attribute `paused: false`. We’ll attempt to send you all unsent events and report back with your client’s response to us.


```json
// Sample PATCH payload
{
  "data": {
    "id": "1234567",
    "type": "webhook",
    "attributes": {
      "triggers": ["members:create", "members:delete"],
      "uri": "https://www.example2.com",
      "paused": "false" // <- do this if you’re attempting to send missed events, see NOTE in Example Webhook Payload
    }
  }
}
```
