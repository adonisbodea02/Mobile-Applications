package com.example.firstlaboratory.models

enum class Currency(private val currency : String) {
    Euro("€"),
    Ron("ron"),
    Dollar("$");

    override fun toString(): String {
        return currency
    }
}