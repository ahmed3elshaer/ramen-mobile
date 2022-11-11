package com.ramen

import com.ramen.plugins.configureRouting
import com.ramen.plugins.di.configureDI
import io.ktor.server.engine.embeddedServer
import io.ktor.server.netty.Netty


fun main() {
    embeddedServer(Netty, port = 8080, host = "0.0.0.0") {
        configureRouting()
        configureDI()
    }.start(wait = true)
}
