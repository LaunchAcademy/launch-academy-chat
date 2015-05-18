* Define the common HTTP verbs
  - GET - retrieve a resource
  - POST - create a resource
  - PUT/PATCH - update a resource
  - DELETE - remove a resource

* Retrieve and create messages

```
# telnet

telnet http://launch-academy-chat.herokuapp.com 80

GET /messages HTTP/1.1
Host: launch-academy-chat.herokuapp.com

POST /messages?content=posting-from-telnet HTTP/1.1
Host: launch-academy-chat.herokuapp.com
```

```
# curl

# get /messages
curl http://launch-academy-chat.herokuapp.com/messages

# post message
curl -d "content=posting-from-curl" http://launch-academy-chat.herokuapp.com/messages
```

```
# ruby

require "net/http"

# get /messages
result = Net::HTTP.get("launch-academy-chat.herokuapp.com", "/messages")

# post message
uri = URI("http://launch-academy-chat.herokuapp.com/messages")
result = Net::HTTP.post_form(uri, "content" => "posting from Ruby!")
```
