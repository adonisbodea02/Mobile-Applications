package com.example.firstlaboratory.models

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.google.gson.annotations.SerializedName

@Entity(tableName = "TShirts")
data class TShirt(

    @SerializedName("band")
    var band: String,
    @SerializedName("color")
    var color: String,
    @SerializedName("size")
    var size: String,
    @SerializedName("price")
    var price: Int,
    @SerializedName("currency")
    var currency: String,
    @SerializedName("id")
    @PrimaryKey
    var id: Long
)
