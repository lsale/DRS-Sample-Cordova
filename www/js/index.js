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

/* 
*   Modify below here
*/

// Dash specific variables
var serialNumber = "X000000001"; // The device serial number. This must be unique and must be retrieved when app connects to the smart device.
var deviceModel = "Coffee_Machine_X1"; // The device Modeal ID from your DRS Developer Console
var includeAllMarketplaces = true; // This must be set to false for production. It will show all the unreleased marketplaces that have not been certified yet
var isTestDevice = true; // This must be set to false for production. Purchases placed by this device will be test only


//Page specific variables
var productName = "coffee"; // This will customise the product name at the top of the page
var skipUri = null; // This will show the "Skip" button if set. It must be a URL
var learnMoreUri = null; // This will show the "Learn more" button if set. It must be a URL

/**
* Don't modify below
*/
var app = {
    // Application Constructor
    initialize: function() {
        if(productName){
            document.getElementById("productName").innerHTML = productName;
        }
        if(skipUri){
            var button = document.getElementById("skipUri");
            button.style.display = "block";
            button.addEventListener("click", function () {
                window.location.href = skipUri;
            })
        }
        if(learnMoreUri){
            var button = document.getElementById("learnMoreUri");
            button.style.display = "block";
            window.location.href = learnMoreUri;
        }
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        console.log('Received Event: ' + id);
        if(id === "deviceready"){
            document.getElementById("getStarted").addEventListener('click', lwa.authorize);    
        }
    }
};

var lwa = {
    authorize: function(){
        console.log("Starting LwA authorization");
        var drsScope = 'dash:replenish';
        var scopeData = new Object();
        scopeData[drsScope] = {
            device_model: deviceModel,
            serial: serialNumber,
            should_include_non_live: includeAllMarketplaces,
            is_test_device: isTestDevice
        };
        var options = {
            scope: drsScope,
            scope_data: scopeData
        };
        window.LoginWithAmazon.authorize(options, function(success){
            console.log(JSON.stringify(success));
        }, function(error){
            console.log(JSON.stringify(error));
        })
    }
}

app.initialize();
