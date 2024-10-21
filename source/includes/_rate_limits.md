# Rate Limits

Patreon implements rate limiting to enhance the security and reliability of its services. Requests are limited by client (6,000 requests per minute) and by token (100 requests per minute). Please note that refreshing a token will not reset the rate limits.

Rate limits are subject to change, and applications should handle HTTP 429 responses gracefully.