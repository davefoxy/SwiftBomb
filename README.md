 [![Version](https://img.shields.io/cocoapods/v/SwiftBomb.svg?style=flat)](http://cocoapods.org/pods/SwiftBomb)
[![License](https://img.shields.io/cocoapods/l/SwiftBomb.svg?style=flat)](http://cocoapods.org/pods/SwiftBomb)
[![Platform](https://img.shields.io/cocoapods/p/SwiftBomb.svg?style=flat)](http://cocoapods.org/pods/SwiftBomb)

# SwiftBomb
SwiftBomb is a simple-to-use iOS library written in Swift to interface with the GiantBomb.com API. 

Giant Bomb is a website with a massive wiki around video games. Search information on games, their publishers, characters, developers, genres, even objects within games and loads more.

[Fully documented](http://cocoadocs.org/docsets/SwiftBomb/0.7.0) with a simple integration process, SwiftBomb allows retrieval of resources in one line and strongly types all responses and errors to make consumption within your apps easy.

Check out www.giantbomb.com for plenty of video game-related shenanigans.

## Installation
SwiftBomb is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "SwiftBomb"
```

## Setup
Before accessing the framework, you must configure it with your API key (get one from [http://www.giantbomb.com/api](http://www.giantbomb.com/api)) and optional desired logging level and user agent. Typically you do this in your application delegate during startup:
```swift
import SwiftBomb

let configuration = SwiftBombConfig(apiKey: "YOUR_API_KEY", loggingLevel: .Requests, userAgentIdentifier: "Your User Agent", networkingDelegate: networkingDelegate, urlRequestCachePolicy: .UseProtocolCachePolicy)

SwiftBomb.configure(configuration)
```

## Usage
The `SwiftBomb` class is your entry point to fetching all resources. Let autocomplete show you what's available. For example, to fetch all games in the database:
```swift
SwiftBomb.fetchGames { result, error in

	if let games = result?.resources {
		// games now contains an array of `GameResource`s
		for game in games {
			print("Game: \(game.name)")
		}
	}
}
```

Check out all the other resource requests you can make in the [SwiftBomb documentation](http://cocoadocs.org/docsets/SwiftBomb/0.7.0/Classes/SwiftBomb.html).

The `result` object returned by these methods is a `PaginatedResults` object. It contains a strongly-typed array, `resources`, of all the resources returned by the call and additional useful information on the total number of results and the number returned in this request. You can use this for implementing pagination as seen in the example app.

### Filtering, Pagination and Sorting
Additionally, all these requests can be filtered and sorted and paginated using the same requests by passing in `PaginationDefinition` and `SortDefinition` aliases. The following does exactly the same as above but will search for *Uncharted*, starting at the 5th object, limited to 10 results and sorted in ascending order by name:
```swift
let pagination = PaginationDefinition(offset: 4, limit: 10)
let sorting = SortDefinition(field: "name", direction: .Ascending)

SwiftBomb.fetchGames("Uncharted", pagination: pagination, sort: sorting) { result, error in

	if let games = result?.resources {
		// games now contains an array of `GameResource`s
		for game in games {
			print("Game: \(game.name)")
		}
	}
}
```

### Searching Ambiguous Resources
SwiftBomb provides many different requests and resource types which you can search on specifically but what if you want to perform a *general* search? Try `performSearch(_:resourceTypes:pagination:sort:completion:)`. This returns an instance of `SearchResults` which provides all the info you need. Check out the [SearchResults documentation](http://cocoadocs.org/docsets/SwiftBomb/0.7.0/Structs/SearchResults.html) to see what's on offer.

### Retrieving Extended Data
Already have a resource stub or summary downloaded from one of SwiftBomb's calls but want extended information? Many of the resources in SwiftBomb have an `extendedInfo` property within them. It will initially be nil but if you want what's inside, call `fetchExtendedInfo` upon it and the original object will now be populated with more detailed info. For example:

```swift
SwiftBomb.fetchGames("Super Mario Galaxy") { result, error in

	if let firstGame = result?.resources.first {

		firstGame.fetchExtendedInfo { error in
			// firstGame's `extendedInfo` property is now available...
			for gameCharacter in (firstGame.extendedInfo?.characters)! {
				print("Featuring \(gameCharacter.name)")
			}
		}
	}
}
```
Check out the documentation on the `Resource` objects to see exactly what's available for each type.

### Optimizing Requests
All requests to SwiftBomb may be passed an optional `fields` array. This allows you to specify only the fields you require in the response. This can speed up fetches on the serverside massively. See the [Giant Bomb documentation](http://http://www.giantbomb.com/api/documentation) for a list of field names available. Alternatively, just don't specify one or pass nil to retrieve everything. For example, the following request performs a search for *Splatoon*, only returning the `name`, `deck` and `image` fields:

```swift
SwiftBomb.fetchGames("Splatoon", fields: ["name", "deck", "image"]) { (results, error) in
...
}
```

### Error Handling
All interactions with SwiftBomb optionally return a `RequestError` enum. Check out [it's reference](http://cocoadocs.org/docsets/SwiftBomb/0.7.0/Enums/RequestError.html) for the possible errors. In addition, some can return `NSError` objects representing the detail of what went wrong. For example:

```swift
SwiftBomb.fetchGames("Metal Gear Solid") { result, error in

	if let error = error {
		switch error {
		case .FrameworkConfigError:
			print("Framework config error")

		case .NetworkError(let nsError):
			print("Network error: \(nsError?.localizedDescription)")

		case .ResponseSerializationError(let nsError):
			print("Response error: \(nsError?.localizedDescription)")

		case .RequestError(let gbError):
			// This error is of type `ResourceResponseError`
			print("Request error: \(gbError)")
		}
	}

...
}
```

## Upcoming Giant Bomb Posts
Version 0.6.0 introduces a handy method for fetching the contents of the "Coming up on Giant Bomb" panel on the homepage of the site...
```swift
SwiftBomb.fetchComingUpSchedule { comingUpSchedule, error in

	guard let comingUpSchedule = comingUpSchedule else {
		return
	}
	
	if let liveShow = comingUpSchedule.liveNow {
		print("Current live show: \(liveShow.title)")
	}

	for scheduledPost in comingUpSchedule.upcoming {
		print("Upcoming post: \(scheduledPost.title)")
	}
}
```

Note that this method hits an undocumented URL on Giant Bomb. If the staff change it, this will probably break things. If so, let me know and I'll update.

## Sample Code
Still not making enough sense? The repo comes with an example app demonstrating all the fetches in action. Sorry it's a little messy right now but it gives a general idea and again, [check out the class references](http://cocoadocs.org/docsets/SwiftBomb/0.7.0/). I've written up fairly extensive docs for every method in the lib.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author
David Fox (@davefoxy)

## Acknowledgements
- The sample project uses [ImageLoaderSwift](https://github.com/hirohisa/ImageLoaderSwift) which was really nice and lightweight to integrate.
- All the developers and contributors on the Giant Bomb wiki. There's an insane amount of info in that thing!

## License
SwiftBomb is available under the MIT license. See the LICENSE file for more info.
