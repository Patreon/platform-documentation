# Resources

Our JSON responses follow the [JSON:API standard](http://jsonapi.org), with the following structure for our three main resources (users, campaigns, and pledges):

<aside class="success">
When requesting some of these resources in our <a href="#">API</a> they will have sensible defaults for what attributes are included. To request optional attributes, e.g. <code>like_count</code> and <code>comment_count</code>,
specify the <code>fields</code>
parameter in the URL like <code>https://www.patreon.com/api/oauth2/api/current_user?fields[user]=like_count,comment_count</code>.
For more information, see the <a href="http://jsonapi.org/format/#fetching-sparse-fieldsets">JSON:API docs</a>.
</aside>

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
    // optional properties
    "like_count": <int>
    "comment_count": <int>
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
    "amount_cents": <int> // Amount cents in the currency used by the patron
    "created_at": <date>
    "currency": <string> // Currency code of the pledge event (USD, GBP, EUR etc.)
    "declined_since": <date>
    "patron_pays_fees": <bool>
    "pledge_cap_cents": <int>
    // optional properties
    "total_historical_amount_cents": <int>
    "is_paused": <bool>
    "status": <string> // The status of this pledge (valid, declined, pending, disabled)
    "has_shipping_address": <bool>
  }
  "relationships": {
    "patron": ...<user>...
    "reward": ...<reward>... // Tier associated with this pledge
    "creator": ...<user>...
    "address": ...<address>...
  }
}
```


<aside class="notice"><code>amount_cents</code> is based in the <b>patron</b> currency which may be different from the campaign and tier currency.</aside>

<aside class="notice"><code>declined_since</code> indicates the date of the most recent payment if it failed,
or `null` if the most recent payment succeeded. A pledge with a non-null <code>declined_since</code> should
be treated as <b>invalid</b>.
</aside>

<aside class="notice"><code>total_historical_amount_cents</code> indicates the lifetime value
this patron has paid to the campaign.
</aside>
