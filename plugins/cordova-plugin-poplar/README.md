# cordova-plugin-poplar
Cordova-plugin-poplar is a custom push client for iOS in the cordova platform. 
It uses iOS VoIP background execution to wake up iOS devices, and send a notification to them. <br>
Cordova-plugin-poplar provides the XMLHttpRequest like API for easy to use.

# Getting started
### Checkout cordova-plugin-poplar source code to your local folder
> git clone https://github.com/yeewang/cordova-plugin-poplar.git cordova-plugin-poplar

### Install cordova-plugin-poplar plugin to your cordova project.
> plugman install --platform ios --project $MY_CORDOVA_PRROJECT/platforms/ios/ --plugin cordova-plugin-poplar

### Modify the project root html file to insert the following line:
    <script type="text/javascript" src="poplar.js"></script>

## Rebuild your cordova project.
> cordova build

# APIs
###Properties:
    poplar.readyState;
The state of the HTTP request. The meaning is the same as the readyState in the XMLHttpRequest. Please refer some XMLHttpRequest docs.
<table>
	<td>State</td><td>Name</td>
    <tr>
    <td>0</td><td>Uninitialized</td></tr>
    <td>1</td><td>Open</td></tr>
    <td>2</td><td>Sent</td></tr>
    <td>3</td><td>Receiving</td></tr>
    <td>4</td><td>Loaded</td></tr>
</table>
    poplar.responseText;
The body of the response. Please refer some XMLHttpRequest docs.
    
    poplar.responseXML;
The response to the request, parsed as XML. This property always returns null.

    poplar.status;
The HTTP request status code returned by the server. For example, 200 for success, 404 for "Not Found", -1 for request timeout, 0 for other errors.
    
    poplar.statusText;
The HTTP request status text returned by the server. For example, it is "OK" when status is 200, "Not Found" when status is 404, "Timeout" when status is -1, and other errors are "Unknown" when status is 0.
    
###Event:
    poplar.onreadystatechange
Event-handler function invoked each time the readyState property changes.

###Functions:
	poplar.abort(function success, function failure);
This method resets the XMLHttpRequest object to a readyState of 0 and aborts any pending network activity. 	

	poplar.getAllResponseHeaders(
	            function success(allResponseHeaders),
	            function failure);
	            
If readyState is less than 3, this method returns null. Otherwise, it returns all HTTP response headers.
	            
	poplar.getResponseHeader(
	            function success(responseHeaders),
	            function failure,
	            string headerText);
The value of the named HTTP response header, or the empty string if no such header was received or if readyState is less than 3.
	            
	poplar.setRequestHeader(function success, function failure, string name, string value);
setRequestHeader( ) specifies an HTTP request header that should be included in the request issued by a subsequent call to send( ). This method may be called only when readyState is 1, after a call to open( ) but before a call to send( ).	
    
    poplar.open(function success, function failure, method, url, async, username, password);
This method initializes request parameters for later use by the send( ) method. It sets readyState to 1, and clears all of state to default(Refer to XMLHttpRequest.open), except timeout(Refer to poplar.setTimeout()).
	
	poplar.send(function success, function failure);
This method causes an HTTP request to be issued. But if the readyState does not equal 1, it will do nothing.
	
	poplar.setTimeout(function success, function failure, integer timeout);
The method set the timeout value(The unit is in second) for the HTTP request. In HTTP requesting, if timeout time reached, but HTTP request doet not return, an abort action will trigger(Refer to "poplar.status" property).


# Usage examples
	
	poplar.onreadystatechange = function() {
	    var message = "<font size=5>onreadystatechange</font><br>";
	    message = message.concat(
	        "readyState:", poplar.readyState.toString(), "<br>",
	        "responseText:", poplar.responseText.toString(), "<br>",
	        "responseXML:", poplar.responseXML.toString(), "<br>",
	        "status:", poplar.status.toString(), "<br>",
	        "statusText:", poplar.statusText.toString(), "<br>");
	        
	    document.write(message);
	
	    if (poplar.readyState === 4) {
	        poplar.open(success, failure, 'GET', 'http://192.168.1.200:800/test_deferred_return.call?delay=30', true);
	        poplar.send(success, failure);
	    }
	};
	
	poplar.abort(success, failure);
	
	poplar.getAllResponseHeaders(
	    function(allResponseHeaders) {
	        },
	        failure);
	
	poplar.getResponseHeader(
	    function(responseHeaders) {
	        },
	        failure,
	        'header');
	
    poplar.open(success, failure, 'GET', 'http://192.168.1.200:800/test_deferred_return.call?delay=10', true);
    poplar.setRequestHeader(success, failure, "x-allow", "demo-xml");
    poplar.setTimeout(success, failure, 60);
    poplar.send(success, failure);

