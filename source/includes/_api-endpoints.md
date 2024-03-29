#API Endpoints

> To use a given `access_token`, send it in the Authorization HTTPS Header as follows:

```
Authorization: Bearer <access_token>
```

The three endpoints below are accessed using an OAuth client `access_token` obtained from the [OAuth](#oauth) section. Please go there first if you do not yet have one.

When performing an API request, the information you are allowed is determined by which `access_token` you are using. Please be sure to select your `access_token` appropriately. For example, __if someone has granted your OAuth client access to their profile information, and you try to fetch it using your own Creator's Access Token instead of the one created when they granted your client access, you will instead just get your own profile information.__

During the transition period from APIv1 to APIv2, it is possible to use [v2 scopes on v1 endpoints](#using-apiv2-with-apiv1). If you do this, note that you may have more scope than you had in v1, and so the set of data returned will be much greater.

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
    @user = user_response.data
    @pledge = @user.pledges ? @user.pledges[0] : nil
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
    user = user_response.data()
    pledges = user.relationship('pledges')
    pledge = pledges[0] if pledges and len(pledges) > 0 else None
```

```shell
curl --request GET \
  --url https://www.patreon.com/api/oauth2/api/current_user \
  --header 'authorization: Bearer <access_token>'
```

```php
<?php

use Patreon\API;
use Patreon\OAuth;

$client_id = null;      // Replace with your data
$client_secret = null;  // Replace with your data
$redirect_uri = null;   // Replace with your data

$oauth_client = new Patreon\OAuth($client_id, $client_secret);
$tokens = $oauth_client->get_tokens($_GET['code'], $redirect_uri);
$access_token = $tokens['access_token'];
$refresh_token = $tokens['refresh_token'];

$api_client = new Patreon\API($access_token);
$patron_response = $api_client->fetch_user();
$patron = $patron_response->get('data');
$pledge = null;
if ($patron->has('relationships.pledges')) {
    $pledge = $patron->relationship('pledges')->get(0)->resolve($patron_response);
}

?>
```

```javascript
import url from 'url'
import patreonAPI, { oauth as patreonOAuth } from 'patreon'

const CLIENT_ID = null     // Replace with your data
const CLIENT_SECRET = null // Replace with your data
const redirectURL = null   // Replace with your data

const patreonOAuthClient = patreonOAuth(CLIENT_ID, CLIENT_SECRET)

function handleOAuthRedirectRequest(request, response) {
    const oauthGrantCode = url.parse(request.url, true).query.code

    patreonOAuthClient
        .getTokens(oauthGrantCode, redirectURL)
        .then(tokensResponse => {
            const patreonAPIClient = patreonAPI(tokensResponse.access_token)
            return patreonAPIClient('/current_user')
        })
        .then(({ store }) => {
            response.end(store.findAll('user').map(user => user.serialize()))
        })
        .catch(err => {
            console.error('error!', err)
            response.end(err)
        })
}

//Get the raw json from the response. See for the expected format of the data
var patreon_response = patreon_client('/current_user').then(function(result) {
  user_store = result.store
  const data = result.rawJson
  /*  data.data will contain the current_user, but there might be more users returned and loaded into the store.
   *  Get the id of the requested user, and find it in the store
   */
  const myUserId = data.data.id
  creator = user_store.find('user', myUserId)
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

> Response:

```json
{
  "data": {
    "attributes": {
      "about": null,
      "created": "2017-10-20T21:36:23+00:00",
      "discord_id": null,
      "email": "corgi@example.com",
      "facebook": null,
      "facebook_id": null,
      "first_name": "Corgi",
      "full_name": "Corgi The Dev",
      "gender": 0,
      "has_password": true,
      "image_url": "https://c8.patreon.com/2/400/0000000",
      "is_deleted": false,
      "is_email_verified": false,
      "is_nuked": false,
      "is_suspended": false,
      "last_name": "The Dev",
      "social_connections": {
        "deviantart": null,
        "discord": null,
        "facebook": null,
        "reddit": null,
        "spotify": null,
        "twitch": null,
        "twitter": null,
        "youtube": null
      },
      "thumb_url": "https://c8.patreon.com/2/100/0000000",
      "twitch": null,
      "twitter": null,
      "url": "https://www.patreon.com/corgithedev",
      "vanity": "corgithedev",
      "youtube": null
    },
    "id": "0000000",
    "relationships": {
      "pledges": {
        "data": []
      }
    },
    "type": "user"
  },
  "links": {
    "self": "https://www.patreon.com/api/user/0000000"
  }
}
```

This endpoint returns a JSON representation of the [user](#user) who granted your OAuth client an `access_token`. It is most typically used in the [OAuth "Log in with Patreon flow"](https://www.patreon.com/platform/documentation/oauth) to create or update the patron's account info in your application.

The Patreon JS library uses a data store pattern for storing inflated objects from the returned results of API calls. In some cases, especially if you have been granted the scopes for being a multi-campaign client or are opted-in to some API beta programs, the JS client calling `/current_user` will fetch the current user's campaign, as well as all the patron users connected to that campaign.

This can result in the user store in the JS library having a larger list of users than expected for a call to `/current_user`, but the current user's `user` object will be in that list.


### HTTPS Request

`GET https://www.patreon.com/api/oauth2/api/current_user`

<aside class="success">
Remember — you must pass the correct <code>access_token</code> from the user.
</aside>

## Fetch a creator profile and campaign info

```ruby
require 'patreon'

access_token = nil  # Replace with your data

api_client = Patreon::API.new(access_token)
campaign_response = api_client.fetch_campaign()
campaign = campaign_response.data[0]
puts "campaign is", campaign
user = campaign.creator
puts "user is", user
```

```php
<?php

use Patreon\API;
use Patreon\OAuth;

$access_token = null;   // Replace with your data

$api_client = new Patreon\API($access_token);
$campaign_response = $api_client->fetch_campaign();
$campaign = $campaign_response->get('data')->get('0');
echo "campaign is\n";
print_r($campaign->asArray(true));
$user = $campaign->relationship('creator')->resolve($campaign_response);
echo "user is\n";
print_r($user->asArray(true));
```

```python
import patreon

access_token = None   # Replace with your creator access token

api_client = patreon.API(access_token)
campaign_response = api_client.fetch_campaign()
campaign = campaign_response.data()[0]
print('campaign is', campaign)
user = campaign.relationship('creator')
print('user is', user)
```

```shell
curl --request GET \
  --url https://www.patreon.com/api/oauth2/api/current_user/campaigns \
  --header 'Authorization: Bearer <access_token>'
```

```javascript
import patreonAPI from 'patreon'

const accessToken = null   // Replace with your creator access token

const patreonAPIClient = patreonAPI(accessToken)
patreonAPIClient('/current_user/campaigns')
    .then(({ store }) => {
        const user = store.findAll('user').map(user => user.serialize())
        console.log('user is', user)
        const campaign = store.findAll('campaign').map(campaign => campaign.serialize())
        console.log('campaign is', campaign)
    })
    .catch(err => {
        console.error('error!', err)
        response.end(err)
    })
```

```java
import com.patreon.OAuth;
import com.patreon.API;
import org.json.JSONObject;
import org.json.JSONArray;
...

String accessToken = null; // Replace with your data

API apiClient = new API(accessToken);
JSONObject campaignResponse = apiClient.fetchCampaign();
JSONObject campaign = campaignResponse.getJSONObject("data");
JSONArray included = userResponse.getJSONArray("included");
JSONObject user = null;
// This will get simplified in future versions of the library.
// For now, we must denormalize the JSON:API response by hand.
String userID = campaign .getJSONObject("relationships").getJSONObject("creator").getJSONObject("data").getString("id");
if (included != null) {
   for (int i = 0; i < included.length(); i++) {
       JSONObject object = included.getJSONObject(i);
       if (object.getString("type").equals("user") && object.getJSONObject("relationships").getJSONObject("creator").getJSONObject("data").getString("id").equals(userID)) {
           user = object;
           break;
       }
   }
}
```

> Response:

```json
{
  "data": [{
    "attributes": {
      "created_at": "2017-10-20T21:39:01+00:00",
      "creation_count": 0,
      "creation_name": "Documentation",
      "discord_server_id": null,
      "display_patron_goals": false,
      "earnings_visibility": "public",
      "image_small_url": null,
      "image_url": null,
      "is_charged_immediately": false,
      "is_monthly": false,
      "is_nsfw": false,
      "is_plural": false,
      "main_video_embed": null,
      "main_video_url": null,
      "one_liner": null,
      "outstanding_payment_amount_cents": 0,
      "patron_count": 0,
      "pay_per_name": null,
      "pledge_sum": 0,
      "pledge_url": "/bePatron?c=0000000",
      "published_at": "2017-10-20T21:49:31+00:00",
      "summary": null,
      "thanks_embed": null,
      "thanks_msg": null,
      "thanks_video_url": null
    },
    "id": "0000000",
    "relationships": {
      "creator": {
        "data": {
          "id": "1111111",
          "type": "user"
        },
        "links": {
          "related": "https://www.patreon.com/api/user/1111111"
        }
      },
      "goals": {
        "data": []
      },
      "rewards": {
        "data": [{
            "id": "-1",
            "type": "reward"
          },
          {
            "id": "0",
            "type": "reward"
          }
        ]
      }
    },
    "type": "campaign"
  }],
  "included": [{
      "attributes": {
        "about": null,
        "created": "2017-10-20T21:36:23+00:00",
        "discord_id": null,
        "email": "corgi@patreon.com",
        "facebook": null,
        "facebook_id": null,
        "first_name": "Corgi",
        "full_name": "Corgi The Dev",
        "gender": 0,
        "has_password": true,
        "image_url": "https://c8.patreon.com/2/400/1111111",
        "is_deleted": false,
        "is_email_verified": false,
        "is_nuked": false,
        "is_suspended": false,
        "last_name": "The Dev",
        "social_connections": {
          "deviantart": null,
          "discord": null,
          "facebook": null,
          "reddit": null,
          "spotify": null,
          "twitch": null,
          "twitter": null,
          "youtube": null
        },
        "thumb_url": "https://c8.patreon.com/2/100/1111111",
        "twitch": null,
        "twitter": null,
        "url": "https://www.patreon.com/drkthedev",
        "vanity": "drkthedev",
        "youtube": null
      },
      "id": "1111111",
      "relationships": {
        "campaign": {
          "data": {
            "id": "0000000",
            "type": "campaign"
          },
          "links": {
            "related": "https://www.patreon.com/api/campaigns/0000000"
          }
        }
      },
      "type": "user"
    },
    {
      "attributes": {
        "amount": 0,
        "amount_cents": 0,
        "created_at": null,
        "description": "Everyone",
        "id": "-1",
        "remaining": 0,
        "requires_shipping": false,
        "type": "reward",
        "url": null,
        "user_limit": null
      },
      "id": "-1",
      "relationships": {
        "creator": {
          "data": {
            "id": "1111111",
            "type": "user"
          },
          "links": {
            "related": "https://www.patreon.com/api/user/1111111"
          }
        }
      },
      "type": "reward"
    },
    {
      "attributes": {
        "amount": 1,
        "amount_cents": 1,
        "created_at": null,
        "description": "Patrons Only",
        "id": "0",
        "remaining": 0,
        "requires_shipping": false,
        "type": "reward",
        "url": null,
        "user_limit": null
      },
      "id": "0",
      "relationships": {
        "creator": {
          "data": {
            "id": "1111111",
            "type": "user"
          },
          "links": {
            "related": "https://www.patreon.com/api/user/1111111"
          }
        }
      },
      "type": "reward"
    }
  ]
}
```

This endpoint returns a JSON representation of the user's [campaign](#campaign), including its rewards and goals, and the pledges to it. If there are more than twenty pledges to the campaign, the first twenty will be returned, along with a link to the next page of pledges.

### HTTPS Request

`GET https://www.patreon.com/api/oauth2/api/current_user/campaigns`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
includes | `rewards,creator,goals,pledges` | You can pass this `rewards`, `creator`, `goals`, or `pledges`

<aside class="success">
Remember — you must pass a valid <code>access_token</code>.
</aside>

## Paging through a list of pledges

```ruby
require 'patreon'
require 'uri'
require 'cgi'

access_token = nil # your Creator Access Token
api_client = Patreon::API.new(access_token)

# Get the campaign ID
campaign_response = api_client.fetch_campaign()
campaign_id = campaign_response.data[0].id

# Fetch all pledges
all_pledges = []
cursor = nil
while true do
    page_response = api_client.fetch_page_of_pledges(campaign_id, 25, cursor)
    all_pledges += page_response.data
    next_page_link = page_response.links[page_response.data]['next']
    if next_page_link
        parsed_query = CGI::parse(next_page_link)
        cursor = parsed_query['page[cursor]'][0]
    else
        break
    end
end

# Mapping to all patrons. Feel free to customize as needed.
# As with all standard Ruby objects, (pledge.methods - Object.methods) will list the available attributes and relationships
puts all_pledges.map{ |pledge| { full_name: pledge.patron.full_name, amount_cents: pledge.amount_cents } }
```

```python
import patreon

access_token = nil # your Creator Access Token
api_client = patreon.API(access_token)

# Get the campaign ID
campaign_response = api_client.fetch_campaign()
campaign_id = campaign_response.data()[0].id()

# Fetch all pledges
all_pledges = []
cursor = None
while True:
    pledges_response = api_client.fetch_page_of_pledges(campaign_id, 25, cursor=cursor)
    pledges += pledges_response.data()
    cursor = api_client.extract_cursor(pledges_response)
    if not cursor:
        break
```

```java
// TODO: Needs a code example of pagination
```

```shell
curl --request GET \
  --url https://www.patreon.com/api/oauth2/api/campaigns/<campaign_id>/pledges?include=patron.null \
  --header 'Authorization: Bearer <access_token>
```

```javascript
// TODO: get pagination example
```

```php
<?php

use Patreon\API;
use Patreon\OAuth;

$access_token = null; // Your Creator Access Token

$api_client = new Patreon\API($access_token);

// Get your campaign data
$campaign_response = $api_client->fetch_campaign();
$campaign_id = $campaign_response->get('data.0.id');

// get page after page of pledge data
$all_pledges = [];
$cursor = null;
while (true) {
    $pledges_response = $api_client->fetch_page_of_pledges($campaign_id, 25, $cursor);
    // loop over the pledges to get e.g. their amount and user name
    foreach ($pledges_response->get('data')->getKeys() as $pledge_data_key) {
        $pledge_data = $pledges_response->get('data')->get($pledge_data_key);
        array_push($all_pledges, $pledge_data);
    }
    // get the link to the next page of pledges
    if (!$pledges_response->has('links.next')) {
        // if there's no next page, we're done!
        break;
    }
    $next_link = $pledges_response->get('links.next');
    // otherwise, parse out the cursor param
    $next_query_params = explode("?", $next_link)[1];
    parse_str($next_query_params, $parsed_next_query_params);
    $cursor = $parsed_next_query_params['page']['cursor'];
}
?>
```

> Response:

```json
{
    "data": [
        {
            "attributes": {
                "amount_cents": 100,
                "created_at": "2016-07-25T20:59:52+00:00",
                "declined_since": null,
                "patron_pays_fees": false,
                "pledge_cap_cents": null
            },
            "id": "2745627",
            "relationships": {
                "patron": {
                    "data": {
                        "id": "111111",
                        "type": "user"
                    },
                    "links": {
                        "related": "https://www.patreon.com/api/user/111111"
                    }
                },
                "reward": {
                    "data": {
                        "id": "222222",
                        "type": "reward"
                    },
                    "links": {
                        "related": "https://www.patreon.com/api/rewards/222222"
                    }
                }
            },
            "type": "pledge"
        }
    ],
    "included": [
        {
            "attributes": {
                "about": "sample about text",
                "created": "2015-01-15T07:25:51+00:00",
                "email": "foo@bar.com",
                "facebook": null,
                "first_name": "Foo",
                "full_name": "Foo Bar",
                "gender": 1,
                "image_url": "",
                "is_email_verified": true,
                "last_name": "Bar",
                "social_connections": {
                    "deviantart": null,
                    "discord": null,
                    "facebook": null,
                    "reddit": null,
                    "spotify": null,
                    "twitch": null,
                    "twitter": null,
                    "youtube": null
                },
                "thumb_url": "",
                "twitch": null,
                "twitter": "foo",
                "url": "https://www.patreon.com/foo",
                "vanity": "foo",
                "youtube": null
            },
            "id": "111111",
            "type": "user"
        },
        {
            "attributes": {
                "amount_cents": 100,
                "created_at": "2017-12-19T01:56:37.762679+00:00",
                "description": "",
                "discord_role_ids": None,
                "edited_at": "2017-12-19T01:56:37.762679+00:00",
                "image_url": None,
                "patron_count": 1,
                "post_count": None,
                "published": True,
                "published_at": "2017-12-19T01:56:37.762679+00:00",
                "remaining": None,
                "requires_shipping": False,
                "title": "",
                "unpublished_at": None,
                "url": "/bePatron?c=12345&rid=222222",
                "user_limit": None
            },
            "id": "222222",
            "type": "reward"
        }
    ],
    "links": {
        "first": "https://www.patreon.com/api/oauth2/api/campaigns/70261/pledges?page%5Bcount%5D=10&sort=created",
        "next": "https://www.patreon.com/api/oauth2/api/campaigns/70261/pledges?page%5Bcount%5D=10&sort=created&page%5Bcursor%5D=2017-08-21T20%3A16%3A49.258893%2B00%3A00"
    },
    "meta": {
        "count": 18
    }
}
```

This endpoint returns a JSON list of [pledges](#pledge) to the provided `campaign_id`. They are sorted by the date the pledge was made, and provide relationship references to the **user** who made each respective pledge,
as well as the **reward tier** pledged to.

The API response will also contain a `links` field which may be used to fetch the next page of pledges, or go back to the first page.

<aside class="notice">
When you made a creator page to gain API access, behind the scenes a <a href="#campaign">campaign resource</a> was created. You can access this resource as described in <a href="#fetch-your-own-profile-and-campaign-info">Fetching your own profile and campaign info</a> after authenticating via OAuth with your creator account to gain your `campaign_id`.
</aside>

### HTTPS Request

`GET https://www.patreon.com/api/oauth2/api/campaigns/<campaign_id>/pledges?include=patron.null`


### Paging

<aside class="success">
Remember — you must pass a valid <code>access_token</code>.
</aside>

You may only fetch your own list of pledges. If you attempt to fetch another creator's pledge list, the API call will return an HTTPS 403. If you would like to create an application which can manage many creator's campaigns, please contact us in <a href="https://www.patreondevelopers.com/" target="_blank">the developers forum</a>.
