package com.example.tencent_effect_player;

import android.content.Context;
import android.util.Log;

import com.jakewharton.disklrucache.DiskLruCache;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class AnimationCacheManager {
    private static final String TAG = "AnimationCacheManager";

    private DiskLruCache diskLruCache;
    // 缓存目录名称
    private static final String CACHE_DIR = "effect_cache";
    private File cacheDir;
    // 单例模式
    private static AnimationCacheManager instance;

    public static AnimationCacheManager getInstance() {
        if (instance == null) {
            instance = new AnimationCacheManager();
        }
        return instance;
    }

    private AnimationCacheManager() {

    }

    public void initDiskCache(Context context) {
        try {
            // 初始化 DiskLruCache
            cacheDir = new File(context.getCacheDir(), CACHE_DIR);
            if (!cacheDir.exists()) {
                cacheDir.mkdirs();
            }
            int appVersion = 1; // 应用版本号
            int valueCount = 1; // 每个缓存项保存一个文件
            long maxSize = 50 * 1024 * 1024; // 缓存大小限制：50MB
            diskLruCache = DiskLruCache.open(cacheDir, appVersion, valueCount, maxSize);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取动画资源缓存路径
     *
     * @param resourceUrl 动画资源的 URL
     * @return 缓存文件路径
     */
    public void getAnimationResource(String resourceUrl, LoadListener listener) {
        try {
            String key = hashKeyForDisk(resourceUrl); // 对 URL 进行哈希生成唯一键
            DiskLruCache.Snapshot snapshot = diskLruCache.get(key);

            if (snapshot != null) {
                // 缓存已存在，直接返回路径
                String filePath = cacheDir.getAbsolutePath() + "/" + FileUtils.hashKeyForDisk(resourceUrl);
                File file = getCacheFile(filePath);
                if (file.exists()) {
                    Log.d(TAG, "资源已缓存，路径：" + filePath);
                } else {
                    copySnapshotToFile(snapshot, filePath);
                    Log.d(TAG, "复制资源已缓存，路径：" + filePath);
                }
                if (listener != null) {
                    listener.loadComplete(filePath);
                }
            } else {
                new Thread(() -> {
                    // 缓存不存在，下载资源并保存到缓存
                    downloadAndCacheResource(resourceUrl, key, listener);
                }).start();

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 获取缓存文件路径
    private File getCacheFile(String url) {
        // 使用 URL 的哈希值作为文件名
        String fileName = hashKeyForDisk(url);
        return new File(cacheDir, fileName);
    }

    private String copySnapshotToFile(DiskLruCache.Snapshot snapshot, String destinationPath) {
        InputStream inputStream = null;
        FileOutputStream outputStream = null;
        try {
            inputStream = snapshot.getInputStream(0);
            File destinationFile = new File(destinationPath);
            outputStream = new FileOutputStream(destinationFile);

            byte[] buffer = new byte[1024];
            int length;
            while ((length = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, length);
            }
            outputStream.flush();
            return destinationFile.getAbsolutePath();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (inputStream != null) inputStream.close();
                if (outputStream != null) outputStream.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    private void downloadAndCacheResource(String resourceUrl, String key, LoadListener listener) {
        DiskLruCache.Editor editor = null;
        try {
            editor = diskLruCache.edit(key);
            if (editor != null) {
                // 使用 OutputStream 而不是 FileOutputStream
                OutputStream outputStream = editor.newOutputStream(0);

                // 下载资源并写入 OutputStream
                if (downloadResource(resourceUrl, outputStream)) {
                    editor.commit(); // 提交更改
                    diskLruCache.flush();

                    // 获取缓存文件路径
                    DiskLruCache.Snapshot snapshot = diskLruCache.get(key);
                    if (snapshot != null) {
                        File cacheFile = new File(diskLruCache.getDirectory(), key + ".0");
                        Log.d(TAG, "资源已下载并缓存，路径：" + cacheFile.getAbsolutePath());
                        if (listener != null) {
                            listener.loadComplete(cacheFile.getAbsolutePath());
                        }
                    }

                } else {
                    editor.abort(); // 下载失败，撤销编辑
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (editor != null) {
                try {
                    editor.abort();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    /**
     * 下载资源到输出流
     *
     * @param resourceUrl  资源 URL
     * @param outputStream 输出流
     * @return 下载是否成功
     */
    private boolean downloadResource(String resourceUrl, OutputStream outputStream) {
        HttpURLConnection connection = null;
        InputStream inputStream = null;
        try {
            URL url = new URL(resourceUrl);
            connection = (HttpURLConnection) url.openConnection();
            connection.connect();

            if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                inputStream = connection.getInputStream();
                byte[] buffer = new byte[1024];
                int length;
                while ((length = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, length);
                }
                outputStream.flush();
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (inputStream != null) inputStream.close();
                if (outputStream != null) outputStream.close();
                if (connection != null) connection.disconnect();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    /**
     * 将字符串转换为哈希键
     *
     * @param key 原始字符串
     * @return 哈希键
     */
    private String hashKeyForDisk(String key) {
        return String.valueOf(key.hashCode());
    }

    public interface LoadListener {
        void loadComplete(String path);
    }
}
