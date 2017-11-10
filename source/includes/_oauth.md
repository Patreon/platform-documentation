# OAuth

Patreon has an <a href="https://oauth.net/" target="_blank">OAuth</a> provider service — the technology that lets you log in to Medium with Twitter, log in to Disqus with Google+, and even login to Patreon with Facebook.

Below, you’ll find steps explaining how to begin integrating with us. It assumes understanding in HTTP protocol and OAuth, and that you have administrative access & developer control of the server that you wish to integrate with Patreon.

<aside class="notice">
Here are some helpful resources regarding these technologies:

<a href="https://code.tutsplus.com/tutorials/http-the-protocol-every-web-developer-must-know-part-1--net-31177" target="_blank">HTTP the Protocol Every Web Developer Must Know</a> and
<a href="https://www.digitalocean.com/community/tutorials/an-introduction-to-oauth-2" target="_blank">An Introduction to OAuth 2</a>
</aside>

<aside class="notice">
Looking to dive in to the <a href="#api">API</a>? You can use your <strong>Creator's Access Token</strong> you get when registering a Client in place of the token you'd get back from the OAuth flow to start exploring the different endpoints or building a single creator application or tool.
</aside>

## Step 1 - Registering Your Client

To set up OAuth, you will need to register your client application on the [Clients & API Keys](https://www.patreon.com/portal/registration/register-clients) page.
## Step 2 - Making the Log In Button
> Request [2]

```
GET www.patreon.com/oauth2/authorize
	?response_type=code
	&client_id=<your client id>
	&redirect_uri=<one of your redirect_uris that you provided in step 0>
	&scope=<optional list of requested scopes>
	&state=<optional string>

```


Once your client is registered, you should create a “Log in with Patreon” and/or “Link your Patreon account” button on your site which directs users to the following URL:

### HTTP Request
`GET www.patreon.com/oauth2/authorize`

### Query Parameters
Parameter | Description
--------- | -----------
response_type **_Required_** | OAuth grant type. Set this to `code`.
client_id **_Required_** |   Your client id
redirect_uri **_Required_** | One of your `redirect_uri`s that you provided in step 1
scope | This optional parameter will default to `users pledges-to-me my-campaign`, which fetches user profile information, pledges to your creator, and your creator info. It will be displayed to the user in human-friendly terms when signing in with Patreon. If your client requires the ability to ask for pledges or campaign data of **other users** (not just your own campaign), please email [platform@patreon.com](mailto:platform@patreon.com), and we'll do our best to get back to you shortly.
state | This optional parameter will be transparently appended as a query parameter when redirecting to your `redirect_uri`. This should be used as [CSRF](https://medium.com/@charithra/introduction-to-csrf-a329badfca49), and can be used as session/user identification as well. E.g. `https://www.patreon.com/oauth2/authorize?response_type=code&client_id=123&redirect_uri=https://www.mysite.com/custom-uri&state=their_session_id`. On this page, users will be asked if they wish to grant your client access to their account info. When they grant or deny access, __they will be redirected to the provided redirect_uri (so long as it is pre-registered with us)__.

## Step 3 - Handling OAuth Redirect
> Request [3]

```
GET https://www.mysite.com/custom-uri
    ?code=<single use code>
    &state=<string>
```
When the link in [Step 2](#step-2-making-the-log-in-button) redirects to the provided `redirect_uri`, e.g. https://www.mysite.com/custom-uri, it will bring extra HTTP query parameters as follows (assuming the user granted your client access):

### Query Parameters
Parameter | Description
--------- | -----------
code | Used to fetch access tokens for the session that just signed in with Patreon.
state | Trasnparently appended from the state param you provided in your initial link in Step 2.

## Step 4 - Validating Receipt of the OAuth Token

> Request [4]

```
POST www.patreon.com/api/oauth2/token
	?code=<single use code, as passed in to GET route [2]>
	&grant_type=authorization_code
	&client_id=<your client id>
	&client_secret=<your client secret>
	&redirect_uri=<redirect_uri>
```

Your server should handle GET requests in [Step 3](#step-3-handling-oauth-redirect) by performing the following request on the server (not as a redirect):

> which will return a JSON response of:

```json
{
	"access_token": <single use token>,
	"refresh_token": <single use token>,
	"expires_in": <token lifetime duration>,
	"scope": <token scopes>,
	"token_type": "Bearer"
}
```
>to be stored on your server, one pair per user.

<aside class="notice">
Remember! - this step happens on your server. Our <a href="#api-libraries">API Libraries</a> typically handle this step for you or if you want to see examples of this step in other programming languages.
</aside>

## Step 5 - Using the OAuth Token
You may use the received `access_token` to make [API](#api) calls. For example, a typical first usage of the new `access_token` would be to [fetch the user's profile info](#fetch-your-own-profile-and-campaign-info), and either merge that into their existing account on your site, or make a new account for them. You could then use their pledge level to show or hide certain parts of your site.

<aside class="notice">Remember! - this step happens on your server.</aside>

## Step 6 - Resolving the OAuth Redirect
To reiterate, requests [4] and [5] should be performed by your server (synchronously or asynchronously) in response to receiving the GET request in request [3].

Once your calls are complete, you will have the user’s profile info and pledge level for your creator.

If requests [4] and [5] were performed synchronously, then you can return a HTTP 302 for their GET in request [3], redirecting to a page with appropriate success dialogs & profile information. If the requests in requests [4] and [5] are being performed asynchronously, your response to request [3] should probably contain AJAX code that will notify the user once requests [4] and [5] are completed.
## Step 7 - Keeping up to date
```php
<?php
require_once('vendor/patreon/patreon/src/patreon.php');
use Patreon\API;
use Patreon\OAuth;
// Get your current "Creator's Access Token" from https://www.patreon.com/portal/registration/register-clients
$access_token = null;
// Get your "Creator's Refesh Token" from https://www.patreon.com/portal/registration/register-clients
$refresh_token = null;
$api_client = new Patreon\API($access_token);

// If the token doesn't work, get a newer one
if ($campaign_response['errors']) {
    // Make an OAuth client
    // Get your Client ID and Secret from https://www.patreon.com/portal/registration/register-clients
    $client_id = null;
    $client_secret = null;
    $oauth_client = new Patreon\OAuth($client_id, $client_secret);
    // Get a fresher access token
    $tokens = $oauth_client->refresh_token($refresh_token, null);
    if ($tokens['access_token']) {
        $access_token = $tokens['access_token'];
        echo "Got a new access_token! Please overwrite the old one in this script with: " . $access_token . " and try again.";
    } else {
        echo "Can't recover from access failure\n";
        print_r($tokens);
    }
    return;
}
?>
```
> Request [7]

```
POST www.patreon.com/api/oauth2/token
	?grant_type=refresh_token
	&refresh_token=<the user‘s refresh_token>
	&client_id=<your client id>
	&client_secret=<your client secret>
```

> which will return a JSON response of:

```json
{
	"access_token": <single use token>,
	"refresh_token": <single use token>,
	"expires_in": <token lifetime duration>,
	"scope": <token scopes>,
	"token_type": "Bearer"
}
```
> and you should store this information just as before.

Tokens are valid for up to one month after they are issued. During this period, you may refresh a user’s information using the API calls from step 4. If you wish to get up-to-date information after the token has expired, a new token may be issued to be used for the following month. To refresh a token, make a POST request to the token endpoint with a grant type of `refresh_token`, as in the example. You may also manually refresh the token on the appropriate client in your [clients page](https://www.patreon.com/portal/registration/register-clients).
