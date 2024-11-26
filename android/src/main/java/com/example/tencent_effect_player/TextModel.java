package com.example.tencent_effect_player;

/**
 * @author hqg
 * @description:
 * @date : 2024/11/20 14:36
 */
public class TextModel {

    public String text;
    public String textColor;
    public int alignment;//对齐方式
    public boolean isBold;

    public TextModel(String text, String textColor, int alignment, boolean isBold) {
        this.text = text;
        this.textColor = textColor;
        this.alignment = alignment;
        this.isBold = isBold;
    }
}
