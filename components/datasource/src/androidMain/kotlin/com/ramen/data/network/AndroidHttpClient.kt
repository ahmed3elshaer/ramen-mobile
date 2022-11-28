package com.ramen.data.network

import io.github.aakira.napier.Napier
import io.ktor.client.*
import io.ktor.client.engine.okhttp.*
import io.ktor.client.plugins.defaultRequest
import io.ktor.client.plugins.logging.*
import io.ktor.client.utils.buildHeaders
import io.ktor.http.URLProtocol
import java.util.concurrent.TimeUnit

fun httpClient(withLog: Boolean) = HttpClient(OkHttp) {
    defaultRequest {
        host = "api.spoonacular.com/"
        url {
            protocol = URLProtocol.HTTPS
        }
    }
    engine {
        config {
            retryOnConnectionFailure(true)
            connectTimeout(5, TimeUnit.SECONDS)
            buildHeaders {
                append("x-api-key", "8a11e5ecce8e48cd981701c4a7242c71")
            }
        }
    }
    if (withLog) install(Logging) {
        level = LogLevel.HEADERS
        logger = object : Logger {
            override fun log(message: String) {
                Napier.v(tag = "AndroidHttpClient", message = message)
            }
        }
    }
}