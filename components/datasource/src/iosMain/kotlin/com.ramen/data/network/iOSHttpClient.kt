package com.ramen.data.network

import io.github.aakira.napier.Napier
import io.ktor.client.*
import io.ktor.client.engine.darwin.Darwin
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.plugins.defaultRequest
import io.ktor.client.plugins.logging.*
import io.ktor.client.request.*
import io.ktor.http.URLProtocol
import io.ktor.serialization.kotlinx.json.json
import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.Json


@OptIn(ExperimentalSerializationApi::class)
fun httpClient(withLog: Boolean) = HttpClient(Darwin) {
    defaultRequest {
        host = "api.spoonacular.com"
        url {
            protocol = URLProtocol.HTTPS
        }
        header("x-api-key","8a11e5ecce8e48cd981701c4a7242c71")
        header("Content-Type","application/json")

    }
    engine {
        configureRequest {
            setAllowsCellularAccess(true)
        }
    }
    install(Logging) {
        level = LogLevel.ALL
        logger = object : Logger {
            override fun log(message: String) {
                Napier.v(tag = "IosHttpClient", message = message)
            }
        }
    }

    install(ContentNegotiation) {
        json(Json {
            prettyPrint = true
            isLenient = true
            ignoreUnknownKeys = true
            explicitNulls = false
        })
    }



}