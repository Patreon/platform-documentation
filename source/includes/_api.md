#API
>To use a given access_token, send it in an HTTP Header as follows:

```
Authorization: Bearer <user's access_token>
```

>Our JSON responses will follow the JSON-API standard, with the following structure for our three main resources (users, campaigns, and pledges):

> User Object Structure:

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
    "is_suspended": <bool>
    "is_deleted": <bool>
    "is_nuked": <bool>
    "created": <date>
    "url": <string>
  }
  "relationships": {
    "campaign": ...<campaign>...
  }
}
```
> Campaign Object Structure:

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

> Pledge Object Structure

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

Presently, there are three APIs available:

- [Fetching your own profile and campaign info](#fetch-your-own-profile-and-campaign-info)
- [Paging through a list of pledges to you](#paging-through-a-list-of-pledges-to-you)
- [Fetching a patron's profile info](#fetching-a-patron-39-s-profile-info)

These APIs are accessed using an OAuth client access_token obtained from the [Clients & API Keys](https://www.patreon.com/platform/documentation/clients) page. Please go there first if you do not yet have one.

When performing an API request, the information you are allowed to see is determined by which access_token you are using. Please be sure to select your access_token appropriately. For example, __if someone has granted your OAuth client access to their profile information, and you try to fetch it using your own access_token instead of the one created when they granted your client access, you will instead just get your own profile information.__



## Fetch your own profile and campaign info


```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get()
```

```shell
curl "http://example.com/api/kittens"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let kittens = api.kittens.get();
```

> The above command returns JSON structured like this:

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
    "is_suspended": <bool>
    "is_deleted": <bool>
    "is_nuked": <bool>
    "created": <date>
    "url": <string>
  }
  "relationships": {
    "campaign": ...<campaign>...
  }
}
```

This endpoint returns a JSON representation of the user's campaign, including its rewards and goals, and the pledges to it. If there are more than twenty pledges to the campaign, the first twenty will be returned, along with a link to the next page of pledges.

### HTTP Request

`GET https://api.patreon.com/oauth2/api/current_user/campaigns`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
includes | `rewards,creator,goals,pledge` | You can pass this `rewards`, `creator`, `goals`, or `pledge`

<aside class="success">
Remember — you must pass the correct <code>access_token</code> from the user.
</aside>

## Paging through a list of pledges to you
```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get()
```

```shell
curl "http://example.com/api/kittens"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let kittens = api.kittens.get();
```

> The above command returns JSON structured like this:

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
    "is_suspended": <bool>
    "is_deleted": <bool>
    "is_nuked": <bool>
    "created": <date>
    "url": <string>
  }
  "relationships": {
    "campaign": ...<campaign>...
  }
}
```

This API returns a JSON list of pledges to the provided `campaign_id`. They are sorted by the date the pledge was made, and provide relationship references to the users who made each respective pledge.

The API response will also contain a links section which may be used to fetch the next page of pledges, or go back to the first page.

### HTTP Request

`GET https://api.patreon.com/oauth2/api/campaigns/<campaign_id>/pledges`


### Paging

<aside class="success">
Remember — you must pass the correct <code>access_token</code> from the user.
</aside>

You may only fetch your own list of pledges. If you attempt to fetch another creator's pledge list, the API call will return an HTTP 403. If you would like to create an application which can manage many creator's campaigns, please contact us at [platform@patreon.com](mailto:platform@patreon.com).

## Fetching a patron's profile info
```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get()
```

```shell
curl "http://example.com/api/kittens"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let kittens = api.kittens.get();
```

> The above command returns JSON structured like this:

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
    "is_suspended": <bool>
    "is_deleted": <bool>
    "is_nuked": <bool>
    "created": <date>
    "url": <string>
  }
  "relationships": {
    "campaign": ...<campaign>...
  }
}
```

This API returns a JSON representation of the user who granted your OAuth client the provided access_token. It is most typically used in the [OAuth "Log in with Patreon flow"](https://www.patreon.com/platform/documentation/oauth) to create or update the user's account on your site.

### HTTP Request

`GET https://api.patreon.com/oauth2/api/current_user`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
includes | `rewards,creator,goals,pledge` | You can pass this `rewards`, `creator`, `goals`, or `pledge`

<aside class="success">
Remember — you must pass the correct <code>access_token</code> from the user.
</aside>
