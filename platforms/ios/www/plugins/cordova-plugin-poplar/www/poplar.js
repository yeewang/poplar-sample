cordova.define("cordova-plugin-poplar.poplar", function(require, exports, module) { /*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

var argscheck = require('cordova/argscheck'),
    channel = require('cordova/channel'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec'),
    cordova = require('cordova');

channel.createSticky('onCordovaInfoReady');
// Tell cordova channel to wait on the CordovaInfoReady event
channel.waitForInitialization('onCordovaInfoReady');

/**
 * @constructor
 */
function Poplar() {
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
    this.available = false;
    this.readyState = 0;
    this.responseText = null;
    this.responseXML = null;
    this.status = 0;
    this.statusText = null;

    var me = this;

    channel.onCordovaReady.subscribe(function() {
        me.getInfo(function(info) {
            //ignoring info.cordova returning from native, we should use value from cordova.version defined in cordova.js
            //TODO: CB-5105 native implementations should not return info.cordova
            var buildLabel = cordova.version;
            me.available = true;            
            me.readyState = info.readyState;
            me.responseText = info.responseText;
            me.responseXML = info.responseXML;
            me.status = info.status;
            me.statusText = info.statusText;
            channel.onCordovaInfoReady.fire();
        },function(e) {
            me.available = false;
            utils.alert("[ERROR] Error initializing Cordova: " + e);
        });
    });
               
    /*
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
*/
}

Poplar.prototype.getInfo = function(successCallback, errorCallback) {
    argscheck.checkArgs('fF', 'Poplar.getInfo', arguments);
    exec(successCallback, errorCallback, "Poplar", "getPoplarInfo");
};
               
Poplar.prototype.abort = function(successCallback, errorCallback) {
    argscheck.checkArgs('fF', 'Poplar.abort', arguments);
    exec(successCallback, errorCallback, "Poplar", "abort");
};

Poplar.prototype.getAllResponseHeaders = function(successCallback, errorCallback) {
    argscheck.checkArgs('fF', 'Poplar.getAllResponseHeaders', arguments);
    exec(successCallback, errorCallback, "Poplar", "getAllResponseHeaders");
};
               
Poplar.prototype.getResponseHeader = function(successCallback, errorCallback, header) {
    argscheck.checkArgs('fF', 'Poplar.getResponseHeader', arguments);
    exec(successCallback, errorCallback, "Poplar", "getResponseHeader", [header]);
};

Poplar.prototype.open = function(successCallback, errorCallback, method, url, async, username, password) {
    // Parameter list:
    // String method,
    // String url,
    // boolean async,
    // String username, String password

    if (!errorCallback) { errorCallback = function() {}; }
    
    if (typeof errorCallback !== 'function')  {
        console.log('Poplar.prototype.open failure: failure parameter not a function');
        return;
    }
    
    if (typeof successCallback !== 'function') {
        console.log('Poplar.prototype.open failure: success callback parameter must be a function');
        return;
    }
    
    var that = this;
    var cleanHandlersAndPassThrough = function() {
        if (!options) {
            that._handlers = {
                'registration': [],
                'notification': [],
                'error': []
            };
        }
        successCallback();
    };
    
    argscheck.checkArgs('fF', 'Poplar.open', arguments);
    options = {'method': method, 'url': url, 'async': async, 'username': username,  'password': password};
    exec(successCallback, errorCallback, "Poplar", "open", [options]);
};

Poplar.prototype.send = function(successCallback, errorCallback, options) {
    argscheck.checkArgs('fF', 'Poplar.send', arguments);
    exec(successCallback, errorCallback, "Poplar", "send", [options]);
};

Poplar.prototype.setRequestHeader = function(successCallback, errorCallback, name, value) {
    argscheck.checkArgs('fF', 'Poplar.setRequestHeader', arguments);
    options = {'name' :name, 'value': value};
    exec(successCallback, errorCallback, "Poplar", "setRequestHeader", [options]);
};

module.exports = new Poplar();

});
