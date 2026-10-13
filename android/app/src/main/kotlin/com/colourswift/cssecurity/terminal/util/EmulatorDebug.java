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

package com.colourswift.cssecurity.terminal.util;

public class EmulatorDebug {
    public static final boolean DEBUG = false;
    public static final boolean LOG_IME = DEBUG & false;
    public static final boolean LOG_CHARACTERS_FLAG = DEBUG & false;
    public static final boolean LOG_UNKNOWN_ESCAPE_SEQUENCES = DEBUG & false;
    public static final String LOG_TAG = "AXTerminal";

    public static String bytesToString(byte[] data, int base, int length) {
        StringBuilder buf = new StringBuilder();
        for (int i = 0; i < length; i++) {
            byte b = data[base + i];
            if (b < 32 || b > 126) {
                buf.append(String.format("\\x%02x", b));
            } else {
                buf.append((char) b);
            }
        }
        return buf.toString();
    }
}
