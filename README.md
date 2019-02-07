# DRS Teaser Page Sample for Cordova
Installing and running the DRS Teaser Page Sample for Cordova requires as little as 5 minutes.

## 1. Requirements
To run this sample on iOS and Android, using the Cordova Plugin for Dash, you will need to have Xcode and the Android SDK installed locally.
To customize this project for your smart device you will need an Amazon Developer account. Create one or sign into an existing one at [developer.amazon.com](https://developer.amazon.com/home.html)

## 2. Installing the sample (2 mins)
1. Clone the repository locally `git clone https://github.com/lsale/DRS-Sample-Cordova.git`
2. Go into the newly cloned directory `cd DRS-Sample-Cordova` and run `npm install`


## 3. Adding Native support for iOS and Android
### Adding Android support (1 to 10 mins)
**Requirement**: Android SDK must be available locally. Download it from the [Android website](https://developer.android.com/studio/).
1. Add the Android platform: `cordova platform add android`

For help configuring the Android SDK with Cordova please refer to the [official documentation](https://cordova.apache.org/docs/en/latest/guide/platforms/android/index.html)

### Adding iOS support (1 to 10 mins)
**Requirement**: Xcode must be installed. Download it from the Mac App Store.
1. Add the iOS platform: `cordova platform add ios`

## 4. Installing the Cordova Plugin for Dash (1 to 5 mins)
The [cordova-plugin-login-with-amazon](https://github.com/lsale/cordova-plugin-login-with-amazon-dash.git) provides you with access to the Login with Amazon Mobile SDK and Single-Sign-On functionality for customers who have the Amazon Shopping app installed (i.e. they won't need to type their username and password). 

### (Custom) Installing the plugin in a custom project (5 min installation)
In the terminal, cd to your Cordova project directory and type `cordova plugin add https://github.com/lsale/cordova-plugin-login-with-amazon --variable IOS_API_KEY=<KEY> --variable IOS_BUNDLE_NAME=<PACKAGE_NAME>`
Where:
* `API_KEY` is the iOS API Key 
* `BUNDLE_NAME` is the iOS bundle name (ex. com.myproject.myapp)

Instructions to customize the installation with your own API key and package name are available on the [plugin github page](https://github.com/lsale/cordova-plugin-login-with-amazon-dash.git).

### (Quick) Installing the plugin with sample credentials (1 min installation)
#### 1. Install using the sample API credentials
If you haven't created an API key yet, and you just want to test out the sample, feel free to use the sample credentials and install the plugin as follows:
* `cordova plugin add https://github.com/lsale/cordova-plugin-login-with-amazon --variable IOS_API_KEY=eyJhbGciOiJSU0EtU0hBMjU2IiwidmVyIjoiMSJ9.eyJ2ZXIiOiIzIiwiZW5kcG9pbnRzIjp7ImF1dGh6IjoiaHR0cHM6Ly93d3cuYW1hem9uLmNvbS9hcC9vYSIsInRva2VuRXhjaGFuZ2UiOiJodHRwczovL2FwaS5hbWF6b24uY29tL2F1dGgvbzIvdG9rZW4ifSwiY2xpZW50SWQiOiJhbXpuMS5hcHBsaWNhdGlvbi1vYTItY2xpZW50LmQ0MWQ2OWYxZGJiNTQ2MThhNzNlM2MwN2E1MDc0ZjNlIiwiYXBwRmFtaWx5SWQiOiJhbXpuMS5hcHBsaWNhdGlvbi5kYzQ4MWZmZGQ3OTM0NjY2YjBkNTdkYWExMGJiOTdlOCIsImJ1bmRsZVNlZWRJZCI6ImNvbS5hbWF6b24uZHJzLmRyc3RlYXNlcnBhZ2UiLCJidW5kbGVJZCI6ImNvbS5hbWF6b24uZHJzLmRyc3RlYXNlcnBhZ2UiLCJpc3MiOiJBbWF6b24iLCJ0eXBlIjoiQVBJS2V5IiwiYXBwVmFyaWFudElkIjoiYW16bjEuYXBwbGljYXRpb24tY2xpZW50LmViODZjMWE1MWIwYzRkOWE4ODM4NTE0NDg4OWQ4ZTA2IiwidHJ1c3RQb29sIjpudWxsLCJhcHBJZCI6ImFtem4xLmFwcGxpY2F0aW9uLWNsaWVudC5lYjg2YzFhNTFiMGM0ZDlhODgzODUxNDQ4ODlkOGUwNiIsImlkIjoiMTE3ZjMwYjMtZmZiZC0xMWU4LWI5OTItMTk4ZGQ5MTM3ZTRjIiwiaWF0IjoiMTU0NDgwNDgxNDIzMSJ9.jntLNSctn0/zOkFoeIEkoMPbcMSfUD2U6snrf0qsAljaG70HfvFgPa8VSIrMfhtEc1jzMWUuJW1M3ZM8mSC2B0RR3YBiu4K6mVdbZAeUaAjdUBFJmJAsfa9T+OixM+Fh6Bn/TYVPro4/DMFLzMv3rv4URifdIu+kpMwgQHYCJ8G7rFWLwfgPaCoNys0ADOz6iu3Yv++nU8xTnm8e3ekXvnA0RiXDa36cE2D+UeUw5yBlm4zyY54QmXnMwUc9nmcxPOUTOosiZh8CNokzsOShanisrZscBbwqy7W5eJOEyF3tIPYq4FeG234gJ754TTzksC6jwxhCBB6uMyRrQgROgA== --variable IOS_BUNDLE_NAME=com.amazon.drs.drsteaserpage`

#### 2. (Android only) - Add the API Key in your Android project
Move the entire `MYPROJECT/extras/assets` directory to `MYPROJECT/platforms/android/`
1. Run `mv extras/assets/api_key.txt platforms/android/app/src/main/assets/`

The api_key.txt file contained in it, uses sample credentials. Refer to the  "Customize the Cordova Sample" section if you wish to change it.

## 6. Running the DRS Teaser Page Sample for Cordova on your iOS and Android device
1. Prepare
	* (iOS) Run `cordova prepare ios`.
	* (Android) Run `cordova prepare android`.
2. Build
	* (iOS) Run `cordova build ios`
	* (Android) Run `cordova build android --buildConfig=extras/build.json`
3. Run on a simulator or a real device 
	* `cordova run <PLATFORM>` for example, `cordova emulate android` to run on your Android simulator.


## Customize the Cordova Sample
You can customize the sample by editing the `PROJECT_DIRECTORY/www/js/index.js` file with your deviceModel from your [DRS console](https://developer.amazon.com/dash-replenishment/drs_console.html) and the serial number that you will read from the DRS-enabled device.

**Important**: if you customize the deviceModel or change the package/bundle name, you will have to generate your own API Key from your [Security Profile](https://developer.amazon.com/loginwithamazon/console/site/lwa/overview.html) and update:
* (iOS) APIKey entry in the iOS .plist file
* (Android) api_key.txt file 
