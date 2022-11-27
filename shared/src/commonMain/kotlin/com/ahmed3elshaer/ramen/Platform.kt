package com.ahmed3elshaer.ramen

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform