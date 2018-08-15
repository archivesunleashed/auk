# frozen_string_literal: true

SitemapGenerator::Sitemap.default_host = ENV['BASE_HOST_URL']
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.create do
  add '/about', changefreq: 'monthly', priority: 0.9
  add '/documentation', changefreq: 'monthly', priority: 0.9
  add '/derivatives', changefreq: 'monthly', priority: 0.9
  add '/derivatives/gephi', changefreq: 'monthly', priority: 0.9
  add '/derivatives/text-antconc', changefreq: 'monthly', priority: 0.9
  add '/derivatives/text-sentiment', changefreq: 'monthly', priority: 0.9
  add '/derivatives/domains', changefreq: 'monthly', priority: 0.9
end
