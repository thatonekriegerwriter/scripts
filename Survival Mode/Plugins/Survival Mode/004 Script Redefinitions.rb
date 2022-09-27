
class PokemonGlobalMetadata

  attr_accessor :pkmnfoodSteps
  attr_accessor :pkmnthirstSteps
  attr_accessor :playerfoodSteps
  attr_accessor :playerwaterSteps
  attr_accessor :playersleepSteps
  attr_accessor :playersaturationSteps
  
  
  def initialize
    @pkmnfoodSteps       = 0
    @pkmnthirstSteps       = 0
    @playerfoodSteps       = 0
    @playerwaterSteps       = 0
    @playersleepSteps       = 0
    @playersaturationSteps       = 0
  end
end

#=====================================================================
module GameData
  class Species
    attr_reader :maxage
    attr_reader :lifespan
    attr_reader :food
    attr_reader :water
    attr_reader :sleep
    attr_reader :age


    def self.schema(compiling_forms = false)
      ret = {
        "FormName"          => [0, "q"],
        "Category"          => [0, "s"],
        "Pokedex"           => [0, "q"],
        "Types"             => [0, "eE", :Type, :Type],
        "BaseStats"         => [0, "vvvvvv"],
        "EVs"               => [0, "*ev", :Stat],
        "BaseExp"           => [0, "v"],
        "CatchRate"         => [0, "u"],
        "Happiness"         => [0, "u"],
        "Moves"             => [0, "*ue", nil, :Move],
        "TutorMoves"        => [0, "*e", :Move],
        "EggMoves"          => [0, "*e", :Move],
        "Abilities"         => [0, "*e", :Ability],
        "HiddenAbilities"   => [0, "*e", :Ability],
        "WildItemCommon"    => [0, "*e", :Item],
        "WildItemUncommon"  => [0, "*e", :Item],
        "WildItemRare"      => [0, "*e", :Item],
        "EggGroups"         => [0, "*e", :EggGroup],
        "HatchSteps"        => [0, "v"],
        "Height"            => [0, "f"],
        "Weight"            => [0, "f"],
        "Color"             => [0, "e", :BodyColor],
        "Shape"             => [0, "e", :BodyShape],
        "Habitat"           => [0, "e", :Habitat],
        "Generation"        => [0, "i"],
        "Flags"             => [0, "*s"],
        "BattlerPlayerX"    => [0, "i"],
        "BattlerPlayerY"    => [0, "i"],
        "BattlerEnemyX"     => [0, "i"],
        "BattlerEnemyY"     => [0, "i"],
        "BattlerAltitude"   => [0, "i"],
        "BattlerShadowX"    => [0, "i"],
        "BattlerShadowSize" => [0, "u"],
        # All properties below here are old names for some properties above.
        # They will be removed in v21.
        "Type1"             => [0, "e", :Type],
        "Type2"             => [0, "e", :Type],
        "Rareness"          => [0, "u"],
        "Compatibility"     => [0, "*e", :EggGroup],
        "Kind"              => [0, "s"],
        "BaseEXP"           => [0, "v"],
        "EffortPoints"      => [0, "*ev", :Stat],
        "HiddenAbility"     => [0, "*e", :Ability],
        "StepsToHatch"      => [0, "v"],
	    "MaxAge"           => [0, "u"],
	    "Lifespan"         => [0, "u"],
	    "Food"             => [0, "u"],
	    "Water"            => [0, "u"],
	    "Sleep"            => [0, "u"],
	    "Age"              => [0, "u"]
      }
      if compiling_forms
        ret["PokedexForm"]  = [0, "u"]
        ret["Offspring"]    = [0, "*e", :Species]
        ret["Evolutions"]   = [0, "*ees", :Species, :Evolution, nil]
        ret["MegaStone"]    = [0, "e", :Item]
        ret["MegaMove"]     = [0, "e", :Move]
        ret["UnmegaForm"]   = [0, "u"]
        ret["MegaMessage"]  = [0, "u"]
      else
        ret["InternalName"] = [0, "n"]
        ret["Name"]         = [0, "s"]
        ret["GrowthRate"]   = [0, "e", :GrowthRate]
        ret["GenderRatio"]  = [0, "e", :GenderRatio]
        ret["Incense"]      = [0, "e", :Item]
        ret["Offspring"]    = [0, "*s"]
        ret["Evolutions"]   = [0, "*ses", nil, :Evolution, nil]
        # All properties below here are old names for some properties above.
        # They will be removed in v21.
        ret["GenderRate"]   = [0, "e", :GenderRatio]
      end
      return ret
    end


    def initialize(hash)
      @id                 = hash[:id]
      @species            = hash[:species]            || @id
      @form               = hash[:form]               || 0
      @real_name          = hash[:name]               || "Unnamed"
      @real_form_name     = hash[:form_name]
      @real_category      = hash[:category]           || "???"
      @real_pokedex_entry = hash[:pokedex_entry]      || "???"
      @pokedex_form       = hash[:pokedex_form]       || @form
      @types              = hash[:types]              || [:NORMAL]
      @base_stats         = hash[:base_stats]         || {}
      @evs                = hash[:evs]                || {}
      GameData::Stat.each_main do |s|
        @base_stats[s.id] = 1 if !@base_stats[s.id] || @base_stats[s.id] <= 0
        @evs[s.id]        = 0 if !@evs[s.id] || @evs[s.id] < 0
      end
      @base_exp           = hash[:base_exp]           || 100
      @growth_rate        = hash[:growth_rate]        || :Medium
      @gender_ratio       = hash[:gender_ratio]       || :Female50Percent
      @catch_rate         = hash[:catch_rate]         || 255
      @happiness          = hash[:happiness]          || 70
      @moves              = hash[:moves]              || []
      @tutor_moves        = hash[:tutor_moves]        || []
      @egg_moves          = hash[:egg_moves]          || []
      @abilities          = hash[:abilities]          || []
      @hidden_abilities   = hash[:hidden_abilities]   || []
      @wild_item_common   = hash[:wild_item_common]   || []
      @wild_item_uncommon = hash[:wild_item_uncommon] || []
      @wild_item_rare     = hash[:wild_item_rare]     || []
      @egg_groups         = hash[:egg_groups]         || [:Undiscovered]
      @hatch_steps        = hash[:hatch_steps]        || 1
      @incense            = hash[:incense]
      @offspring          = hash[:offspring]          || []
      @evolutions         = hash[:evolutions]         || []
      @height             = hash[:height]             || 1
      @weight             = hash[:weight]             || 1
      @color              = hash[:color]              || :Red
      @shape              = hash[:shape]              || :Head
      @habitat            = hash[:habitat]            || :None
      @generation         = hash[:generation]         || 0
      @flags              = hash[:flags]              || []
      @mega_stone         = hash[:mega_stone]
      @mega_move          = hash[:mega_move]
      @unmega_form        = hash[:unmega_form]        || 0
      @mega_message       = hash[:mega_message]       || 0
      @maxage                 = hash[:maxage]           || 100   
      @lifespan               = hash[:lifespan]         || 50    
      @food                   = hash[:food]             || 100   
      @water                  = hash[:water]            || 100   
      @sleep                  = hash[:sleep]            || 100  
      @age                    = hash[:age]              || 1  
    end
