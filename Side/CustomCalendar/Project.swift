import ProjectDescription

let bundleIDPrefix = "com.kr.yohns.customcalendar"

let settings = Settings.settings(
  base: ["SWIFT_VERSION": "5.9"],
  configurations: [
    .debug(name: "Debug", xcconfig: "Configs/Debug.xcconfig"),
    .release(name: "Release", xcconfig: "Configs/Release.xcconfig")
  ]
)

let project = Project(
  name: "CustomCalendar",
  organizationName: "yohns",
  settings: settings,
  targets: [
    .target(
      name: "CustomCalendar",
      destinations: .macOS,
      product: .app,
      bundleId: bundleIDPrefix,
      infoPlist: .default,
      sources: ["CustomCalendar/Sources/**"],
      resources: ["CustomCalendar/Resources/**"],
      dependencies: []
    ),
    .target(
      name: "CustomCalendarTests",
      destinations: .macOS,
      product: .unitTests,
      bundleId: "\(bundleIDPrefix).test",
      infoPlist: .default,
      sources: ["CustomCalendar/Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "CustomCalendar")
      ]
    )
  ],
  schemes: [
    .scheme(
      name: "CustomCalendar-Debug",
      shared: true,
      buildAction: .buildAction(targets: ["CustomCalendar"]),
      testAction: .targets(
        ["CustomCalendarTests"],
        configuration: "Debug",
        options: .options(coverage: true)
      ),
      runAction: .runAction(configuration: "Debug"),
      archiveAction: .archiveAction(configuration: "Release")
    ),
    .scheme(
      name: "CustomCalendar-Release",
      shared: true,
      buildAction: .buildAction(targets: ["CustomCalendar"]),
      runAction: .runAction(configuration: "Release"),
      archiveAction: .archiveAction(configuration: "Release")
    )
  ]
)
