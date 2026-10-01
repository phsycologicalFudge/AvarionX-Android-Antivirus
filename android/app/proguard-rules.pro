-keep class rikka.shizuku.** { *; }
-keep class moe.shizuku.** { *; }

-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}

-keep class com.wireguard.** { *; }
-keep class com.colourswift.cssecurity.**.aidl.** { *; }
-keep class * extends android.os.IInterface { *; }
-keep class * extends android.os.Binder { *; }

-keepattributes Signature,InnerClasses,EnclosingMethod,*Annotation*,Exceptions
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

-dontwarn org.bouncycastle.**
-dontwarn org.tukaani.xz.**
-dontwarn com.github.luben.zstd.**
-dontwarn org.brotli.dec.**
-dontwarn org.objectweb.asm.**
-dontwarn com.google.android.play.core.**
-dontwarn javax.naming.**