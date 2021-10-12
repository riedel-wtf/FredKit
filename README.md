# FredKit

A collection of customised Swift extensions and classes I've written over the years which might be useful for others as well. I use Swift classes such as the Date extension and rounded buttons in almost every project nowadays.

## Rounded Buttons
- Specify corner radius
- Uses advanced continous corners instead of perfectly round corners

## Date Formatting
- humanReadableDateString
- humanReadableDateAndTimeString
- shortTimeString
- shortDateString
- shortWeekDay
- shortMonth
- shortDate
- longDate
- compactDateTimeString
- isInFuture

## TimeIntervals
- nanosecond
- millisecond
- second
- minute
- hour
- day
- week
- month
- year
- decade
- century
- millenium

## Working with Colors
- Contrast calculation (dark or light background required for a font with specific color?)
- Generate color from string

## Rounded Font
- Creates the rounded SF font version

## Simplified Localized String
Use `NSLocalizedString("hello world!")` without the additional `comment` attribute.

## Strings
- Capitalize first character of a string
- SHA1 hash
- Is string almost equal to other string?
- Subscript (get `char` at index)
- Levenshtein distance
- Get CGPath of String

## FileManager extensions
- Ensure folder exists
- documentsDirectory URL

## UIView
- snapshot `UIView`


## NSLocalizedString
- NSLocalizedString without comment


## FredKitSubscriptionManager
Makes working with Subscriptions on iOS even easier. Uses SwiftyStoreKit and Apple‘s StoreKit under the hood.

## UITableView
registerMainBundleNibs: Register multiple cell Nibs at once.

## UIViewController
- wrappedInNavigationController
- topViewController
