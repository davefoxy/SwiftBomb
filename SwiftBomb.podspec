#
# Be sure to run `pod lib lint SwiftBomb.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftBomb"
  s.version          = "0.6.1"
  s.summary          = "A Swift library to integrate with the Giant Bomb wiki for the retrieval of all things video games."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SwiftBomb is a simple-to-use interface with the GiantBomb.com API. Giant Bomb is a website with a massive wiki around video games. Search information on games, their publishers, characters, developers, genres, even objects within games and loads more.

Fully documented with a simple integration process, SwiftBomb allows retrieval of resources in one line and uses generics to strongly type all responses and errors to make consumption within your apps easy.

Check out www.giantbomb.com for plenty of video game-related shenanigans. <>
                       DESC

  s.homepage         = "https://github.com/davefoxy/SwiftBomb"
  s.license          = 'MIT'
  s.author           = { "David Fox" => "davidfox@icloud.com" }
  s.source           = { :git => "https://github.com/davefoxy/SwiftBomb.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/davefoxy'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SwiftBomb/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftBomb' => ['SwiftBomb/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
