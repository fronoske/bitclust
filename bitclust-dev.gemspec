$:.push File.expand_path("../lib", __FILE__)
require "bitclust/version"

Gem::Specification.new do |s|
  s.name        = "bitclust-dev"
  s.version     = BitClust::VERSION
  s.authors     = ["https://github.com/rurema"]
  s.email       = [""]
  s.homepage    = "https://docs.ruby-lang.org/ja/"
  s.summary     = %Q!BitClust is a rurema document processor.!
  s.description =<<EOD
Rurema is a Japanese ruby documentation project, and
bitclust is a rurema document processor.
This is tools for Rurema developpers.
EOD

  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/rurema/bitclust/issues",
    "documentation_uri" => "https://github.com/rurema/doctree/wiki",
    "homepage_uri"      => s.homepage,
    "source_code_uri"   => "https://github.com/rurema/bitclust",
    "github_repo"       => "https://github.com/rurema/bitclust",
    "wiki_uri"          => "https://github.com/rurema/doctree/wiki",
  }

  s.files         = Dir["tools/*"]
  s.executables   = Dir["tools/*"].
    map {|v| File.basename(v) }.
    reject {|f| %w(ToDoHistory check-signature.rb).include?(f) }
  s.require_paths = ["lib"]
  s.bindir        = "tools"

  s.add_runtime_dependency "bitclust-core", "= #{BitClust::VERSION}"
end
