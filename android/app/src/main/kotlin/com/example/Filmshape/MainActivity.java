package com.example.Filmshape;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import java.util.HashMap;
import java.util.Objects;

import io.flutter.app.FlutterActivity;;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "flutter.native/helper";

    MethodChannel.Result results;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    results=result;
                    if (call.method.equals("helloFromNativeCode")) {
                        String greetings = "called";

                        Intent intent=new Intent(this,SecondActivity.class);
                            startActivityForResult(intent,101);

                    }
                });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(resultCode==2){

            if(data!=null){

                String token=data.getStringExtra("token");
                String refreshtoken=data.getStringExtra("refresh");
                Log.e("token Main", Objects.requireNonNull(token));
                Log.e("token Main refreshtoken", Objects.requireNonNull(refreshtoken));

                HashMap<String , Object> map = new HashMap<>();
                map.put("result", true);
                map.put("token", token);
                map.put("refresh", refreshtoken);
                results.success(map);
            }

        }
        else if(resultCode==3){


            HashMap<String , Object> map = new HashMap<>();
            map.put("result", false);
            results.success(map);
        }


    }
}
