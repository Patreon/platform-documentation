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
require 'patreon'

class OAuthController < ApplicationController
  def redirect
    oauth_client = Patreon::OAuth.new(client_id, client_secret)
    tokens = oauth_client.get_tokens(params[:code], redirect_uri)
    access_token = tokens['access_token']

    api_client = Patreon::API.new(access_token)
    user_response = api_client.fetch_user()
    @user = user_response['data']
    included = user_response['included']
    if included
      @pledge = included.find {|obj| obj['type'] == 'pledge' && obj['relationships']['creator']['data']['id'] == creator_id}
      @campaign = included.find {|obj| obj['type'] == 'campaign' && obj['relationships']['creator']['data']['id'] == creator_id}
    else
      @pledge = nil
      @campaign = nil
    end
  end
end
```

```php
<?php

require_once('vendor/patreon/patreon/src/patreon.php');

use Patreon\API;
use Patreon\OAuth;

$client_id = null;      // Replace with your data
$client_secret = null;  // Replace with your data
$creator_id = null;     // Replace with your data

$oauth_client = new Patreon\OAuth($client_id, $client_secret);

// Replace http://localhost:5000/oauth/redirect with your own uri
$redirect_uri = "http://localhost:5000/oauth/redirect";
// Make sure that you're using this snippet as Step 2 of the OAuth flow: https://www.patreon.com/platform/documentation/oauth
// so that you have the 'code' query parameter.
$tokens = $oauth_client->get_tokens($_GET['code'], $redirect_uri);
$access_token = $tokens['access_token'];
$refresh_token = $tokens['refresh_token'];

$api_client = new Patreon\API($access_token);
$patron_response = $api_client->fetch_user();
$patron = $patron_response['data'];
$included = $patron_response['included'];
$pledge = null;
if ($included != null) {
  foreach ($included as $obj) {
    if ($obj["type"] == "pledge" && $obj["relationships"]["creator"]["data"]["id"] == $creator_id) {
      $pledge = $obj;
      break;
    }
  }
}

/*
 $patron will have the authenticated user's user data, and
 $pledge will have their patronage data.
 Typically, you will save the relevant pieces of this data to your database,
 linked with their user account on your site,
 so your site can customize its experience based on their Patreon data.
 You will also want to save their $access_token and $refresh_token to your database,
 linked to their user account on your site,
 so that you can refresh their Patreon data on your own schedule.
 */

?>
```

```python
import patreon
from flask import request
...

client_id = None      # Replace with your data
client_secret = None  # Replace with your data
creator_id = None     # Replace with your data

@app.route('/oauth/redirect')
def oauth_redirect():
    oauth_client = patreon.OAuth(client_id, client_secret)
    tokens = oauth_client.get_tokens(request.args.get('code'), '/oauth/redirect')
    access_token = tokens['access_token']

    api_client = patreon.API(access_token)
    user_response = api_client.fetch_user()
    user = user_response['data']
    included = user_response.get('included')
    if included:
        pledge = next((obj for obj in included
            if obj['type'] == 'pledge' and obj['relationships']['creator']['data']['id'] == creator_id), None)
        campaign = next((obj for obj in included
            if obj['type'] == 'campaign' and obj['relationships']['creator']['data']['id'] == creator_id), None)
    else:
        pledge = None
        campaign = None
```

```shell
curl "http://example.com/api/kittens"
  -H "Authorization: meowmeowmeow"
```

```javascript
import url from 'url'
import patreonAPI, { oauth as patreonOAuth } from 'patreon'

const CLIENT_ID = 'pppp'
const CLIENT_SECRET = 'pppp'
const patreonOAuthClient = patreonOAuth(CLIENT_ID, CLIENT_SECRET)

const redirectURL = 'http://mypatreonapp.com/oauth/redirect'

function handleOAuthRedirectRequest(request, response) {
    const oauthGrantCode = url.parse(request.url, true).query.code

    patreonOAuthClient.getTokens(oauthGrantCode, redirectURL, (tokensError, { access_token }) => {
        const patreonAPIClient = patreonAPI(access_token)

        patreonAPIClient(`/current_user`, (currentUserError, apiResponse) => {
            if (currentUserError) {
                console.error(currentUserError)
                response.end(currentUserError)
            }

            response.end(apiResponse);
        })
    })
})
```

```java
import com.patreon.OAuth;
import com.patreon.API;
import org.json.JSONObject;
import org.json.JSONArray;
...

String clientID = null;        // Replace with your data
String clientSecret = null;    // Replace with your data
String creatorID = null;       // Replace with your data
String redirectURI = null;     // Replace with your data
String code = null;            // get from inbound HTTP request

OAuth oauthClient = new OAuth(clientID, clientSecret);
JSONObject tokens = oauthClient.getTokens(code, redirectURI);
String accessToken = tokens.getString("access_token");

