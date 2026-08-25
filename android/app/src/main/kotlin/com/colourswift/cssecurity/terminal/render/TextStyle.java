/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.colourswift.cssecurity.terminal.render;

public final class TextStyle {
    public static final int fxNormal = 0;
    public static final int fxBold = 1;
    public static final int fxItalic = 1 << 1;
    public static final int fxUnderline = 1 << 2;
    public static final int fxBlink = 1 << 3;
    public static final int fxInverse = 1 << 4;
    public static final int fxInvisible = 1 << 5;

    public static final int ciForeground = 256;
    public static final int ciBackground = 257;
    public static final int ciCursorForeground = 258;
    public static final int ciCursorBackground = 259;
    public static final int ciColorLength = ciCursorBackground + 1;

    public static final int kNormalTextStyle = encode(ciForeground, ciBackground, fxNormal);

    public static int encode(int foreColor, int backColor, int effect) {
        return ((effect & 0x3f) << 18) | ((foreColor & 0x1ff) << 9) | (backColor & 0x1ff);
    }

    public static int decodeForeColor(int encodedColor) {
        return (encodedColor >> 9) & 0x1ff;
    }

    public static int decodeBackColor(int encodedColor) {
        return encodedColor & 0x1ff;
    }

    public static int decodeEffect(int encodedColor) {
        return (encodedColor >> 18) & 0x3f;
    }

    private TextStyle() {
        throw new UnsupportedOperationException();
    }
}
