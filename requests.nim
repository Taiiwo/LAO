import httpclient
import tables
import typetraits

# define requests as a new type
type Requests* = ref object of RootObj

# define requests' methods
method get(self: Requests, url: string): string {. base .}=
  return url.getContent()

method post(self: Requests, url: string, data: array[0..0, (string, string)]): string {. base .}=
  var query = ""
  for index, arr in data.pairs:
    query = query & arr[0] & "=" & arr[1] & "&"
  return url.postContent(body=query)

var requests: Requests

var a = {"url": "http://google.com/"}
echo(requests.post("http://xn--yet.tk/api/mk", a))
