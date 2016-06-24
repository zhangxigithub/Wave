Pod::Spec.new do |s|


  s.name         = "Wave"
  s.version      = "0.1.1"
  s.summary      = "Wave"


  s.description  = "Wave view in Swift"
  s.homepage     = "https://github.com/zhangxigithub/Wave"

  s.license      = "Apache License 2.0"

  s.author             = { "zhangxi" => "zhangxi_1989@sina.com" }
  s.social_media_url   = "http://zhangxi.me"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zhangxigithub/Wave.git", :tag => s.version }

  s.source_files  = "Wave.swift"
  s.framework  = "QuartzCore"

end
