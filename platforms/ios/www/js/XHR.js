
var XHR = {
    /*
     State
     0 Uninitialized
     This is the initial state. The XMLHttpRequest object has just been created or has been reset with the abort( ) method.
     1 Open
     The open( ) method has been called, but send( ) has not. The request has not yet been sent
     2 Sent The send( ) method has been called, and the HTTP request has been transmitted to the web server. No response has been received yet.
     3 Receiving
     All response headers have been received. The response body is being received but is not complete.
     4Loaded
     The HTTP response has been fully received.
     */
    readonly short readyState,
    readonly String responseText,
    readonly Document responseXML,
    readonly short status,
    readonly String statusText,
    
    abort: void function() {
        Cordova.exec(null, null, "MyPlugin", "abort");
    },

    getAllResponseHeaders: String function() {
        Cordova.exec(null, null, "MyPlugin", "getAllResponseHeaders");
        return "";
    },
        
    getResponseHeader: String function(String header) {
        Cordova.exec(null, null, "MyPlugin", "getResponseHeader", header);
        return "";
    },

    open: void function(String method,
                        String url,
                        boolean async,
                        String username,
                        String password) {
        Cordova.exec(null, null, "MyPlugin", "open", method, url, async, username, password);
    },

    send: void function(Object body) {
        Cordova.exec(null, null, "MyPlugin", "send", body);
    },
        
    setRequestHeader: void function(String name, String value) {
        Cordova.exec(null, null, "MyPlugin", "setRequestHeader", name, value);
    },
    
    // event
    function onreadystatechange;
};

function createXHR() {
    return new XHR();
};
