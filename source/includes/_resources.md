# Resources

Our JSON responses follow the [JSON-API standard](http://jsonapi.org), with the following structure for our three main resources (users, campaigns, and pledges):

## User

```json
{
  "type": "user"
  "id": <string>
  "attributes": {
    "first_name": <string>
    "last_name": <string>
    "full_name": <string>
    "vanity": <string>
    "email": <string>
    "about": <string>
    "facebook_id": <string>
    "image_url": <string>
    "thumb_url": <string>
    "youtube": <string>
    "twitter": <string>
    "facebook": <string>
    "created": <date>
    "url": <string>
  }
  "relationships": {
    "campaign": ...<campaign>...
  }
}
```

## Campaign

```json
{
  "type": "campaign"
  "id": <string>
  "attributes": {
    "summary": <string>
    "creation_name": <string>
    "pay_per_name": <string>
    "one_liner": <string>
    "main_video_embed": <string>
    "main_video_url": <string>
    "image_small_url": <string>
    "image_url": <string>
    "thanks_video_url": <string>
    "thanks_embed": <string>
    "thanks_msg": <string>
    "is_monthly": <bool>
    "is_nsfw": <bool>
    "created_at": <date>
    "published_at": <date>
    "pledge_url": <string>
    "pledge_sum": <int>
    "patron_count": <int>
    "creation_count": <int>
    "outstanding_payment_amount_cents": <int>
  }
  "relationships": {
    "creator": ...<user>...
    "rewards": [ ...<reward>, <reward>, ... ]
    "goals": [ ...<goal>, <goal>, ... ]
    "pledges": [ ...<pledge>, <pledge>, ... ]
  }
}

```

## Pledge

```json
{
  "type": "pledge"
  "id": <string>
  "attributes": {
    "amount_cents": <int>
    "created_at": <date>
    "pledge_cap_cents": <int>
    "patron_pays_fees": <bool>
  }
  "relationships": {
    "patron": ...<user>...
    "reward": ...<reward>...
    "creator": ...<user>...
    "address": ...<address>...
    "card": ...<card>...
    "pledge_vat_location": ...<vat-location>...
  }
}
```