API apiClient = new API(accessToken);
JSONObject userResponse = apiClient.fetchUser();
JSONObject user = userResponse.getJSONObject("data");
JSONArray included = userResponse.getJSONArray("included");
JSONObject pledge = null;
JSONObject campaign = null;
if (included != null) {
   for (int i = 0; i < included.length(); i++) {
       JSONObject object = included.getJSONObject(i);
       if (object.getString("type").equals("pledge") && object.getJSONObject("relationships").getJSONObject("creator").getJSONObject("data").getString("id").equals(creatorID)) {
           pledge = object;
           break;
       }
   }
   for (int i = 0; i < included.length(); i++) {
       JSONObject object = included.getJSONObject(i);
       if (object.getString("type").equals("campaign") && object.getJSONObject("relationships").getJSONObject("creator").getJSONObject("data").getString("id").equals(creatorID)) {
           campaign = object;
           break;
       }
   }
}

   // use the user, pledge, and campaign objects as you desire
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

`GET https://www.patreon.com/api/oauth2/api/current_user/campaigns`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
includes | `rewards,creator,goals,pledges` | You can pass this `rewards`, `creator`, `goals`, or `pledges`

<aside class="success">
Remember — you must pass the correct <code>access_token</code> from the user.
</aside>

## Paging through a list of pledges to you
<!--  TODO: Make this code actual Ruby-->
```ruby
api_client = patreon.API(patron_access_token)
patrons_page = api_client.fetch_page_of_pledges(campaign_id, 10)
next_cursor = api_client.extract_cursor(patrons_page)
second_patrons_page = api_client.fetch_page_of_pledges(campaign_id, 10, cursor=next_cursor)
```

```python
api_client = patreon.API(patron_access_token)
patrons_page = api_client.fetch_page_of_pledges(campaign_id, 10)
next_cursor = api_client.extract_cursor(patrons_page)
second_patrons_page = api_client.fetch_page_of_pledges(campaign_id, 10, cursor=next_cursor)
```
```java
// TODO: Needs a code example of pagination
```
```shell
curl "http://example.com/api/kittens"
  -H "Authorization: meowmeowmeow"
```

```javascript
// TODO: Add paginated example
```

```php
<?php
require_once('vendor/patreon/patreon/src/patreon.php');
use Patreon\API;
use Patreon\OAuth;
$access_token = **Your access token**;
$api_client = new Patreon\API($access_token);
// get page after page of pledge data
$campaign_id = $campaign_response['data'][0]['id'];
$cursor = null;
while (true) {
    $pledges_response = $api_client->fetch_page_of_pledges($campaign_id, 25, $cursor);
    // get all the users in an easy-to-lookup way
    $user_data = [];
    foreach ($pledges_response['included'] as $included_data) {
        if ($included_data['type'] == 'user') {
            $user_data[$included_data['id']] = $included_data;
        }
    }
    // loop over the pledges to get e.g. their amount and user name
    foreach ($pledges_response['data'] as $pledge_data) {
        $pledge_amount = $pledge_data['attributes']['amount_cents'];
        $patron_id = $pledge_data['relationships']['patron']['data']['id'];
        $patron_full_name = $user_data[$patron_id]['attributes']['full_name'];
        echo $patron_full_name . " is pledging " . $pledge_amount . " cents.\n";
    }
    // get the link to the next page of pledges
    $next_link = $pledges_response['links']['next'];
    if (!$next_link) {
        // if there's no next page, we're done!
        break;
    }
    // otherwise, parse out the cursor param
    $next_query_params = explode("?", $next_link)[1];
    parse_str($next_query_params, $parsed_next_query_params);
    $cursor = $parsed_next_query_params['page']['cursor'];
}
echo "Done!";
?>

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

`GET https://www.patreon.com/api/oauth2/api/campaigns/<campaign_id>/pledges`


### Paging

<aside class="success">
Remember — you must pass the correct <code>access_token</code> from the user.
</aside>

You may only fetch your own list of pledges. If you attempt to fetch another creator's pledge list, the API call will return an HTTP 403. If you would like to create an application which can manage many creator's campaigns, please contact us at [platform@patreon.com](mailto:platform@patreon.com).

## Fetching a patron's profile info
```ruby
require 'patreon'

class OAuthController < ApplicationController
  def redirect
    oauth_client = Patreon::OAuth.new(client_id, client_secret)
    tokens = oauth_client.get_tokens(params[:code], redirect_uri)
    access_token = tokens['access_token']

    api_client = Patreon::API.new(access_token)
    user_response = api_client.fetch_user()
    @user = user_response['data']
    included = user_response['included']
    if included
      @pledge = included.find {|obj| obj['type'] == 'pledge' && obj['relationships']['creator']['data']['id'] == creator_id}

    else
      @pledge = nil
    end
  end
end
```

