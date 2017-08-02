---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell
  - ruby
  - python
  - javascript

toc_footers:
  - <a href='#'>Sign Up for a Developer Key</a>
  - <a href='https://github.com/tripit/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduction

Getting Started

Welcome to the Patreon Platform! Get familiar with the Patreon platform products and tools using the tutorials and references below.

Please note: almost all of this documentation is geared towards software developers. If any of it is confusing, please contact us at [platform@patreon.com](mailto:platform@patreon.com)

# API Libraries
We've written some open source libraries to help you use our platform services.
<aside class="notice">
All of the libraries listed below require that you [register a client application](#clients-and-api-keys) and get API keys.
</aside>


## Javascript
```javascript
import url from 'url'
import patreonAPI, { oauth as patreonOAuth } from 'patreon'

const CLIENT_ID = 'pppp'
const CLIENT_SECRET = 'pppp'
const patreonOAuthClient = patreonOAuth(CLIENT_ID, CLIENT_SECRET)

const redirectURL = 'http://mypatreonapp.com/oauth/redirect'

```
Available on [npm](https://www.npmjs.com/package/patreon)

### Install
`npm install --save patreon`

View the source on [github](https://github.com/Patreon/patreon-js)

## PHP
Available on [packagist](https://packagist.org/packages/patreon/patreon)

### Install
`composer require patreon/patreon`

View the source on [github](https://github.com/Patreon/patreon-php)

## Java
Get the artifact from  [Maven](http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22com.patreon%22%20AND%20a%3A%22patreon%22)

```
    <dependency>
        <groupId>com.patreon</groupId>
        <artifactId>patreon</artifactId>
        <version>0.0.3</version>
    </dependency>
```

View the source on [github](https://github.com/Patreon/patreon-java)

## Ruby
Get the gem from  [RubyGems](https://rubygems.org/gems/patreon)

### Install
`gem install patreon`

View the source on [github](https://github.com/Patreon/patreon-ruby)

## Python

Get the egg from [PyPI](https://pypi.python.org/pypi/patreon), typically via pip:

### Install
`pip install patreon`

or

`echo "patreon" >> requirements.txt`

`pip install -r requirements.txt`

Make sure that, however you install patreon, you install its dependencies as well

View the source on [github](https://github.com/Patreon/patreon-python)

# Clients and API Keys
In order to interact with the Patreon API, you have to register your application with the Patreon platform

[Register your application here](https://www.patreon.com/platform/documentation/clients)
<aside class="warning">
Note: Please never reveal your client_secrets. If the secret is compromised, the attacker could get access to your campaign info, all of your patron’s profile info, email addresses, and their pledge amounts  If you fear your secret has been compromised, please let us know and we will look into granting you a new id & secret pair.
</aside>

# Authentication

> To authorize, use this code:

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
```

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
```

> Make sure to replace `meowmeowmeow` with your API key.

Kittn uses API keys to allow access to the API. You can register a new Kittn API key at our [developer portal](http://example.com/developers).

Kittn expects for the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: meowmeowmeow`

<aside class="notice">
You must replace <code>meowmeowmeow</code> with your personal API key.
</aside>

# OAuth
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
Patreon is building an OAuth provider service — the technology that lets you log in to Medium with Twitter, log in to Disqus with Google+, and even log in to Patreon with Facebook. Below, you’ll find a technical process document that explains how to begin integrating with us. This document assumes technical competency in HTTP protocols and URL structure, and administrative access & developer control of the server that you wish to integrate with Patreon.

## Step 1 - Registering Your Client
To set up, you must first register your client application with us. Please visit the [Clients & API Keys](https://www.patreon.com/platform/documentation/clients) page to register one.
## Step 2 - Making the Log In Button
Once your client is registered, you should create a “Log in with Patreon” and/or “Link your Patreon account” button on your site which directs users to the following URL:

### HTTP Request
`GET www.patreon.com/oauth2/authorize?response_type=code&client_id=<your client id>&redirect_uri=<one of your redirect_uris that you provided in step 1>&scope=<optional list of requested scopes>&state=<optional string>`

Parameter | Description
--------- | -----------
scope | This optional parameter will default to `users pledges-to-me my-campaign`, which fetches user profile information, pledges to your creator, and your creator info.
state | This optional parameter will be transparently appended as a query parameter when redirecting to your `redirect_uri`. This should be used as CSRF, and can be used as session/user identification as well. E.g. `https://www.patreon.com/oauth2/authorize?response_type=code&client_id=123&redirect_uri=https://www.mysite.com/custom-uri&state=their_session_id`. On this page, users will be asked if they wish to grant your client access to their account info. When they grant or deny access, __they will be redirected to the provided redirect_uri (so long as it is pre-registered with us)__.

## Step 3 - Handling OAuth Redirect

When the link in [Step 2](#step-2-making-the-log-in-button) redirects to the provided `redirect_uri`, e.g. https://www.mysite.com/custom-uri, it will bring extra HTTP query parameters as follows (assuming the user granted your client access):
`GET https://www.mysite.com/custom-uri
	?code=<single use code>
	&state=<string>`

## Step 4 - Validating Receipt of the OAuth Token
Your server should handle GET requests in [Step 3](#step-3-handling-oauth-redirect) by performing (on the server, not as a redirect):

`POST api.patreon.com/oauth2/token
	?code=<single use code, as passed in to GET route [2]>
	&grant_type=authorization_code
	&client_id=<your client id>
	&client_secret=<your client secret>
	&redirect_uri=<redirect_uri>`

which will return a JSON response of:
`{
	"access_token": <single use token>,
	"refresh_token": <single use token>,
	"expires_in": <token lifetime duration>,
	"scope": <token scopes>,
	"token_type": "Bearer"
}`
to be stored on your server, one pair per user.
## Step 5 - Using the OAuth Token
You may use the received access_token to make [API](#api) calls. For example, a typical first usage of the new `access_token` would be to [fetch the user's profile info](#fetch-your-own-profile-and-campaign-info), and either merge that into their existing account on your site, or make a new account for them. You could then use their pledge level to you to show or hide certain parts of your site.
## Step 6 - Resolving the OAuth Redirect
To reiterate, steps 3 and 4 should be performed by your server (synchronously or asynchronously) in response to receiving the GET request in step 2. Once your calls are complete, you will have the user’s profile info and pledge level for your creator.

If [3] and [4] were performed synchronously, then you can return a HTTP 302 for their GET [2], redirecting to a page with appropriate success dialogs & profile information. If [3] and [4] are being performed asynchronously, your response to GET [2] should probably contain AJAX code that will notify the user once [3] and [4] are completed.
## Step 7 - Keeping up to date
Tokens are valid for up to one month after they are issued. During this period, you may refresh a user’s information using the API calls from step 4. If you wish to get up-to-date information after the token has expired, a new token may be issued to be used for the following month. To refresh a token,

`POST api.patreon.com/oauth2/token
	?grant_type=refresh_token
	&refresh_token=<the user‘s refresh_token>
	&client_id=<your client id>
	&client_secret=<your client secret>`

which will return a JSON response of:

`{
	"access_token": <single use token>,
	"refresh_token": <single use token>,
	"expires_in": <token lifetime duration>,
	"scope": <token scopes>,
	"token_type": "Bearer"
}`
and you should store this information just as before.

# Examples

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

- Fetching your own profile and campaign info
- Paging through a list of pledges to you
- Fetching a patron's profile info

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

# Webhooks

## Get All Kittens

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
[
  {
    "id": 1,
    "name": "Fluffums",
    "breed": "calico",
    "fluffiness": 6,
    "cuteness": 7
  },
  {
    "id": 2,
    "name": "Max",
    "breed": "unknown",
    "fluffiness": 5,
    "cuteness": 10
  }
]
```

This endpoint retrieves all kittens.

### HTTP Request

`GET http://example.com/api/kittens`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
include_cats | false | If set to true, the result will also include cats.
available | true | If set to false, the result will include kittens that have already been adopted.

<aside class="success">
Remember — a happy kitten is an authenticated kitten!
</aside>

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
