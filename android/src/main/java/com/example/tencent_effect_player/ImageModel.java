package com.example.tencent_effect_player;

/**
 * @author hqg
 * @description:
 * @date : 2024/11/20 14:17
 */
public class ImageModel {

    public String imageValue;

    public int imageType;//0本地图片1网络图片2assets图片

    public ImageModel(String imageValue, int imageType) {
        this.imageValue = imageValue;
        this.imageType = imageType;
    }
}
