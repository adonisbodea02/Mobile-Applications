package com.example.firstlaboratory

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.viewModelScope
import com.example.firstlaboratory.models.TShirt
import com.example.firstlaboratory.repository.TShirtRepository
import com.example.firstlaboratory.service.Service
import kotlinx.coroutines.launch

class TShirtViewModel(application: Application) : AndroidViewModel(application) {

    private val repository: TShirtRepository
    val allTShirts: LiveData<List<TShirt>>


    init {

        val tshirtsDao = TShirtRoomDatabase.getDatabase(viewModelScope, application).tDao()
        repository = TShirtRepository(tshirtsDao)
        allTShirts = repository.allTShirts
        Service.repository = repository
    }

    fun insert(t: TShirt) = viewModelScope.launch {
        repository.insert(t)
    }

    fun delete(id: Long) = viewModelScope.launch {
        repository.delete(id)
    }

    fun update(t: TShirt) = viewModelScope.launch {
        repository.update(t)
    }
}