/**
 */
package com.education;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import android.util.Log;

import com.amazon.identity.auth.device.AuthError;
import com.amazon.identity.auth.device.api.Listener;
import com.amazon.identity.auth.device.api.authorization.AuthCancellation;
import com.amazon.identity.auth.device.api.authorization.AuthorizationManager;
import com.amazon.identity.auth.device.api.authorization.AuthorizeListener;
import com.amazon.identity.auth.device.api.authorization.AuthorizeRequest;
import com.amazon.identity.auth.device.api.authorization.AuthorizeResult;
import com.amazon.identity.auth.device.api.authorization.ProfileScope;
import com.amazon.identity.auth.device.api.authorization.Scope;
import com.amazon.identity.auth.device.api.authorization.ScopeFactory;
import com.amazon.identity.auth.device.api.authorization.User;
import com.amazon.identity.auth.device.api.workflow.RequestContext;


public class AmazonLoginPlugin extends CordovaPlugin {
    private static final String TAG = "AmazonLoginPlugin";

    private static final String ACTION_AUTHORIZE = "authorize";
    private static final String ACTION_FETCH_USER_PROFILE = "fetchUserProfile";
    private static final String ACTION_GET_TOKEN = "getToken";
    private static final String ACTION_SIGNOUT = "signOut";


    private static final String FIELD_ACCESS_TOKEN = "accessToken";
    private static final String FIELD_AUTHORIZATION_CODE = "authorizationCode";
    private static final String FIELD_USER = "user";
    private static final String FIELD_CLIENT_ID = "clientId";
    private static final String FIELD_REDIRECT_URI = "redirectURI";

    //Temporary. This needs to be generated as per 
    private static final String CODE_CHALLENGE = "F62BB66E-49B3-4B4A-86D6-0EE196F088BD-0EE196F088BD";
    private static final String CODE_CHALLENGE_METHOD = "plain";

    private RequestContext requestContext;
    private CallbackContext savedCallbackContext;


    public void initialize(final CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        requestContext = RequestContext.create(cordova.getActivity());
        requestContext.registerListener(new AuthorizeListener() {

            @Override
            public void onSuccess(AuthorizeResult result) {
                Log.d(TAG, "Authorization was completed successfully.");
                /* Your app is now authorized for the requested scopes */
                sendAuthorizeResult(result);
            }

            @Override
            public void onError(AuthError ae) {
                Log.d(TAG, "There was an error during the attempt to authorize the application.");
            /* Inform the user of the error */
                savedCallbackContext.error("Trouble during the attempt to authorize the application");
            }

            @Override
            public void onCancel(AuthCancellation cancellation) {
                Log.d(TAG, "Authorization was cancelled before it could be completed. ");
            /* Reset the UI to a ready-to-login state */
                savedCallbackContext.error("Authorization was cancelled before it could be completed.");
            }
        });

        Log.d(TAG, "Initializing AmazonLoginPlugin");
    }

    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {


        this.savedCallbackContext = callbackContext;

        if (ACTION_AUTHORIZE.equals(action)) {
            Log.i(TAG, "Authorization started");
            final Scope scope = getScope(args);

            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    AuthorizationManager.authorize(
                        new AuthorizeRequest.Builder(requestContext)
                                .addScopes(scope)
                                .forGrantType(AuthorizeRequest.GrantType.AUTHORIZATION_CODE)
                                // Set your code challenge and code challenge method - "plain" or "S256".
                                .withProofKeyParameters(CODE_CHALLENGE, CODE_CHALLENGE_METHOD)
                                .build()
                    );
                }
            });
        } else if (ACTION_FETCH_USER_PROFILE.equals(action)) {
            Log.i(TAG, "User Profile fetching started");
            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    User.fetch(cordova.getActivity(), new Listener<User, AuthError>() {

                        /* fetch completed successfully. */
                        @Override
                        public void onSuccess(User user) {
                            sendUserResult(user);
                        }

                        /* There was an error during the attempt to get the profile. */
                        @Override
                        public void onError(AuthError ae) {
                            savedCallbackContext.error("Trouble obtaining the profile");
                        }
                    });
                }
            });

        } else if (ACTION_GET_TOKEN.equals(action)) {
            Log.i(TAG, "Get token started");

            //TODO add an option to pass scopes
            final Scope[] scopes = {ProfileScope.profile(), ProfileScope.postalCode()};

            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    AuthorizationManager.getToken(cordova.getActivity(), scopes, new Listener<AuthorizeResult, AuthError>() {

                        @Override
                        public void onSuccess(AuthorizeResult result) {
                            if (result.getAccessToken() != null) {
                        /* The user is signed in */
                                sendAuthorizeResult(result);
                            } else {
                                savedCallbackContext.error("The user is not signed in");
                            }
                        }

                        @Override
                        public void onError(AuthError ae) {
                    /* The user is not signed in */
                            savedCallbackContext.error("The user is not signed in");

                        }
                    });
                }
            });
        } else if (ACTION_SIGNOUT.equals(action)) {
            Log.i(TAG, "Signout started");
            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    AuthorizationManager.signOut(cordova.getActivity().getApplicationContext(), new Listener<Void, AuthError>() {
                        @Override
                        public void onSuccess(Void response) {
                            // Set logged out state in UI
                            savedCallbackContext.success("The user is signed out");
                        }

                        @Override
                        public void onError(AuthError authError) {
                            // Log the error
                            savedCallbackContext.error("The user is not signed out");
                        }
                    });
                }
            });
        } else {
            Log.i(TAG, "Action " + action + "doesn't exist");
            return false;
        }
        return true;
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
        requestContext.onResume();
    }

    private Scope getScope(JSONArray data) {
        try{
            JSONObject params = data.getJSONObject(0);
            JSONObject param = params.getJSONObject("scope_data").getJSONObject("dash:replenish");
            Log.v(TAG, param.toString());
            final String scopeDataString = "{\"device_model\":\"" + param.getString("device_model") +
                    "\", \"serial\":\"" + param.getString("serial") +
                    "\", \"is_test_device\":\"" + param.getString("is_test_device") +
                    "\", \"should_include_non_live\":\"" + param.getString("should_include_non_live") +
                    "\"}";
            JSONObject scopeData;
            try {
                scopeData = new JSONObject(scopeDataString);
                return ScopeFactory.scopeNamed("dash:replenish", scopeData);
            } catch (JSONException e) {
                Log.e(TAG, "Error during scope data JSON object creation", e);
            }
            return null;
        }catch (JSONException e){
            Log.e(TAG, e.toString());
            return null;
        }
    }

    private void sendAuthorizeResult(AuthorizeResult result) {

        if (savedCallbackContext == null) {
            return;
        }
        JSONObject authResult = new JSONObject();
        try {
            authResult.put(FIELD_AUTHORIZATION_CODE, result.getAuthorizationCode());
            authResult.put(FIELD_CLIENT_ID, result.getClientId());
            authResult.put(FIELD_REDIRECT_URI, result.getRedirectURI());
            savedCallbackContext.success(authResult);
        } catch (Exception e) {
            savedCallbackContext.error("Trouble obtaining Authorize Result, error: " + e.getMessage());
        }
    }

    private void sendUserResult(User user) {
        if (savedCallbackContext == null) {
            return;
        }
        try {
            savedCallbackContext.success(new JSONObject(user.getUserInfo()));
        } catch (Exception e) {
            savedCallbackContext.error("Trouble obtaining user, error: " + e.getMessage());
        }
    }
}