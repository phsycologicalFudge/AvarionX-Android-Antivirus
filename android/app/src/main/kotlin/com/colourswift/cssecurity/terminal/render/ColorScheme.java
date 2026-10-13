/*
 * Copyright (C) 2012 Steven Luo
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

public class ColorScheme {
    private int foreColor;
    private int backColor;
    private int cursorForeColor;
    private int cursorBackColor;
    private static final int sDefaultCursorBackColor = 0xff808080;

    private void setDefaultCursorColors() {
        cursorBackColor = sDefaultCursorBackColor;
        int foreDistance = distance(foreColor, cursorBackColor);
        int backDistance = distance(backColor, cursorBackColor);
        if (foreDistance * 2 >= backDistance) {
            cursorForeColor = foreColor;
        } else {
            cursorForeColor = backColor;
        }
    }

    private static int distance(int a, int b) {
        return channelDistance(a, b, 0) * 3 + channelDistance(a, b, 1) * 5 + channelDistance(a, b, 2);
    }

    private static int channelDistance(int a, int b, int channel) {
        return Math.abs(getChannel(a, channel) - getChannel(b, channel));
    }

    private static int getChannel(int color, int channel) {
        return 0xff & (color >> ((2 - channel) * 8));
    }

    public ColorScheme(int foreColor, int backColor) {
        this.foreColor = foreColor;
        this.backColor = backColor;
        setDefaultCursorColors();
    }

    public ColorScheme(int foreColor, int backColor, int cursorForeColor, int cursorBackColor) {
        this.foreColor = foreColor;
        this.backColor = backColor;
        this.cursorForeColor = cursorForeColor;
        this.cursorBackColor = cursorBackColor;
    }

    public ColorScheme(int[] scheme) {
        int schemeLength = scheme.length;
        if (schemeLength != 2 && schemeLength != 4) {
            throw new IllegalArgumentException();
        }
        this.foreColor = scheme[0];
        this.backColor = scheme[1];
        if (schemeLength == 2) {
            setDefaultCursorColors();
        } else {
            this.cursorForeColor = scheme[2];
            this.cursorBackColor = scheme[3];
        }
    }

    public int getForeColor() {
        return foreColor;
    }

    public int getBackColor() {
        return backColor;
    }

    public int getCursorForeColor() {
        return cursorForeColor;
    }

    public int getCursorBackColor() {
        return cursorBackColor;
    }
}
