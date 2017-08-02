# Webhooks
Webhooks use the permissions provided by specific OAuth clients obtained from the [Clients & API Keys](https://www.patreon.com/platform/documentation/clients) page. Please go there first to set up your OAuth client.

Webhooks allow you to receive real-time updates from our servers. While there will eventually be many events about which you can be notified, we presently only support webhooks that trigger when you get a new patron, or an existing patron edits or deletes their pledge.

When one of these events occurs, our servers will send an HTTP POST to a URL you specify. This HTTP POST will contain the relevant data from the user action in JSON format. It will also have headers

<code>X-Patreon-Event: [trigger]<br>
X-Patreon-Signature: [message signature]</code>

where the message signature is the JSON POST body HMAC signed (with MD5) with your client_secret.

Note: As always: please never reveal your client_secrets. If the secret is compromised, the attacker could get access to your campaign info, all of your patron’s profile info, and their pledge amounts (all on an ongoing, refreshable basis). If you fear your secret has been compromised, please let us know and we will look into granting you a new id & secret pair (this will, however, cause all of your patrons to have to re-“Log in with Patreon”)

## Get a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get(2)
```

```shell
curl "http://example.com/api/kittens/2"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.get(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "name": "Max",
  "breed": "unknown",
  "fluffiness": 5,
  "cuteness": 10
}
```

This endpoint retrieves a specific kitten.

<aside class="warning">Inside HTML code blocks like this one, you can't use Markdown, so use <code>&lt;code&gt;</code> blocks to denote code.</aside>

### HTTP Request

`GET http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to retrieve

## Delete a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
curl "http://example.com/api/kittens/2"
  -X DELETE
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "deleted" : ":("
}
```

This endpoint retrieves a specific kitten.

### HTTP Request

`DELETE http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to delete
