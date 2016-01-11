/*
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
    this.available = false;
    this.onreadystatechange = null;    
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
}

Poplar.prototype.getInfo = function(successCallback, errorCallback) {
    if (!errorCallback) { errorCallback = function() {}; }
    
    if (typeof errorCallback !== 'function')  {
        console.log('Poplar.prototype.open failure: failure parameter not a function');
        return;
    }
    
    if (typeof successCallback !== 'function') {
        console.log('Poplar.prototype.open failure: success callback parameter must be a function');
        return;
    }
    
    argscheck.checkArgs('fF', 'Poplar.getInfo', arguments);
    exec(successCallback, errorCallback, "Poplar", "getPoplarInfo");
};
               
Poplar.prototype.abort = function(successCallback, errorCallback) {
    if (!errorCallback) { errorCallback = function() {}; }
    
    if (typeof errorCallback !== 'function')  {
        console.log('Poplar.prototype.open failure: failure parameter not a function');
        return;
    }
    
    if (typeof successCallback !== 'function') {
        console.log('Poplar.prototype.open failure: success callback parameter must be a function');
        return;
    }
    
    argscheck.checkArgs('fF', 'Poplar.abort', arguments);
    exec(successCallback, errorCallback, "Poplar", "abort");
};

Poplar.prototype.getAllResponseHeaders = function(successCallback, errorCallback) {
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
    
    argscheck.checkArgs('fF', 'Poplar.getAllResponseHeaders', arguments);
    exec(cleanHandlersAndPassThrough, errorCallback, "Poplar", "getAllResponseHeaders");
};
               
Poplar.prototype.getResponseHeader = function(successCallback, errorCallback, header) {
    if (!errorCallback) { errorCallback = function() {}; }
    
    if (typeof errorCallback !== 'function')  {
        console.log('Poplar.prototype.open failure: failure parameter not a function');
        return;
    }
    
    if (typeof successCallback !== 'function') {
        console.log('Poplar.prototype.open failure: success callback parameter must be a function');
        return;
    }
    
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
    exec(cleanHandlersAndPassThrough, errorCallback, "Poplar", "open", [options]);
};

Poplar.prototype.send = function(successCallback, errorCallback, options) {
    if (!errorCallback) { errorCallback = function() {}; }
    
    if (typeof errorCallback !== 'function')  {
        console.log('Poplar.prototype.open failure: failure parameter not a function');
        return;
    }
    
    if (typeof successCallback !== 'function') {
        console.log('Poplar.prototype.open failure: success callback parameter must be a function');
        return;
    }
    
    argscheck.checkArgs('fF', 'Poplar.send', arguments);
    exec(successCallback, errorCallback, "Poplar", "send", [options]);
};

Poplar.prototype.setRequestHeader = function(successCallback, errorCallback, name, value) {
    if (!errorCallback) { errorCallback = function() {}; }
    
    if (typeof errorCallback !== 'function')  {
        console.log('Poplar.prototype.open failure: failure parameter not a function');
        return;
    }
    
    if (typeof successCallback !== 'function') {
        console.log('Poplar.prototype.open failure: success callback parameter must be a function');
        return;
    }
    
    argscheck.checkArgs('fF', 'Poplar.setRequestHeader', arguments);
    options = {'name' :name, 'value': value};
    exec(successCallback, errorCallback, "Poplar", "setRequestHeader", [options]);
};

module.exports = new Poplar();
