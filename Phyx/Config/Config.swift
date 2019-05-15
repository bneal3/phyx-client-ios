//
//  Config.swift
//  stat
//
//  Created by Benjamin Neal on 10/14/17.
//  Copyright © 2017 Benjamin Neal. All rights reserved.
//

import Foundation

// NOTE: Config variables have _ in front of them

// Enumeration of environment states
enum Environment : Int {
    case lan = 0 // for local staging
    case production // for final production
}

// Returns environment variable based on saved key
var _env : Environment {
    return Environment.production
}

// Returns backend url based on the environment variable
var API_URL: String {
    switch _env {
    case Environment.production: // Connects to standard environment
        return "https://phyx-api-production.herokuapp.com"
    case Environment.lan: // Connects to local server
        return "http://192.168.1.8:4000"
    }
}

var PN_PUBLISH_KEY: String {
    switch _env {
    case Environment.production: // Connects to standard environment
        return "pub-c-2ceda1c9-49a6-4798-a6d9-dfdfd186bc03"
    case Environment.lan: // Connects to local server
        return "pub-c-7b2f9fb3-2ded-4686-af6f-7cbf59b09ded"
    }
}

var PN_SUBSCRIBER_KEY: String {
    switch _env {
    case Environment.production: // Connects to standard environment
        return "sub-c-4fa1d0ce-0886-11e9-82f7-5edfbb0294f1"
    case Environment.lan: // Connects to local server
        return "sub-c-a062bf16-4060-11e9-a3da-7e1c7e0df66c"
    }
}

var FS_STORAGE_PATH: String {
    switch _env {
    case Environment.production: // Connects to standard environment
        return "production"
    case Environment.lan: // Connects to local server
        return "lan"
    }
}

var FS_STORAGE_PASSWORD: String {
    switch _env {
    case Environment.production: // Connects to standard environment
        return "#6yhT~9(Q*tW=G'"
    case Environment.lan: // Connects to local server
        return "fbpassword"
    }
}

var STRIPE_SUB_KEY: String {
    switch _env {
    case Environment.production: // Connects to standard environment
        return "pk_live_06qpxfkSCktDbSVF3nnlqRz400hYrEsXTX"
    case Environment.lan: // Connects to local server
        return "pk_test_SxtOsZ8xPn4zmPmwXtvI3J6d00yG7FEvOG"
    }
}
