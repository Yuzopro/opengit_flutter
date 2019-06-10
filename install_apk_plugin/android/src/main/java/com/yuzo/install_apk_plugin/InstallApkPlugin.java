package com.yuzo.install_apk_plugin;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.core.content.FileProvider;

import java.io.File;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * InstallApkPlugin
 */
public class InstallApkPlugin implements MethodCallHandler {
    private static final String TAG = "InstallApkPlugin";

    private final Registrar registrar;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "install_apk_plugin");
        channel.setMethodCallHandler(new InstallApkPlugin(registrar));
    }

    private InstallApkPlugin(Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("installApk")) {
            final String path = (String) call.arguments;
            Log.d(TAG, "installApk path is " + path);
            File file = new File(path);
            installApk(file, registrar.context());
        } else {
            result.notImplemented();
        }
    }

    private void installApk(File apkFile, Context context) {
        Intent installApkIntent = new Intent();
        installApkIntent.setAction(Intent.ACTION_VIEW);
        installApkIntent.addCategory(Intent.CATEGORY_DEFAULT);
        installApkIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        Uri apkUri = null;
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) {
            apkUri = FileProvider.getUriForFile(context, context.getPackageName() + ".fileprovider", apkFile);
            installApkIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        } else {
            apkUri = Uri.fromFile(apkFile);
        }
        installApkIntent.setDataAndType(apkUri, "application/vnd.android.package-archive");

        if (context.getPackageManager().queryIntentActivities(installApkIntent, 0).size() > 0) {
            context.startActivity(installApkIntent);
        }
    }
}