end
end
#====================================================================================
class Pokemon
    attr_accessor :food
    attr_accessor :water
    attr_accessor :sleep
    attr_accessor :age
    attr_accessor :maxage
    attr_accessor :lifespan

  def initialize(species, level, owner = $player, withMoves = true, recheck_form = true)
    species_data = GameData::Species.get(species)
    @species          = species_data.species
    @form             = species_data.base_form
    @forced_form      = nil
    @time_form_set    = nil
    self.level        = level
    @steps_to_hatch   = 0
    heal_status
    @gender           = nil
    @shiny            = nil
    @ability_index    = nil
    @ability          = nil
    @nature           = nil
    @nature_for_stats = nil
    @item             = nil
    @mail             = nil
    @moves            = []
    reset_moves if withMoves
    @first_moves      = []
    @ribbons          = []
    @cool             = 0
    @beauty           = 0
    @cute             = 0
    @smart            = 0
    @tough            = 0
    @sheen            = 0
    @pokerus          = 0
    @name             = nil
    @happiness        = species_data.happiness
    @maxage          = species_data.maxage
    @lifespan          = species_data.lifespan
    @food             = species_data.food
    @water            = species_data.water
    @sleep            = species_data.sleep
    @poke_ball        = :POKEBALL
    @markings         = []
    @iv               = {}
    @ivMaxed          = {}
    @ev               = {}
    GameData::Stat.each_main do |s|
      @iv[s.id]       = rand(IV_STAT_LIMIT + 1)
      @ev[s.id]       = 0
    end
    case owner
    when Owner
      @owner = owner
    when Player, NPCTrainer
      @owner = Owner.new_from_trainer(owner)
    else
      @owner = Owner.new(0, "", 2, 2)
    end
    @obtain_method    = 0   # Met
    @obtain_method    = 4 if $game_switches && $game_switches[Settings::FATEFUL_ENCOUNTER_SWITCH]
    @obtain_map       = ($game_map) ? $game_map.map_id : 0
    @obtain_text      = nil
    @obtain_level     = level
    @hatched_map      = 0
    @timeReceived     = pbGetTimeNow.to_i
    @timeEggHatched   = nil
    @fused            = nil
    @personalID       = rand(2**16) | (rand(2**16) << 16)
    @hp               = 1
    @totalhp          = 1
    calc_stats
    if @form == 0 && recheck_form
      f = MultipleForms.call("getFormOnCreation", self)
      if f
        self.form = f
        reset_moves if withMoves
      end
    end
  end
