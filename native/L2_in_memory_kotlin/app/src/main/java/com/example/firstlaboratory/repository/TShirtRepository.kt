package com.example.firstlaboratory.repository

import androidx.lifecycle.LiveData
import com.example.firstlaboratory.models.*

class TShirtRepository(private val tshirtDAO: TShirtDAO){

    val allTShirts: LiveData<List<TShirt>> = tshirtDAO.getAll()

    suspend fun insert(t: TShirt) {
        tshirtDAO.save(t)
    }

    suspend fun delete(id: Long) {
        tshirtDAO.delete(id)
    }

    suspend fun update(t: TShirt) {
        tshirtDAO.update(t)
    }

    suspend fun deleteLocals(){
        tshirtDAO.deleteAll()
    }

    suspend fun getAllStatic():List<TShirt> {
        return tshirtDAO.getAllStatic()
    }

    suspend fun getCount(): Int {
        return tshirtDAO.getCount()
    }
}