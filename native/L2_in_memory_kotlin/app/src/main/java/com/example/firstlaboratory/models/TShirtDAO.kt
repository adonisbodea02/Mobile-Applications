package com.example.firstlaboratory.models

import androidx.lifecycle.LiveData
import androidx.room.*

@Dao
interface TShirtDAO {

    @Query("SELECT * from TShirts")
    fun getAll(): LiveData<List<TShirt>>

    @Query("SELECT * from TShirts ORDER BY id ASC")
    suspend fun getAllStatic(): List<TShirt>

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun save(t: TShirt)

    @Query("DELETE FROM TShirts where id = :id")
    suspend fun delete(id: Long)

    @Update
    suspend fun update(t: TShirt)

    @Query("DELETE FROM TShirts")
    suspend fun deleteAll()

    @Query("SELECT COUNT(*) from TShirts")
    suspend fun getCount(): Int
}