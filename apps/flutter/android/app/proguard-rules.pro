-keep class * extends androidx.room.RoomDatabase {
    <init>(...);
}
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
-keep class org.citra.citra_emu.** { *; }
