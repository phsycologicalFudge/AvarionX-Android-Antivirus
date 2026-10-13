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

package com.colourswift.cssecurity.terminal.emulator;

import com.colourswift.cssecurity.terminal.util.GrowableIntArray;

public interface Screen {
    void setLineWrap(int row);
    void set(int x, int y, int codePoint, int style);
    void set(int x, int y, byte b, int style);
    void scroll(int topMargin, int bottomMargin, int style);
    void blockCopy(int sx, int sy, int w, int h, int dx, int dy);
    void blockSet(int sx, int sy, int w, int h, int val, int style);
    String getTranscriptText();
    String getTranscriptText(GrowableIntArray colors);
    String getSelectedText(int x1, int y1, int x2, int y2);
    String getSelectedText(GrowableIntArray colors, int x1, int y1, int x2, int y2);
    int getActiveRows();
    boolean fastResize(int columns, int rows, int[] cursor);
    void resize(int columns, int rows, int style);
}
