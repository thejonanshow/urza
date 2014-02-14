require 'json'

desc "Open a console with Gatherer"
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

desc "Import cards from all_sets.json"
task :import do
  all_sets = JSON.parse(File.read('all_sets.json'))
  all_sets.each do |set_abbreviation, set|
    expansion = Expansion.find_or_create(
      name: set['name'],
      abbreviation: set['code'],
      release_date: set['releaseDate'],
      border: set['border'],
      type: set['type']
    )

    set['cards'].each do |card|
      Card.find_or_create(
        layout: card['layout'], # "layout"=>"normal",
        type: card['type'], # "type"=>"Creature — Elemental",
        types: card['types'], # "types"=>["Creature"],
        colors: card['colors'], # "colors"=>["Blue"],
        multiverse_id: card['multiverseid'], # "multiverseid"=>389,
        name: card['name'], # "name"=>"Air Elemental",
        subtypes: card['subtypes'], # "subtypes"=>["Elemental"],
        cmc: card['cmc'], # "cmc"=>5,
        rarity: card['rarity'], # "rarity"=>"Uncommon",
        artist: card['artist'], # "artist"=>"Richard Thomas",
        power: card['power'], # "power"=>"4",
        toughness: card['toughness'], # "toughness"=>"4",
        mana_cost: card['manaCost'], # "manaCost"=>"{3}{U}{U}",
        text: card['text'], # "text"=>"Flying",
        flavor_text: card['flavor'], # "flavor"=> "These spirits of the air are winsome and wild and cannot be truly contained. Only marginally intelligent, they often substitute whimsy for strategy, delighting in mischief and mayhem.",
        image_name: card['imageName'] # "imageName"=>"air elemental"
      )
    end
  end
end
