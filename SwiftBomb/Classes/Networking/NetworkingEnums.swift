//
//  NetworkingEnums.swift
//  SwiftBomb
//
//  Created by David Fox on 08/05/2016.
//
//

/**
 An enum returned by network requests which defines the various errors which can occur during communication with the Giant Bomb API.
 */
public enum RequestError: ErrorType {
    
    /// An issue with constructing the required framework components to make the request. Typically occurs when the framework hasn't been initialized with a `SwiftBombConfig` instance.
    case FrameworkConfigError
    
    /// An error making the request such as no network signal. Contains a reference to the actual NSError object.
    case NetworkError(NSError?)
    
    /// An error parsing the response from the server. Contains a reference to the actual NSError object.
    case ResponseSerializationError(NSError?)
    
    /// An error specifically returned by the Giant Bomb API. Contains the appropriate enum as defined in `ResourceResponseError`
    case RequestError(ResourceResponseError)
}

/**
 An enum representing the possible error codes the Giant Bomb API can throw back in it's responses.
 */
public enum ResourceResponseError: Int {
    
    /// An invalid API key was provided. Check the API has been initialised with an appropriate `SwiftBombConfig` and that the provided API key is OK.
    case InvalidAPIKey = 100
    
    /// An invalid resource was requested.
    case ResourceNotFound = 101
    
    /// An issue with the request. If you receive this issue, please file a bug on the Github repo.
    case MalformedRequest = 102
    
    /// An error with the filter type passed in.
    case FilterError = 104
    
    /// A subscriber-only video was requested with a free member's API key.
    case SubscriberOnlyVideo = 105
}

/**
 Enum which is returned by calls to the network. Returns either `Success` along with the returned JSON or `Error` along with a `RequestError` explaining what went wrong.
 */
enum RequestResult {
    case Success(AnyObject)
    case Error(RequestError)
}