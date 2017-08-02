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
