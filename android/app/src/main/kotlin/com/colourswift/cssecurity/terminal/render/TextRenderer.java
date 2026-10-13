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

import android.graphics.Canvas;

public interface TextRenderer {
    int MODE_OFF = 0;
    int MODE_ON = 1;
    int MODE_LOCKED = 2;
    int MODE_MASK = 3;

    int MODE_SHIFT_SHIFT = 0;
    int MODE_ALT_SHIFT = 2;
    int MODE_CTRL_SHIFT = 4;
    int MODE_FN_SHIFT = 6;

    void setReverseVideo(boolean reverseVideo);
    float getCharacterWidth();
    int getCharacterHeight();
    int getTopMargin();
    void drawTextRun(Canvas canvas, float x, float y,
            int lineOffset, int runWidth, char[] text,
            int index, int count, boolean selectionStyle, int textStyle,
            int cursorOffset, int cursorIndex, int cursorIncr, int cursorWidth, int cursorMode);
}
