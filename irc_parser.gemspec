Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'irc_parser'
  s.version           = '0.0.1'
  s.date              = '2010-08-16'
  s.rubyforge_project = 'irc_parser'

  s.summary     = "Parses IRC protocol messages."
  s.description = "Parses IRC protocol messages, defines messages according to the RFC 1459."

  s.authors  = ["Emmanuel Oga"]
  s.email    = 'EmmanuelOga@gmail.com'
  s.homepage = 'http://github.com/emmanueloga'

  s.require_paths = %w[lib]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.rdoc LICENSE]

  s.add_development_dependency('rspec', ["~> 2.0.0"])

  # = MANIFEST =
  s.files = %w[
    LICENSE
    Rakefile
    irc_parser.gemspec
    lib/irc_parser.rb
    spec/spec_helper.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^spec\/.+/ }
end
