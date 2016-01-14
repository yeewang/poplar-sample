/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');

        var success = function(message) {
            document.write("<font size=5>Result:</font>" + message + "<br>");
        }

        var failure = function() {
            alert("Error calling Poplar Plugin");
        }
        
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
                poplar.open(success, failure, 'GET', 'http://192.168.1.200:800/test_deferred_return.call?delay=10', true);
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
            failure);

        // String method;
        // String url;
        // boolean async;
        // String username; String password;
        poplar.open(success, failure, 'GET', 'http://192.168.1.200:800/test_deferred_return.call?delay=30', true);
        //poplar.open(success, failure, 'GET', 'http://192.168.1.200:800/test_close.call', true);
        //poplar.open(success, failure, 'GET', 'http://www.163.com/', true);
        poplar.setRequestHeader(success, failure, "x-allow", "demo-xml");
        poplar.setTimeout(success, failure, 60);
        poplar.send(success, failure);
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

app.initialize();
