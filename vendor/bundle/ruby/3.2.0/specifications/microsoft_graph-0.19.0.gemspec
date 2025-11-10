# -*- encoding: utf-8 -*-
# stub: microsoft_graph 0.19.0 ruby lib

Gem::Specification.new do |s|
  s.name = "microsoft_graph".freeze
  s.version = "0.19.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/microsoftgraph/msgraph-sdk-ruby/issues", "changelog_uri" => "https://github.com/microsoftgraph/msgraph-sdk-ruby/blob/main/CHANGELOG.md", "github_repo" => "ssh://github.com/microsoftgraph/msgraph-sdk-ruby", "homepage_uri" => "https://graph.microsoft.com", "source_code_uri" => "https://github.com/microsoftgraph/msgraph-sdk-ruby" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Microsoft Corporation".freeze]
  s.date = "2023-03-21"
  s.description = "The Microsoft Graph Ruby SDK enables you to use Microsoft Graph v1.0 in your Ruby apps.".freeze
  s.email = "graphsdkpub+ruby@microsoft.com".freeze
  s.homepage = "https://graph.microsoft.com".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0.0".freeze)
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Ruby SDK for Microsoft Graph".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<microsoft_graph_core>.freeze, [">= 0.1", "< 0.3"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
end
