package com.example.Filmshape;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import com.google.api.services.youtube.YouTubeScopes;
import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Objects;

public class SecondActivity extends AppCompatActivity {
//	public static final String YOUTUBE = "https://www.googleapis.com/auth/youtube";
//
//	private static String CLIENT_ID = "133713896762-tlqi918vc9h7jpes9e6kagpa6ra51774.apps.googleusercontent.com";
//
//	//Use your own client id
//	//Use your own client secret
//	private static String REDIRECT_URI="http://localhost";
//	private static String GRANT_TYPE="authorization_code";
//	private static String TOKEN_URL ="https://accounts.google.com/o/oauth2/token";
//	private static String OAUTH_URL ="https://accounts.google.com/o/oauth2/auth";
//	private static String OAUTH_SCOPE= YouTubeScopes.YOUTUBE;
//	private ProgressDialog pDialog;
//	public static final String USER_AGENT_FAKE = "Mozilla/5.0 (Linux; Android 4.1.1; Galaxy Nexus Build/JRO03C) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19";

	public static final String YOUTUBE = "https://www.googleapis.com/auth/youtube";

	//private static String CLIENT_ID = "17231235286-ub7j7od293buriu0272re3aj55e8kgh4.apps.googleusercontent.com";
	private static String CLIENT_ID = "275810026068-b6mlh0j979q5tic19ph950b1ilqbccbs.apps.googleusercontent.com";
	//Use your own client id
//Use your own client secret
	private static String REDIRECT_URI="http://localhost";
	private static String GRANT_TYPE="authorization_code";
	private static String TOKEN_URL ="https://accounts.google.com/o/oauth2/token";
	private static String OAUTH_URL ="https://accounts.google.com/o/oauth2/auth";
	private static String OAUTH_SCOPE= YouTubeScopes.YOUTUBE;
	private ProgressDialog pDialog;
	public static final String USER_AGENT_FAKE = "Mozilla/5.0 (Linux; Android 4.1.1; Galaxy Nexus Build/JRO03C) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19";



	//Change the Scope as you need
	WebView web;
	Button auth;
	SharedPreferences pref;


	@Override
	public boolean onSupportNavigateUp() {
		onBackPressed();
		return true;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);
		Objects.requireNonNull(getSupportActionBar()).setDisplayHomeAsUpEnabled(true);

		pref = getSharedPreferences("AppPref", MODE_PRIVATE);
		web = (WebView)findViewById(R.id.webv);


		web.getSettings().setJavaScriptEnabled(true);
		web.getSettings().setUserAgentString(System.getProperty("http.agent"));
		web.loadUrl(OAUTH_URL+"?redirect_uri="+REDIRECT_URI+"&response_type=code&client_id="+CLIENT_ID+"&scope="+OAUTH_SCOPE);
		web.setWebViewClient(new WebViewClient() {

			boolean authComplete = false;
			Intent resultIntent = new Intent();

			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon){
				super.onPageStarted(view, url, favicon);

			}
			String authCode;
			@Override
			public void onPageFinished(WebView view, String url) {
				super.onPageFinished(view, url);

				if (url.contains("?code=") && authComplete != true) {
					Uri uri = Uri.parse(url);
					authCode = uri.getQueryParameter("code");
					Log.i("", "CODE : " + authCode);
					authComplete = true;
					resultIntent.putExtra("code", authCode);
					SecondActivity.this.setResult(Activity.RESULT_OK, resultIntent);
					setResult(Activity.RESULT_CANCELED, resultIntent);

					SharedPreferences.Editor edit = pref.edit();
					edit.putString("Code", authCode);
					edit.commit();
					new TokenGet().execute();
					//Toast.makeText(getApplicationContext(),"Authorization Code is: " +authCode, Toast.LENGTH_SHORT).show();
				}else if(url.contains("error=access_denied")){
					Log.i("", "ACCESS_DENIED_HERE");
					resultIntent.putExtra("code", authCode);
					authComplete = true;
					setResult(Activity.RESULT_CANCELED, resultIntent);
					Toast.makeText(getApplicationContext(), "Error Occured", Toast.LENGTH_SHORT).show();
					Intent intent=new Intent();
					setResult(3,intent);
					finish();

				}
			}
		});


	}



	 @SuppressLint("StaticFieldLeak")
	 private class TokenGet extends AsyncTask<String, String, JSONObject> {

	        String Code;
	       @Override
	       protected void onPreExecute() {
	           super.onPreExecute();
	           pDialog = new ProgressDialog(SecondActivity.this);
	           pDialog.setMessage("Contacting Google ...");
	           pDialog.setIndeterminate(false);
	           pDialog.setCancelable(true);
	           Code = pref.getString("Code", "");
	           pDialog.show();
	       }

	       @Override
	       protected JSONObject doInBackground(String... args) {
	           GetAccessToken jParser = new GetAccessToken();
	           JSONObject json = jParser.gettoken(TOKEN_URL,Code,CLIENT_ID,REDIRECT_URI,GRANT_TYPE);
			   Log.d("json", new Gson().toJson(json));
	           return json;
	       }

	        @Override
	        protected void onPostExecute(JSONObject json) {
	            pDialog.dismiss();
	            if (json != null){

				       try {

				    	String tok = json.getString("access_token");
						String expire = json.getString("expires_in");
						String refresh = json.getString("refresh_token");

						   Intent intent=new Intent();
						   intent.putExtra("token",tok);
						   intent.putExtra("refresh",refresh);
						   setResult(2,intent);
						   finish();

					       Log.d("Token Access", tok);
					       Log.d("Expire", expire);
					       Log.d("Refresh", refresh);
					} catch (JSONException e) {
						// TODO Auto-generated catch block

						   Intent intent=new Intent();
						   setResult(3,intent);
						   finish();

						e.printStackTrace();
					}

	            	    }else{



				       pDialog.dismiss();
					Intent intent=new Intent();
					setResult(3,intent);
					finish();

				}
	        }
	   }


	@Override
	public void onDestroy() {
		super.onDestroy();
		if (pDialog != null) {
			pDialog.dismiss();
			pDialog = null;
		}
	}

}