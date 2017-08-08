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

<code>echo "patreon" >> requirements.txt<br>
pip install -r requirements.txt</code>

Make sure that, however you install patreon, you install its dependencies as well

View the source on [github](https://github.com/Patreon/patreon-python)

#Third Party Libraries
There are a number of third party libraries that the developer community has created. If you would like to add yours to this  list, please email [platform@patreon.com](mailto:platform@patreon.com)

##Go
View the source on [github](https://github.com/mxpv/patreon-go)

##.NET
View the source on [github](https://github.com/shiftos-game/Patreon.NET)