```python
import patreon
from flask import request
...

client_id = None      # Replace with your data
client_secret = None  # Replace with your data
creator_id = None     # Replace with your data

@app.route('/oauth/redirect')
def oauth_redirect():
    oauth_client = patreon.OAuth(client_id, client_secret)
    tokens = oauth_client.get_tokens(request.args.get('code'), '/oauth/redirect')
    access_token = tokens['access_token']

    api_client = patreon.API(access_token)
    user_response = api_client.fetch_user()
    user = user_response['data']
    included = user_response.get('included')
    if included:
        pledge = next((obj for obj in included
            if obj['type'] == 'pledge' and obj['relationships']['creator']['data']['id'] == creator_id), None)
    else:
        pledge = None
```

```shell
curl "http://example.com/api/kittens"
  -H "Authorization: meowmeowmeow"
```
<!-- TODO: confirm that this is correct  -->

```php
<?php

require_once('vendor/patreon/patreon/src/patreon.php');

use Patreon\API;
use Patreon\OAuth;

$client_id = null;      // Replace with your data
$client_secret = null;  // Replace with your data
$creator_id = null;     // Replace with your data

$oauth_client = new Patreon\OAuth($client_id, $client_secret);

// Replace http://localhost:5000/oauth/redirect with your own uri
$redirect_uri = "http://localhost:5000/oauth/redirect";
// Make sure that you're using this snippet as Step 2 of the OAuth flow: https://www.patreon.com/platform/documentation/oauth
// so that you have the 'code' query parameter.
$tokens = $oauth_client->get_tokens($_GET['code'], $redirect_uri);
$access_token = $tokens['access_token'];
$refresh_token = $tokens['refresh_token'];

$api_client = new Patreon\API($access_token);
$patron_response = $api_client->fetch_user();
$patron = $patron_response['data'];
$included = $patron_response['included'];
$pledge = null;
if ($included != null) {
  foreach ($included as $obj) {
    if ($obj["type"] == "pledge" && $obj["relationships"]["creator"]["data"]["id"] == $creator_id) {
      $pledge = $obj;
      break;
    }
  }
}

/*
 $patron will have the authenticated user's user data, and
 $pledge will have their patronage data.
 Typically, you will save the relevant pieces of this data to your database,
 linked with their user account on your site,
 so your site can customize its experience based on their Patreon data.
 You will also want to save their $access_token and $refresh_token to your database,
 linked to their user account on your site,
 so that you can refresh their Patreon data on your own schedule.
 */

?>
```

```javascript
import url from 'url'
import patreonAPI, { oauth as patreonOAuth } from 'patreon'

const CLIENT_ID = 'pppp'
const CLIENT_SECRET = 'pppp'
const patreonOAuthClient = patreonOAuth(CLIENT_ID, CLIENT_SECRET)

const redirectURL = 'http://mypatreonapp.com/oauth/redirect'

function handleOAuthRedirectRequest(request, response) {
    const oauthGrantCode = url.parse(request.url, true).query.code

    patreonOAuthClient.getTokens(oauthGrantCode, redirectURL, (tokensError, { access_token }) => {
        const patreonAPIClient = patreonAPI(access_token)

        patreonAPIClient(`/current_user`, (currentUserError, apiResponse) => {
            if (currentUserError) {
                console.error(currentUserError)
                response.end(currentUserError)
            }

            response.end(apiResponse);
        })
    })
})
```

```java
import com.patreon.OAuth;
import com.patreon.API;
import org.json.JSONObject;
import org.json.JSONArray;
...

String clientID = null;        // Replace with your data
String clientSecret = null;    // Replace with your data
String creatorID = null;       // Replace with your data
String redirectURI = null;     // Replace with your data
String code = null;            // get from inbound HTTP request

OAuth oauthClient = new OAuth(clientID, clientSecret);
JSONObject tokens = oauthClient.getTokens(code, redirectURI);
String accessToken = tokens.getString("access_token");

API apiClient = new API(accessToken);
JSONObject userResponse = apiClient.fetchUser();
JSONObject user = userResponse.getJSONObject("data");
JSONArray included = userResponse.getJSONArray("included");
JSONObject pledge = null;
if (included != null) {
   for (int i = 0; i < included.length(); i++) {
       JSONObject object = included.getJSONObject(i);
       if (object.getString("type").equals("pledge") && object.getJSONObject("relationships").getJSONObject("creator").getJSONObject("data").getString("id").equals(creatorID)) {
           pledge = object;
           break;
       }
   }
}

   // use the user, pledge, and campaign objects as you desire
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
      ...
  }
}
```

This API returns a JSON representation of the user who granted your OAuth client the provided access_token. It is most typically used in the [OAuth "Log in with Patreon flow"](https://www.patreon.com/platform/documentation/oauth) to create or update the user's account on your site.

### HTTP Request

`GET https://www.patreon.com/api/oauth2/api/current_user`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
includes | `rewards,creator,goals,pledge` | You can pass this `rewards`, `creator`, `goals`, or `pledge`

<aside class="success">
Remember — you must pass the correct <code>access_token</code> from the user.
</aside>