end

#=======================================================================


class Player < Trainer
  attr_reader :playerwater  #206
  attr_reader :playerfood   #205
  attr_reader :playersleep   #208
  attr_reader :playersaturation #207
  attr_reader :playerhealth #225
  attr_reader :playerstamina
  attr_reader :playermaxstamina
  attr_reader :playerstaminamod
  
    def initialize(name, trainer_type)
    super
    @character_ID          = 0
    @outfit                = 0
    @badges                = [false] * 8
    @money                 = GameData::Metadata.get.start_money
    @coins                 = 0
    @battle_points         = 0
    @soot                  = 0
    @playerwater   = 100   # Text speed (0=slow, 1=normal, 2=fast)
    @playerfood = 100     # Battle effects (animations) (0=on, 1=off)
    @playersaturation = 100     # Battle style (0=switch, 1=set)
    @playersleep = 100     # Battle style (0=switch, 1=set)
    @playerhealth  = 100     # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @playerstamina  = 50     # Speech frame
    @playermaxstamina  = 50     # Speech frame
    @playerstaminamod  = 0     # Speech frame
    @pokedex               = Pokedex.new
    @has_pokedex           = false
    @has_pokegear          = false
    @has_running_shoes     = false
    @has_box_link          = false
    @seen_storage_creator  = false
    @has_exp_all           = false
    @mystery_gift_unlocked = false
    @mystery_gifts         = []
  end


end

#===========================================================================================


