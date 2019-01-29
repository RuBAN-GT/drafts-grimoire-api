namespace :datasave do
  desc 'Clear old backup of grimoire'
  task :clear => :environment do
    FileUtils.rm_rf Rails.root.join('tmp', 'backup')
  end

  desc 'Export grimoire data'
  task :export => [:clear, :environment] do
    Dir.mkdir Rails.root.join('tmp', 'backup')
    Dir.mkdir Rails.root.join('tmp', 'backup', 'fixtures')

    def export_collection(name, collection, fields)
      export = []

      collection.each do |item|
        record = {}
        fields.each { |field| record[field] = item.send(field) }
        record['theme']      = item.theme.real_id      if item.respond_to? :theme
        record['collection'] = item.collection.real_id if item.respond_to? :collection

        if item.respond_to?(:full_picture) && item.respond_to?(:mini_picture) && !item.full_picture.path.nil?
          FileUtils.cp item.full_picture.path, Rails.root.join('tmp', 'backup', 'fixtures', "#{name}_full_#{item.real_id}.jpg")
          FileUtils.cp item.mini_picture.path, Rails.root.join('tmp', 'backup', 'fixtures', "#{name}_mini_#{item.real_id}.jpg")

          record['full_picture'] = "#{name}_full_#{item.real_id}.jpg"
          record['mini_picture'] = "#{name}_mini_#{item.real_id}.jpg"
        end

        export << record
      end
    
      File.open Rails.root.join('tmp', 'backup', "#{name}.json"), 'w' do |file| 
        file.puts export.to_json
      end
    end

    export_collection :themes, Theme.all.order(:real_id), %w(real_id name_en name_ru)
    export_collection :collections, Collection.all.order(:real_id), %w(real_id name_en name_ru)
    export_collection :cards, Card.all.order(:real_id), %w(real_id name_en name_ru intro_en intro_ru description_en description_ru replacement glossary)
    export_collection :tooltips, Tooltip.all.order(:slug), %w(slug body replacement)
  end

  desc 'Import grimoire data'
  task :import => [:environment] do
    def import_collection(key, class_object)
      collection = JSON.parse File.read(Rails.root.join('tmp', 'backup', "#{key}.json"))

      collection.each do |item|
        full  = item.key?('full_picture') ? item.delete('full_picture') : nil
        mini  = item.key?('mini_picture') ? item.delete('mini_picture') : nil
        theme = item.key?('theme') ? item.delete('theme') : nil
        colln = item.key?('collection') ? item.delete('collection') : nil

        record = class_object.send 'new', item

        if record.respond_to?('theme=') && !theme.nil?
          theme = Theme.find_by_real_id theme

          record.theme = theme
        end
        if record.respond_to?('collection=') && !colln.nil?
          colln = Collection.find_by_real_id colln

          record.collection = colln
        end

        record.full_picture = Rails.root.join('tmp', 'backup', 'fixtures', full).open unless full.nil?
        record.mini_picture = Rails.root.join('tmp', 'backup', 'fixtures', mini).open unless mini.nil?

        record.save rescue next
      end
    end

    import_collection :themes, Theme
    import_collection :collections, Collection
    import_collection :cards, Card
    import_collection :tooltips, Tooltip
  end
end
