Pod::Spec.new do |spec|
  spec.name = "fazendinha"
  spec.version = "1.0"
  spec.summary = "Validation and generation of CPF and CNPJ numbers."
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Lucien Constantino" => 'lucienc@me.com' }
  spec.social_media_url = "http://twitter.com/luci3n_"
  spec.homepage = "https://github.com/Lucien/fazendinha"
  spec.platform = :ios, "10.0"
  spec.requires_arc = true
  spec.source = { git: "git@github.com:Lucien/fazendinha.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "fazendinha/**/*.{h,swift}"

end