module Compiler

  def compile_pokemon(path = "PBS/pokemon.txt")
    compile_pbs_file_message_start(path)
    GameData::Species::DATA.clear
    species_names           = []
    species_form_names      = []
    species_categories      = []
    species_pokedex_entries = []
    # Read from PBS file
    File.open(path, "rb") { |f|
      FileLineData.file = path   # For error reporting
      # Read a whole section's lines at once, then run through this code.
      # contents is a hash containing all the XXX=YYY lines in that section, where
      # the keys are the XXX and the values are the YYY (as unprocessed strings).
      schema = GameData::Species.schema
      idx = 0
      pbEachFileSection(f) { |contents, species_id|
        echo "." if idx % 50 == 0
        idx += 1
        Graphics.update if idx % 250 == 0
        FileLineData.setSection(species_id, "header", nil)   # For error reporting
        contents["InternalName"] = species_id if !species_id[/^\d+/]
        # Ensure all required properties have been defined, and raise an error
        # if not
        schema.each_key do |key|
          next if !nil_or_empty?(contents[key])
          if ["Name", "InternalName"].include?(key)
            raise _INTL("The entry {1} is required in {2} section {3}.", key, path, species_id)
          end
          contents[key] = nil
        end
        # Raise an error if a species ID is used twice
        if GameData::Species::DATA[contents["InternalName"].to_sym]
          raise _INTL("Species ID '{1}' is used twice.\r\n{2}", contents["InternalName"], FileLineData.linereport)
        end
        # Go through schema hash of compilable data and compile this section
        schema.each_key do |key|
          next if nil_or_empty?(contents[key])
          FileLineData.setSection(species_id, key, contents[key])   # For error reporting
          # Compile value for key
          if ["EVs", "EffortPoints"].include?(key) && contents[key].split(",")[0].numeric?
            value = pbGetCsvRecord(contents[key], key, [0, "uuuuuu"])   # Old format
          else
            value = pbGetCsvRecord(contents[key], key, schema[key])
          end
          value = nil if value.is_a?(Array) && value.empty?
          contents[key] = value
          # Sanitise data
          case key
          when "BaseStats"
            value_hash = {}
            GameData::Stat.each_main do |s|
              value_hash[s.id] = value[s.pbs_order] if s.pbs_order >= 0
            end
            contents[key] = value_hash
          when "EVs", "EffortPoints"
            if value[0].is_a?(Array)   # New format
              value_hash = {}
              value.each { |val| value_hash[val[0]] = val[1] }
              GameData::Stat.each_main { |s| value_hash[s.id] ||= 0 }
              contents[key] = value_hash
            else   # Old format
              value_hash = {}
              GameData::Stat.each_main do |s|
                value_hash[s.id] = value[s.pbs_order] if s.pbs_order >= 0
              end
              contents[key] = value_hash
            end
          when "Height", "Weight"
            # Convert height/weight to 1 decimal place and multiply by 10
            value = (value * 10).round
            if value <= 0
              raise _INTL("Value for '{1}' can't be less than or close to 0 (section {2}, {3})", key, species_id, path)
            end
            contents[key] = value
          when "Evolutions"
            contents[key].each { |evo| evo[3] = false }
          end
        end
        # Construct species hash
        types = contents["Types"] || [contents["Type1"], contents["Type2"]]
        types = [types] if !types.is_a?(Array)
        types = types.uniq.compact
        species_hash = {
          :id                 => contents["InternalName"].to_sym,
          :name               => contents["Name"],
          :form_name          => contents["FormName"],
          :category           => contents["Category"] || contents["Kind"],
          :pokedex_entry      => contents["Pokedex"],
          :types              => types,
          :base_stats         => contents["BaseStats"],
          :evs                => contents["EVs"] || contents["EffortPoints"],
          :base_exp           => contents["BaseExp"] || contents["BaseEXP"],
          :growth_rate        => contents["GrowthRate"],
          :gender_ratio       => contents["GenderRatio"] || contents["GenderRate"],
          :catch_rate         => contents["CatchRate"] || contents["Rareness"],
          :happiness          => contents["Happiness"],
          :maxage             => contents["MaxAge"],
          :lifespan           => contents["Lifespan"],
          :maxage             => contents["Age"],
          :lifespan           => contents["Food"],
          :maxage             => contents["MaxAge"],
          :lifespan           => contents["Water"],
          :maxage             => contents["MaxAge"],
          :lifespan           => contents["Sleep"],
          :moves              => contents["Moves"],
          :tutor_moves        => contents["TutorMoves"],
          :egg_moves          => contents["EggMoves"],
          :abilities          => contents["Abilities"],
          :hidden_abilities   => contents["HiddenAbilities"] || contents["HiddenAbility"],
          :wild_item_common   => contents["WildItemCommon"],
          :wild_item_uncommon => contents["WildItemUncommon"],
          :wild_item_rare     => contents["WildItemRare"],
          :egg_groups         => contents["EggGroups"] || contents["Compatibility"],
          :hatch_steps        => contents["HatchSteps"] || contents["StepsToHatch"],
          :incense            => contents["Incense"],
          :offspring          => contents["Offspring"],
          :evolutions         => contents["Evolutions"],
          :height             => contents["Height"],
          :weight             => contents["Weight"],
          :color              => contents["Color"],
          :shape              => contents["Shape"],
          :habitat            => contents["Habitat"],
          :generation         => contents["Generation"],
          :flags              => contents["Flags"]
        }
        # Add species' data to records
        GameData::Species.register(species_hash)
        species_names.push(species_hash[:name])
        species_form_names.push(species_hash[:form_name])
        species_categories.push(species_hash[:category])
        species_pokedex_entries.push(species_hash[:pokedex_entry])
        # Save metrics data if defined (backwards compatibility)
        if contents["BattlerPlayerX"] || contents["BattlerPlayerY"] ||
           contents["BattlerEnemyX"] || contents["BattlerEnemyY"] ||
           contents["BattlerAltitude"] || contents["BattlerShadowX"] ||
           contents["BattlerShadowSize"]
          metrics_hash = {
            :id                    => contents["InternalName"].to_sym,
            :back_sprite           => [contents["BattlerPlayerX"] || 0, contents["BattlerPlayerY"] || 0],
            :front_sprite          => [contents["BattlerEnemyX"] || 0, contents["BattlerEnemyY"] || 0],
            :front_sprite_altitude => contents["BattlerAltitude"] || 0,
            :shadow_x              => contents["BattlerShadowX"] || 0,
            :shadow_size           => contents["BattlerShadowSize"] || 2
          }
          GameData::SpeciesMetrics.register(metrics_hash)
        end
      }
    }
    # Enumerate all offspring species (this couldn't be done earlier)
    GameData::Species.each do |species|
      FileLineData.setSection(species.id.to_s, "Offspring", nil)   # For error reporting
      offspring = species.offspring
      offspring.each_with_index do |sp, i|
        offspring[i] = csvEnumField!(sp, :Species, "Offspring", species.id)
      end
    end
    # Enumerate all evolution species and parameters (this couldn't be done earlier)
    GameData::Species.each do |species|
      FileLineData.setSection(species.id.to_s, "Evolutions", nil)   # For error reporting
      species.evolutions.each do |evo|
        evo[0] = csvEnumField!(evo[0], :Species, "Evolutions", species.id)
        param_type = GameData::Evolution.get(evo[1]).parameter
        if param_type.nil?
          evo[2] = nil
        elsif param_type == Integer
          evo[2] = csvPosInt!(evo[2])
        elsif param_type != String
          evo[2] = csvEnumField!(evo[2], param_type, "Evolutions", species.id)
        end
      end
    end
    # Add prevolution "evolution" entry for all evolved species
    all_evos = {}
    GameData::Species.each do |species|   # Build a hash of prevolutions for each species
      species.evolutions.each do |evo|
        all_evos[evo[0]] = [species.species, evo[1], evo[2], true] if !all_evos[evo[0]]
      end
    end
    GameData::Species.each do |species|   # Distribute prevolutions
      species.evolutions.push(all_evos[species.species].clone) if all_evos[species.species]
    end
    # Save all data
    GameData::Species.save
    GameData::SpeciesMetrics.save
    MessageTypes.setMessagesAsHash(MessageTypes::Species, species_names)
    MessageTypes.setMessagesAsHash(MessageTypes::FormNames, species_form_names)
    MessageTypes.setMessagesAsHash(MessageTypes::Kinds, species_categories)
    MessageTypes.setMessagesAsHash(MessageTypes::Entries, species_pokedex_entries)
    process_pbs_file_message_end
  end
  end