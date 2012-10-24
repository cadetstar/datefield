Gem::Specification.new do |s|
  s.name    = 'datefield'
  s.version = '0.1.1.pre'
  s.date    = '2012-08-22'
  s.summary = 'Adds jQuery Datefield helpers to ActionView'
  s.description = 'jQuery adds a datepicker that can be placed on certain input tags, this enables users to use regular form tags to do date fields.'
  s.authors = ['Michael Madison']
  s.email   = 'cadetstar@hotmail.com'
  s.files   = Dir["{lib,vendor}/**/*"]
  s.require_path = 'lib'
  s.homepage = 'https://github.com/simu-michaelm/datefield'
  s.add_dependency "railties", "~> 3.1"
end