package com.ramen.plugins.di

import io.ktor.server.application.Application
import io.ktor.server.application.install
import org.koin.ktor.plugin.Koin
import org.koin.logger.slf4jLogger

fun Application.configureDI(){
    install(Koin) {
        slf4jLogger()
        modules(module())
    }
}

fun Application.module() = org.koin.dsl.module {

}