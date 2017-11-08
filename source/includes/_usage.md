# Calling the API

## Requesting specific data

```shell
https://www.patreon.com/api/oauth2/api/campaigns/<campaign_id>/pledges?include=reward&fields[pledge]=total_historical_amount_cents,is_paused
```

To retrieve specific attributes or relationships other than the defaults, you can pass `fields` and `include` parameters respectively, each being comma-separated lists of attributes or resources.

<aside class="notice">
For more information on requesting specific data, the <a href="http://jsonapi.org/format/#fetching-includes">JSONAPI documentation</a> may be useful.
</aside>

## Pagination and sorting

```shell
https://www.patreon.com/api/oauth2/api/campaigns/<campaign_id>/pledges?page[count]=5&sort=-created&page[cursor]=2012-01-19
```

Our API endpoints support pagination and sorting on some attributes.

Parameter | Description
--------- | -----------
page[count] | Maximum number of results returned
sort | Comma-separated attributes to sort by, in order of precedence. Each attribute can be prepended with `-` to indicate descending order. Currently, we support `created` and `modified` for pledges.
page[cursor] | From the sorted results, start returning where the first attribute in `sort` equals this value.

The example URL on the right is for 5 pledges with max `created` before 2012-01-19, in reverse chronological order.

<aside class="notice">
For more information on sorting and pagination, the <a href="http://jsonapi.org/format/#fetching-sorting">JSONAPI documentation</a> may be useful.
</aside>

The `links` field of the response body contains URLs of first, prev, next, and last pages if they exist.
