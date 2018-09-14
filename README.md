# DRS Cordova Sample
1. Clone the repository locally `git clone https://github.com/lsale/DRS-Sample-Cordova.git`
2. Go into the newly cloned directory `cd DRS-Sample-Cordova`
3. Ensure Xcode is installed and add the iOS platform `cordova platform add ios`
4. Add the [cordova-plugin-amazon-login](https://github.com/edu-com/cordova-plugin-amazon-login) to your project `cordova plugin add https://github.com/edu-com/cordova-plugin-amazon-login.git#v2.0.0 --variable IOS_API_KEY="your-key-here"`. The API key can be found under Security Profile in your [Amazon Developer Portal](https://developer.amazon.com/), you will need to add your app [bundle ID](https://developer.amazon.com/public/apis/engage/login-with-amazon/docs/create_ios_project.html) to get the correct API key.
5. Copy the content of `dash/ios/` to `platforms/ios/DRSTeaserPage/Plugins/cordova-plugin-amazon-login/`. You will want to overwrite the file.

Run the app in the simulator.

If you wish to change the Bundle ID to suit your app please ensure you update it in:
1. Your Security Profile on the Amazon Developer Portal](https://developer.amazon.com/)
2. the Info.plist file, under URL Types. [Full instructions](https://developer.amazon.com/public/apis/engage/login-with-amazon/docs/create_ios_project.html#add_url_scheme)
