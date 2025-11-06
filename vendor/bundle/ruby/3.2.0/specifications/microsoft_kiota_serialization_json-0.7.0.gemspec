# -*- encoding: utf-8 -*-
# stub: microsoft_kiota_serialization_json 0.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "microsoft_kiota_serialization_json".freeze
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/microsoft/kiota-serialization-json-ruby/issues", "changelog_uri" => "https://github.com/microsoft/kiota-serialization-json-ruby/blob/main/CHANGELOG.md", "github_repo" => "ssh://github.com/microsoft/kiota-serialization-json-ruby", "homepage_uri" => "https://microsoft.github.io/kiota/", "source_code_uri" => "https://github.com/microsoft/kiota-serialization-json-ruby" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Microsoft Corporation".freeze]
  s.date = "2022-12-30"
  s.description = "Implementation of Kiota Serialization interfaces for JSON".freeze
  s.email = "graphsdkpub@microsoft.com".freeze
  s.homepage = "https://microsoft.github.io/kiota/".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0".freeze)
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Microsoft Kiota Serialization - Ruby serialization for building library agnostic http client".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<microsoft_kiota_abstractions>.freeze, ["~> 0.12.0", ">= 0.12.0"])
  s.add_runtime_dependency(%q<uuidtools>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
  s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
end
