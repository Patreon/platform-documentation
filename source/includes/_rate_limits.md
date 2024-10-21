# Rate Limits

Patreon uses rate limiting to increase security and reliability of our services. Requests are rate limited by client (6000 requests per minute) and token (100 requests per minute). Note that refreshing a token will not reset rate limits.

Rate limits are subject to change, applications should handle HTTP 429 responses gracefully.