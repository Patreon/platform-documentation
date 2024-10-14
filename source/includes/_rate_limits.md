# Rate Limits

To boost security and increase the reliability of the service we are using rate limits on the API. The current rate limits are as follows:

1 - 6000 calls / minute for any client_id
2 - 100 calls / minute for each client_id + user_id

The second one means that a client can make 100 calls / minute for each user that authorized that client. So with each unique token, you can make 100 calls / minute. Ie, token A for user A can make 100 calls / minute. Token B for user B also can make 100 calls / minute at the same time.

You should make sure that your app/integration can handle 429 responses from rate limiting and should keep track of what it was doing before it got the 429 response. This way it can retry when its quota for that client or token refreshes.