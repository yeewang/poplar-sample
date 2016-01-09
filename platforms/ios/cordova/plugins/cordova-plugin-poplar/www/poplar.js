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
    this.responseText = "";
    this.responseXML = "";
    this.status = 0;
    this.statusText = "200";    

    this.platform = null;
    this.version = null;
    this.uuid = null;
    this.cordova = null;
    this.model = null;
    this.manufacturer = null;
    this.isVirtual = null;
    this.serial = null;

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
            
            me.platform = info.platform;
            me.version = info.version;
            me.uuid = info.uuid;
            me.cordova = buildLabel;
            me.model = info.model;
            me.isVirtual = info.isVirtual;
            me.manufacturer = info.manufacturer || 'unknown';
            me.serial = info.serial || 'unknown';
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

/**
 * Get poplar info
 *
 * @param {Function} successCallback The function to call when the heading data is available
 * @param {Function} errorCallback The function to call when there is an error getting the heading data. (OPTIONAL)
 */
Poplar.prototype.getInfo = function(successCallback, errorCallback) {
    argscheck.checkArgs('fF', 'Poplar.getInfo', arguments);
    exec(successCallback, errorCallback, "Poplar", "getPoplarInfo", []);
};

module.exports = new Poplar();
