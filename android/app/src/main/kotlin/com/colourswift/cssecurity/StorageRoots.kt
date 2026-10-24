package com.colourswift.cssecurity

import android.content.Context
import android.os.Build
import android.os.Environment
import android.os.storage.StorageManager

object StorageRoots {
    data class Root(val path: String, val removable: Boolean, val label: String?)

    private val mounted = setOf(Environment.MEDIA_MOUNTED, Environment.MEDIA_MOUNTED_READ_ONLY)

    fun list(context: Context): List<Root> {
        val roots = ArrayList<Root>()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            for (v in context.getSystemService(StorageManager::class.java).storageVolumes) {
                if (v.state !in mounted) continue
                val dir = v.directory ?: continue
                roots.add(Root(dir.absolutePath, v.isRemovable, v.getDescription(context)))
            }
        } else {
            for (dir in context.getExternalFilesDirs(null)) {
                if (dir == null || Environment.getExternalStorageState(dir) !in mounted) continue
                roots.add(Root(dir.absolutePath.substringBefore("/Android/data/"), Environment.isExternalStorageRemovable(dir), null))
            }
        }
        return roots.sortedBy { it.removable }
    }
}
