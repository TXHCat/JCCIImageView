Pod::Spec.new do |s|
  s.name             = 'JCCIImageView'
  s.version          = '0.1'
  s.summary          = 'Image view for rendering CIImage'

  s.homepage         = 'https://github.com/JakeCai/JCCIImageView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jake Cai' => 'jakecode@outlook.com' }
  s.social_media_url = "https://twitter.com/jakecat_cai"
  s.source           = { :git => 'https://github.com/JakeCai/JCCIImageView.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'

  s.module_name = "JCCIImageView"
  s.source_files = 'JCCIImageView/Source/**/*'
end

