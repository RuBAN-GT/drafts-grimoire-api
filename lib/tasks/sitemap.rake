namespace :sitemap do
  task :generate => :environment do
    FileUtils.rm_rf Rails.root.join('tmp', 'sitemap')
    FileUtils::mkdir_p Rails.root.join('tmp', 'sitemap')

    SitemapGenerator::Sitemap.create_index = true
    SitemapGenerator::Sitemap.default_host = "https://#{Rails.configuration.x.main_domain}"
    SitemapGenerator::Sitemap.public_path = 'tmp/sitemap'

    SitemapGenerator::Sitemap.create do
      Theme.all.order(:real_id => :asc).each do |theme|
        add "grimoire/#{theme.real_id}", :changefreq => 'monthly', :priority => 0.5

        theme.collections.order(:real_id => :asc).each do |collection|
          collection.cards.order(:real_id => :asc).each do |card|
            add "grimoire/#{theme.real_id}/#{collection.real_id}/#{card.real_id}",
              :changefreq => 'weekly',
              :priority => 0.7
          end
        end
      end
    end
  end
end
