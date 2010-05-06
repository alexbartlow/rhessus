spec = Gem::Specification.new do |s|
  s.author = "Alex Bartlow"
  s.name   = "rhessus"
  s.version = "0.0.1"
  s.summary = "Ruby Wrapper for Nessus"
  s.description = "Allows scans to be pulled from central repositories"
  s.require_path = 'lib'
  s.has_rdoc = false
  s.email = "bartlowa@gmail.com"
  s.homepage = "http://alexbarlow.com"
  s.files = Dir['**/*'] - [__FILE__]
  s.executable = "rhessus"
  s.add_dependency('activeresource', '>= 2.3.5')
  s.add_dependency('daemons', '>= 1.0.10')
end
