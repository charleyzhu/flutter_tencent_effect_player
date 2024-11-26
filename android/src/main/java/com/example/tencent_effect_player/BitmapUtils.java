package com.example.tencent_effect_player;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * @author hqg
 * @description:
 * @date : 2024/11/20 14:55
 */
public class BitmapUtils {

    public static Bitmap getBitmapFromLocalPath(String imagePath) {
        Bitmap bitmap = BitmapFactory.decodeFile(imagePath);
        return bitmap;
    }

    /**
     * 从 Flutter 的 assets 转为 Bitmap 对象
     *
     * @param assetManager AssetManager 对象
     * @param assetPath    assets 文件相对路径，例如 "assets/images/sample.png"
     * @return Bitmap 对象
     */
    public static Bitmap getBitmapFromAssets(AssetManager assetManager, String assetPath) {
        InputStream inputStream = null;
        try {
            // 打开资源文件的输入流
            inputStream = assetManager.open(assetPath);
            // 使用 BitmapFactory 将流转换为 Bitmap
            return BitmapFactory.decodeStream(inputStream);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static Bitmap getBitmapFromUrl(String imageUrl) {
        Bitmap bitmap = null;
        try {
            URL url = new URL(imageUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setDoInput(true);
            connection.connect();
            InputStream input = connection.getInputStream();
            bitmap = BitmapFactory.decodeStream(input);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return bitmap;
    }

}
