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

public class GrowableIntArray {
    public GrowableIntArray(int initialCapacity) {
        mData = new int[initialCapacity];
        mLength = 0;
    }

    public void append(int i) {
        if (mLength + 1 > mData.length) {
            int newLength = Math.max((mData.length * 3) >> 1, 16);
            int[] temp = new int[newLength];
            System.arraycopy(mData, 0, temp, 0, mLength);
            mData = temp;
        }
        mData[mLength++] = i;
    }

    public int length() {
        return mLength;
    }

    public int at(int index) {
        return mData[index];
    }

    int[] mData;
    int mLength;
}
