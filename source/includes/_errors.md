# Errors

The Patreon API uses the following error codes:


Error Code | Meaning
---------- | -------
400 | Bad Request -- Something was wrong with your request (syntax, size too large, etc.)
401 | Unauthorized -- Authentication failed (bad API key, invalid OAuth token, incorrect scopes, etc.)
403 | Forbidden -- The requested is hidden for administrators only.
404 | Not Found -- The specified resource could not be found.
405 | Method Not Allowed -- You tried to access a resource with an invalid method.
406 | Not Acceptable -- You requested a format that isn't json.
410 | Gone -- The resource requested has been removed from our servers.
429 | Too Many Requests -- Slow down!
500 | Internal Server Error -- Our server ran into a problem while processing this request. Please try again later.
503 | Service Unavailable -- We're temporarily offline for maintenance. Please try again later.
