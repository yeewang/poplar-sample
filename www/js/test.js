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

exports.defineAutoTests = function() {
    describe('Poplar Information (window.poplar)', function () {
             it("should exist", function() {
                expect(window.poplar).toBeDefined();
                });
             
             it("should contain a platform specification that is a string", function() {
                expect(window.poplar.platform).toBeDefined();
                expect((new String(window.poplar.platform)).length > 0).toBe(true);
                });
             
             it("should contain a version specification that is a string", function() {
                expect(window.poplar.version).toBeDefined();
                expect((new String(window.poplar.version)).length > 0).toBe(true);
                });
             
             it("should contain a UUID specification that is a string or a number", function() {
                expect(window.poplar.uuid).toBeDefined();
                if (typeof window.poplar.uuid == 'string' || typeof window.poplar.uuid == 'object') {
                expect((new String(window.poplar.uuid)).length > 0).toBe(true);
                } else {
                expect(window.poplar.uuid > 0).toBe(true);
                }
                });
             
             it("should contain a cordova specification that is a string", function() {
                expect(window.poplar.cordova).toBeDefined();
                expect((new String(window.poplar.cordova)).length > 0).toBe(true);
                });
             
             it("should depend on the presence of cordova.version string", function() {
                expect(window.cordova.version).toBeDefined();
                expect((new String(window.cordova.version)).length > 0).toBe(true);
                });
             
             it("should contain poplar.cordova equal to cordova.version", function() {
                expect(window.poplar.cordova).toBe(window.cordova.version);
                });
             
             it("should contain a model specification that is a string", function() {
                expect(window.poplar.model).toBeDefined();
                expect((new String(window.poplar.model)).length > 0).toBe(true);
                });
             
             it("should contain a manufacturer property that is a string", function() {
                expect(window.poplar.manufacturer).toBeDefined();
                expect((new String(window.poplar.manufacturer)).length > 0).toBe(true);
                });
             
             it("should contain an isVirtual property that is a boolean", function() {
                expect(window.poplar.isVirtual).toBeDefined();
                expect(typeof window.poplar.isVirtual).toBe("boolean");
                });
             
             it("should contain a serial number specification that is a string", function() {
                expect(window.poplar.serial).toBeDefined();
                expect((new String(window.poplar.serial)).length > 0).toBe(true);
                
                });
             
             });
};

exports.defineManualTests = function(contentEl, createActionButton) {
    var logMessage = function (message, color) {
        var log = document.getElementById('info');
        var logLine = document.createElement('div');
        if (color) {
            logLine.style.color = color;
        }
        logLine.innerHTML = message;
        log.appendChild(logLine);
    }
    
    var clearLog = function () {
        var log = document.getElementById('info');
        log.innerHTML = '';
    }
    
    var poplar_tests = '<h3>Press Dump Poplar button to get poplar information</h3>' +
    '<div id="dump_poplar"></div>' +
    'Expected result: Status box will get updated with poplar info. (i.e. platform, version, uuid, model, etc)';
    
    contentEl.innerHTML = '<div id="info"></div>' + poplar_tests;
    
    createActionButton('Dump poplar', function() {
                       clearLog();
                       logMessage(JSON.stringify(window.poplar, null, '\t'));
                       }, "dump_poplar");
};

exports.defineAutoTests();
