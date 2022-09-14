
class Battle::Scene
  def pbWildBattleSuccess
    @battle.battlers.each {|b|
    next if !b
    next if !b.opposes?
    pkmn = b.pokemon
    next if !pkmn
    next if pkmn.wildHoldItems.nil?
    wildDrop = pkmn.wildHoldItems
    firstqty = rand(3)+1
    secondqty = rand(3)+1
    thirdqty = rand(3)+1
	firstPkmn = $player.first_pokemon
    chances = [50,20,5]
  if firstPkmn
    case firstPkmn.ability_id
    when :COMPOUNDEYES
      chances = [60,40,15]
    when :SUPERLUCK
      chances = [50,50,50]
    end
  end
    droprnd = rand(100)
      if (wildDrop[0]==wildDrop[1] && wildDrop[1]==wildDrop[2]) || droprnd<chances[0]
	    if wildDrop[0].nil?
		else
	    item = wildDrop[0].sample
		item = GameData::Item.get(item)
        if $bag.add(item,firstqty)
          itemname = GameData::Item.get(item).name
          pocket = item.pocket
          @battle.pbDisplayPaused(_INTL("{1} dropped\n{2} <icon=bagPocket#{pocket}> x{3}!",b.pbThis,itemname,firstqty))
        end
		end
      end
      if droprnd<chances[1]
	    if wildDrop[1].nil?
		else
	    item = wildDrop[1].sample
		item = GameData::Item.get(item)
        if $bag.add(item,secondqty)
          itemname = GameData::Item.get(item).name
          pocket = item.pocket
          @battle.pbDisplayPaused(_INTL("{1} dropped\n{2} <icon=bagPocket#{pocket}> x{3}!",b.pbThis,itemname,secondqty))
        end
		end
      end
      if droprnd<chances[2]
	    if wildDrop[2].nil?
		else
	    item = wildDrop[2].sample
		item = GameData::Item.get(item)
        if $bag.add(item,thirdqty)
          itemname = GameData::Item.get(item).name
          pocket = item.pocket
          @battle.pbDisplayPaused(_INTL("{1} dropped\n{2} <icon=bagPocket#{pocket}> x{3}!",b.pbThis,itemname,thirdqty))
        end
	   end
      end
    }
    @battleEnd = true
    pbBGMPlay(pbGetWildVictoryBGM)
  end

end