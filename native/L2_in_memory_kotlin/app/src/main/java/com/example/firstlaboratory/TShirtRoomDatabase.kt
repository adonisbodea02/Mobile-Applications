package com.example.firstlaboratory

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.example.firstlaboratory.models.TShirt
import com.example.firstlaboratory.models.TShirtDAO
import kotlinx.coroutines.CoroutineScope

@Database(entities = [TShirt::class], version = 2, exportSchema = false)
public abstract class TShirtRoomDatabase : RoomDatabase() {

    abstract fun tDao(): TShirtDAO

    companion object {
        // Singleton prevents multiple instances of database opening at the
        // same time.
        @Volatile
        private var INSTANCE: TShirtRoomDatabase? = null

        fun getDatabase(scope: CoroutineScope, context: Context): TShirtRoomDatabase {
            val tempInstance = INSTANCE
            if (tempInstance != null) {
                return tempInstance
            }
            synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    TShirtRoomDatabase::class.java,
                    "TShirt_Database_V2"
                ).build()
                INSTANCE = instance
                return instance
            }
        }
    }
}

