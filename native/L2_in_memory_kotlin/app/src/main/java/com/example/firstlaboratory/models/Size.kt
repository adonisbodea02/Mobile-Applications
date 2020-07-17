package com.example.firstlaboratory.models

enum class Size(private val size : String) {
    XS("XS"),
    S("S"),
    M("M"),
    L("L"),
    XL("XL");

    override fun toString(): String {
        return size
    }
}