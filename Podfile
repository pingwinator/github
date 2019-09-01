# Disable sending stats
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

platform :ios, '10.0'

source 'https://cdn.cocoapods.org/'
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!
# ignore all warnings from all pods
inhibit_all_warnings!

project 'GithubClient/GithubClient.xcodeproj'

target 'GithubAPI' do
  pod 'Alamofire'
  pod 'AlamofireImage', '~> 3.3'
  pod 'SwiftyJSON'

  #remove git option after pr https://github.com/kylef/WebLinking.swift/pull/10 will be merged
  pod 'WebLinking', :git => 'git@gitlab.com:pingwinator/WebLinking.swift.git'
  pod 'Cache', :git => 'git@github.com:pingwinator/Cache.git'
  pod 'AFDateHelper'

end

target 'GithubClient' do
    pod 'Differ'
    pod 'Simple-KeychainSwift'
    pod 'SwiftLint'
    pod 'AFDateHelper'
end
