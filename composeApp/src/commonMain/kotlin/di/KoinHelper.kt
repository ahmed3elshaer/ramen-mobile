package di

import com.ramen.shared.dependencyGraph
import org.koin.core.context.startKoin
import org.koin.core.logger.Level
import org.koin.core.logger.Logger
import org.koin.core.logger.MESSAGE

fun doInitKoin(){
    // Koin is a dependency injection framework for Kotlin
    startKoin {
        modules(dependencyGraph)
        val logger = object :Logger(){
            override fun display(level: Level, msg: MESSAGE) {
                println("Koin: $msg")
            }

        }
        logger(logger)
    }
}