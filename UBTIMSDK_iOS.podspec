#
# Be sure to run `pod lib lint UBTIMSDK_iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UBTIMSDK_iOS'
  #version=3.0.1
  s.version          = '1.0.2'
  s.summary          = 'A short description of UBTIMSDK_iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'git@github.com:genobili1984/UBTIMSDK_iOS.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aimin.zha' => 'aimin.zha@ubtrobot.com' }
  s.source           = { :git => 'git@github.com:genobili1984/UBTIMSDK_iOS.git', :tag => s.version.to_s }
  #s.source           = { :git => 'git@github.com:genobili1984/UBTIMSDK_iOS.git'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'UBTIMSDK_iOS/UBTIMSDK/**/*'
  
  # s.resource_bundles = {
  #   'UBTIMSDK_iOS' => ['UBTIMSDK_iOS/Assets/*.png']
  # }

  pch = <<-EOS
#ifdef TARGET_OS_IOS
  #import "UBTIMSDK.h"
#endif
  EOS
  s.prefix_header_contents = pch

  s.requires_arc = true
  s.public_header_files = 'UBTIMSDK_iOS/UBTIMSDK/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'TXIMSDK_iOS','~>4.3.145'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/*"'}

end
