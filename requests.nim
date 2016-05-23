import httpclient

# define requests as a new type
type Requests* = ref object of RootObj
type dict = array[0..0, (string, string)]

proc arr_to_query(arr: dict): string =
  var query = ""
  for index, arr in arr.pairs:
    query = query & arr[0] & "=" & arr[1] & "&"
  return query

# define requests' methods
method get(
    self: Requests,
    url: string,
    data: dict = {"":""}
    ) : string {. base .} =
  # if params are empty
  if data.len() == 1 and data[0][0] == "" and data[0][1] == "":
    return url.getContent()
  else:
    var full_url = url & "?" & arr_to_query(data)
    return full_url.getContent()

method post(
    self: Requests,
    url: string,
    data: dict = {"":""}
    ) : string {. base .} =
  # if params are empty
  if data.len() == 1 and data[0][0] == "" and data[0][1] == "":
    return url.postContent()
  else:
    return url.postContent(body=arr_to_query(data))

var requests: Requests

var a = {"url": "http://google.com/"}
echo(
  requests.post("http://httpbin.org/post", data=a)
)
