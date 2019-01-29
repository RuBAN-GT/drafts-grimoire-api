namespace :tooltips do
  desc "Format tips slugs" 
  task :format_slugs => :environment do
    tooltips = Tooltip.all

    tooltips.map do |tooltip|
      tooltip.slug = tooltip.slug.gsub(', ', ',')

      tooltip.save
    end
  end

  desc "Find similar tips"
  task :similars => :environment do
    tooltips = Tooltip.similars

    tooltips.each do |group|
      p "* #{group[:tooltip].slug}"
    end
  end
end
