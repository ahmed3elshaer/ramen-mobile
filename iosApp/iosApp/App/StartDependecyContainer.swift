//
//  StartDependecyContainer.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 11/28/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import shared

func startKoin() {
    // You could just as easily define all these dependencies in Kotlin,
    // but this helps demonstrate how you might pass platform-specific
    // dependencies in a larger scale project where declaring them in
    // Kotlin is more difficult, or where they're also used in
    // iOS-specific code.
    // let userDefaults = UserDefaults(suiteName: "KAMPSTARTER_SETTINGS")!
    // let iosAppInfo = IosAppInfo()
    // let doOnStartup = { NSLog("Hello from iOS/Swift!") }

    let koinApplication = DependencyContainer.shared.doInitKoin()
    DependencyContainer.shared.doInitLogger()
    _koin = koinApplication.koin
}

private var _koin: Koin_coreKoin?
var koin: Koin_coreKoin {
    return _koin!
}
