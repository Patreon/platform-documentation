# Rate Limits

Patreon implements rate limiting to enhance the security and reliability of its services. Requests are limited by client (100 requests per 2 seconds) and by token (100 requests per minute). Please note that refreshing a token will not reset the rate limits.

Rate limits are subject to change, and applications should handle HTTP 429 responses gracefully.

Responses for rate limited requests may optionally include the following response object. Treat all attributes in the response as optional. Use the `retry_after_seconds` value to determine when the next request can be made.

```json
{
  "errors": [
    {
      "code": null,
      "code_name": "RequestThrottled",
      "detail": "You have made too many attempts. Please try again later.",
      "id": "eb96e70d-909f-40cc-a3dc-e922cc90ea0a",
      "retry_after_seconds": 9,
      "status": "429",
      "title": "You have made too many attempts. Please try again later."
    }
  ]
}
```