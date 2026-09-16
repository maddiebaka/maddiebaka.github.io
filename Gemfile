source "https://rubygems.org"

# Built and deployed by .github/workflows/pages.yml, not by GitHub's
# classic Pages builder, so we're free to track current Jekyll.
gem "jekyll", "~> 4.4"

# Ruby 3.x dropped webrick from stdlib; `jekyll serve` needs it.
gem "webrick", "~> 1.8"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.17"
  gem "jekyll-include-cache", "~> 0.2"
  gem "jekyll-remote-theme", "~> 0.4"
end
