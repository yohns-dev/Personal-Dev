import ProjectDescription

let perfixBundelId: String = "co.kr.yohns"

let settings = Settings.settings(
    base: ["SWIFT_VERSION": "5.9"],
    configurations:
    [
        .debug(name: "Debug", xcconfig: .relativeToRoot("Configurations/App-Debug.xcconfig")),
        .release(name: "Release", xcconfig: .relativeToRoot("Configurations/App-Release.xcconfig"))
    ],
    defaultSettings: .none
)

let project = Project(
    name: "TestCalendar",
    settings: settings,
    targets: [
        .target(
            name: "TestCalendar",
            destinations: .macOS,
            product: .app,
            bundleId: "\(perfixBundelId).TestCalendar",
            infoPlist: .default,
            sources: ["TestCalendar/Sources/**"],
            resources: ["TestCalendar/Resources/**"],
            dependencies: [],
            settings: settings
        ),
        .target(
            name: "TestCalendarTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "\(perfixBundelId).TestCalendarTests",
            infoPlist: .default,
            sources: ["TestCalendar/Tests/**"],
            resources: [],
            dependencies: [.target(name: "TestCalendar")],
            settings: settings
        ),
    ]
)
