require 'json'

desc "Open a console with Urza"
task :console do
  require 'pry'
  require 'urza'
  ARGV.clear
  Pry.start
end

desc "Download AllSets.json from mtgjson.com"
task :download do
  progress = lambda do |received_size|
    print '.'
  end

  File.write('all_sets.json', open("http://mtgjson.com/json/AllSets.json", :progress_proc => progress).read)
end

desc "Download card images to tmp/images"
task :download_images => :environment do
  FileUtils.mkdir_p('tmp/images')

  Urza::Card.all.each do |card|
    filename = "tmp/images/#{card.multiverse_id}.jpg"
    if File.exists? filename
      puts "Skipping #{card.full_name}, file already exists"
      next
    end

    open("http://mtgimage.com/multiverseid/#{card.multiverse_id}.jpg") do |remote_file|
      File.open(filename, 'wb') do |local_file|
        local_file.puts remote_file.read
      end
    end
    puts "Saved #{card.full_name} to #{filename}"
  end
end

desc "Import cards from all_sets.json"
task :import => :environment do
  all_sets = JSON.parse(File.read('all_sets.json'))
  all_sets.each do |set_abbreviation, set|
    expansion = Urza::Expansion.where(
      name: set['name'],
      abbreviation: set['code'],
      release_date: set['releaseDate'],
      border: set['border'],
      set_type: set['type']
    ).first_or_create

    puts "Importing cards from #{expansion.name} (#{expansion.abbreviation})"

    set['cards'].each do |card|
      CARD_DEFAULTS = {
        'names' => [],
        'colors' => [],
        'supertypes' => [],
        'types' => [],
        'subtypes' => [],
        'variations' => []
      }
      card = CARD_DEFAULTS.merge(card)

      Urza::Card.create(
        layout: card['layout'], # "layout"=>"normal",
        full_name: card['name'], # "name"=>"Air Elemental",
        names: card['names'].map { |name| Urza::CardName.where(name: name).first_or_create }, # nil
        mana_cost: card['manaCost'], # "manaCost"=>"{3}{U}{U}",
        cmc: card['cmc'], # "cmc"=>5,
        colors: card['colors'].map { |color| Urza::Color.where(name: color).first_or_create }, # "colors"=>["Blue"]
        card_type: card['type'], # "type"=>"Creature — Elemental",
        supertypes: card['supertypes'].map { |supertype| Urza::Supertype.where(name: supertype).first_or_create }, # nil
        basictypes: card['types'].map { |type| Urza::Basictype.where(name: type).first_or_create }, # "types"=>["Creature"]
        subtypes: card['subtypes'].map { |subtype| Urza::Subtype.where(name: subtype).first_or_create }, # "subtypes"=>["Elemental"]
        rarity: card['rarity'], # "rarity"=>"Uncommon",
        text: card['text'], # "text"=>"Flying",
        flavor_text: card['flavor'], # "flavor"=> "These spirits of the air are winsome and wild and cannot be truly contained. Only marginally intelligent, they often substitute whimsy for strategy, delighting in mischief and mayhem.",
        artist: card['artist'], # "artist"=>"Richard Thomas",
        number: card['number'], # nil
        power: card['power'], # "power"=>"4",
        toughness: card['toughness'], # "toughness"=>"4",
        loyalty: card['loyalty'], # nil
        multiverse_id: card['multiverseid'], # "multiverseid"=>389,
        variations: card['variations'].map { |multiverse_id| Urza::Card.where(multiverse_id: multiverse_id).first_or_create }, # nil
        image_name: card['imageName'], # "imageName"=>"air elemental"
        watermark: card['watermark'], # nil
        border: card['border'], # nil
        hand: card['hand'], # nil
        life: card['life'], # nil
        expansion: expansion
      )
      print '.'
    end
    puts
  end
end
