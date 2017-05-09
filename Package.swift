import PackageDescription

let package = Package(
    name: "iosrest",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5),
        .Package(url: "https://github.com/vapor-community/sqlite-provider", majorVersion: 1, minor: 1)
    ],

    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)
