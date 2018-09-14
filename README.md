# DRS Cordova Sample
1. Clone the repository locally `git clone https://github.com/lsale/DRS-Sample-Cordova.git`
2. Go into the newly cloned directory `cd DRS-Sample-Cordova` and run `npm install`

# Adding iOS support
1. Ensure Xcode is installed and add the iOS platform `cordova platform add ios`
2. Add the [cordova-plugin-amazon-login](https://github.com/edu-com/cordova-plugin-amazon-login) to your project `cordova plugin add https://github.com/edu-com/cordova-plugin-amazon-login.git#v2.0.0 --variable IOS_API_KEY="your-key-here"`. Following all set-up instructions on the plugin github page.
3. Copy the content of `dash/ios/` to `platforms/ios/DRSTeaserPage/Plugins/cordova-plugin-amazon-login/`. You will want to overwrite the file.

# Finishing touches
1. Customise the `www/js/index.js` file with your clientId from the [Security Profile](https://developer.amazon.com/iba-sp/view.html), the deviceModel from your [DRS console](https://developer.amazon.com/dash-replenishment/drs_console.html) and the serial number that you will read from the DRS-enabled device.
2. Run `cordova prepare`
3. Run the app in the simulator.
