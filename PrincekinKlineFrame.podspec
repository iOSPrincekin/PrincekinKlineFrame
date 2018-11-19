Pod::Spec.new do |s|
      s.name         = "PrincekinKlineFrame"
      s.version      = "0.0.28"
      s.summary      = "一款敏捷的K线图框架，供金融和虚拟货币行业使用"
      s.homepage     = 'https://github.com/iOSPrincekin/PrincekinKlineFrame.git'
      s.license      = 'MIT'
      s.author       = { "Albert" => "15267030696lee@gmail.com" }
   
      s.ios.deployment_target = '9.0'
     # s.osx.deployment_target = '10.9'
    # s.watchos.deployment_target = '2.0'
     # s.tvos.deployment_target = '9.0'
      s.swift_version = "4.1"
      s.frameworks   = "UIKit" #支持的框架
      s.dependency 'SnapKit'
      s.source       = { :git => "https://github.com/iOSPrincekin/PrincekinKlineFrame.git", :tag => "0.0.28" }
      s.source_files  = 'PrincekinKlineFrame/**/*'
   end