
Pod::Spec.new do |s|
  s.name             = "QWToast"
  s.version          = "0.1.0"
  s.summary          = "淘在路上社区toast 控件（上海雀沃）"

  s.description      = <<-DESC
    淘在路上社区toast 控件的实现
                       DESC

  s.homepage         = "http://git.117gogogo.net/framework/qwtoast"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "ranjingfu" => "ranjingfu@117go.com" }
  s.source           = { :git => "http://git.117gogogo.net/framework/qwtoast.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'QWToast' => ['Pod/Assets/*.xcassets']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
