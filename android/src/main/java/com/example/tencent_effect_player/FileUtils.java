package com.example.tencent_effect_player;

import android.content.Context;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * @author hqg
 * @description:
 * @date : 2024/11/19 11:57
 */
public class FileUtils {

    /**
     * 检查缓存目录中是否已存在文件，如果不存在则复制 assets 文件到缓存目录
     *
     * @param context   上下文
     * @param assetPath assets 文件的相对路径
     * @return 缓存文件的绝对路径
     */
    public static String copyAssetToStorage(Context context, String assetPath) {
        try {
            // 定义缓存目录中的目标文件路径
            File cacheFile = new File(context.getCacheDir(), assetPath);
            if (cacheFile.exists()) {
                // 如果文件已存在，直接返回路径
                return cacheFile.getAbsolutePath();
            }

            // 确保目标文件的目录存在
            if (!cacheFile.getParentFile().exists()) {
                cacheFile.getParentFile().mkdirs();
            }

            // 从 assets 中读取文件
            InputStream inputStream = context.getAssets().open(assetPath);
            FileOutputStream outputStream = new FileOutputStream(cacheFile);

            // 复制文件内容
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inputStream.read(buffer)) > 0) {
                outputStream.write(buffer, 0, length);
            }

            // 关闭流
            inputStream.close();
            outputStream.close();

            // 返回缓存文件路径
            return cacheFile.getAbsolutePath();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 将 URL 转换为合法的文件名
    public static String hashKeyForDisk(String key) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(key.getBytes());
            byte[] digest = md.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return String.valueOf(key.hashCode());
        }
    }

}
