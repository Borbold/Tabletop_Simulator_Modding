function onLoad(savedData)
    waitCount = 0.4
    StopPlaylist()
end

function SetMinecraftPlaylist()
    StopPlaylist()

    Wait.time(function()
        MusicPlayer.setPlaylist({
            {
                url = "https://vgmsite.com/soundtracks/minecraft/aoqfyvljpe/1-01.%20Key.mp3",
                title = "Key"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/szinlrjfuu/1-02.%20Door.mp3",
                title = "Door"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/jrevvjewku/1-03.%20Subwoofer%20Lullaby.mp3",
                title = "Subwoofer Lullaby"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/kfsbyigzqv/1-04.%20Death.mp3",
                title = "Death"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/mngbhcaiiu/1-05.%20Living%20Mice.mp3",
                title = "Living Mice"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/kiwsgdpwbs/1-06.%20Moog%20City.mp3",
                title = "Moog City"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/abtibsbmth/1-07.%20Haggstrom.mp3",
                title = "Haggstrom"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/esiyjzozpe/1-08.%20Minecraft.mp3",
                title = "Minecraft"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/tcsevdqpff/1-09.%20Oxyg%C3%A8ne.mp3",
                title = "Oxygene"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/binsaphxyd/1-10.%20%C3%89quinoxe.mp3",
                title = "Equinoxe"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/fjdholnupc/1-11.%20Mice%20on%20Venus.mp3",
                title = "Mice on Venus"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/gxvzdgcklj/1-12.%20Dry%20Hands.mp3",
                title = "Dry Hands"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/roykrzlshq/1-13.%20Wet%20Hands.mp3",
                title = "Wet Hands"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/dnrkrrlpmm/1-14.%20Clark.mp3",
                title = "Clark"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/uioquamvbx/1-15.%20Chris.mp3",
                title = "Chris"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/vkokiefjgc/1-16.%20Thirteen.mp3",
                title = "Thirteen"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/jvyezexkts/1-17.%20Excuse.mp3",
                title = "Excuse"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/kvptjmornx/1-18.%20Sweden.mp3",
                title = "Sweden"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/biwkbeziap/1-19.%20Cat.mp3",
                title = "Cat"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/uvozbgkhpf/1-20.%20Dog.mp3",
                title = "Dog"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/limpitozea/1-21.%20Danny.mp3",
                title = "Danny"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/ocrplluknq/1-22.%20Beginning.mp3",
                title = "Beginning"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/cajmirmrja/1-23.%20Droopy%20likes%20ricochet.mp3",
                title = "Droopy likes ricochet"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/mxubqwgrwn/1-24.%20Droopy%20likes%20your%20face.mp3",
                title = "Droopy likes your face"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/wjbbglwjte/2-01.%20Ki.mp3",
                title = "Ki"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/jbdlypwnmr/2-02.%20Alpha.mp3",
                title = "Alpha"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/lljuaowpnc/2-03.%20Dead%20Voxel.mp3",
                title = "Dead Voxel"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/npdaqyidiz/2-04.%20Blind%20Spots.mp3",
                title = "Blind Spots"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/grsvnrsbwc/2-05.%20Flake.mp3",
                title = "Flake"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/xbzorexttx/2-06.%20Moog%20City%202.mp3",
                title = "Moog City 2"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/rgmithopig/2-07.%20Concrete%20Halls.mp3",
                title = "Concerte Halls"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/cogwlnpsua/2-08.%20Biome%20Fest.mp3",
                title = "Biome Fest"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/kqoglnxcfg/2-09.%20Mutation.mp3",
                title = "Mutation"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/ntkobdwjgn/2-10.%20Haunt%20Muskie.mp3",
                title = "Haunt Muskie"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/jujebwiuet/2-11.%20Warmth.mp3",
                title = "Warmth"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/qoifaxoelu/2-12.%20Floating%20Trees.mp3",
                title = "Floating Trees"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/fbluiiwvgz/2-13.%20Aria%20Math.mp3",
                title = "Aria Math"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/wgbyzxgnsc/2-14.%20Kyoto.mp3",
                title = "Koyto"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/jxpwldawxo/2-15.%20Ballad%20of%20the%20Cats.mp3",
                title = "Ballad of the Cats"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/zcysbdlxqf/2-16.%20Taswell.mp3",
                title = "Taswell"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/wdevwgadgp/2-17.%20Beginning%202.mp3",
                title = "Beginning 2"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/mixwnvyuft/2-18.%20Dreiton.mp3",
                title = "Dreiton"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/fopyrozcbf/2-19.%20The%20End.mp3",
                title = "The End"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/adxomiqwds/2-20.%20Chirp.mp3",
                title = "Chirp"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/lqtvgglkpt/2-21.%20Wait.mp3",
                title = "Wait"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/gmbkrizoms/2-22.%20Mellohi.mp3",
                title = "Mellohi"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/xfhfthynex/2-23.%20Stal.mp3",
                title = "Stal"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/cjbcnsbzuc/2-24.%20Strad.mp3",
                title = "Strad"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/ybowatzyhq/2-25.%20Eleven.mp3",
                title = "Eleven"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/tckywuliok/2-26.%20Ward.mp3",
                title = "Ward"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/ceyvprghoc/2-27.%20Mall.mp3",
                title = "Mall"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/ewlpcvyido/2-28.%20Blocks.mp3",
                title = "Block"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/wmrtxvcbce/2-29.%20Far.mp3",
                title = "Far"
            },
            {
                url = "https://vgmsite.com/soundtracks/minecraft/bjbdzgxmgi/2-30.%20Intro.mp3",
                title = "Intro"
            }
        })
    end, waitCount)
end
function SetTabletopAudioPlaylist()
    StopPlaylist()

    Wait.time(function()
        MusicPlayer.setPlaylist({
            {
                url = "https://sounds.tabletopaudio.com/405_Brood_Mother.mp3",
                title = "Brood Mother"
            },
            {
                url = "https://sounds.tabletopaudio.com/406_Treacherous_Path.mp3",
                title = "Treacherous Path"
            },
            {
                url = "https://sounds.tabletopaudio.com/408_Nautiloid_Escape.mp3",
                title = "Nautiloid Escape"
            },
            {
                url = "https://sounds.tabletopaudio.com/407_Viking_Tavern.mp3",
                title = "Viking Tavern"
            },
            {
                url = "https://sounds.tabletopaudio.com/404_Vampyr.mp3",
                title = "Vampyr"
            },
            {
                url = "https://sounds.tabletopaudio.com/403_Steel_Foundry.mp3",
                title = "Steel Foundry"
            },
            {
                url = "https://sounds.tabletopaudio.com/402_The_Drowned_Tower.mp3",
                title = "The Drowned Tower"
            },
            {
                url = "https://sounds.tabletopaudio.com/401_Feast_of_Crispian.mp3",
                title = "Feast of Crispian"
            },
            {
                url = "https://sounds.tabletopaudio.com/400_Whispering_Caverns.mp3",
                title = "Whispering Caverns"
            },
            {
                url = "https://sounds.tabletopaudio.com/399_Whiteout.mp3",
                title = "Whiteout"
            },
            {
                url = "https://sounds.tabletopaudio.com/398_The_Misty_Marsh.mp3",
                title = "The Misty Marsh"
            },
            {
                url = "https://sounds.tabletopaudio.com/397_Homecoming.mp3",
                title = "Homecoming"
            },
            {
                url = "https://sounds.tabletopaudio.com/394_Demon_Army.mp3",
                title = "Demon Army"
            },
            {
                url = "https://sounds.tabletopaudio.com/393_Hellhound_Alley.mp3",
                title = "Hellhound Alley"
            },
            {
                url = "https://sounds.tabletopaudio.com/390_Desert_Devotional.mp3",
                title = "Desert Devotional"
            },
            {
                url = "https://sounds.tabletopaudio.com/389_Medieval_Market.mp3",
                title = "Medieval Market"
            },
            {
                url = "https://sounds.tabletopaudio.com/388_Lord_of_Bones.mp3",
                title = "Lord of Bones"
            },
            {
                url = "https://sounds.tabletopaudio.com/384_Western_Watchtower.mp3",
                title = "Western Watchtower"
            },
            {
                url = "https://sounds.tabletopaudio.com/383_Banshees_Lair.mp3",
                title = "Banshees Lair"
            },
            {
                url = "https://sounds.tabletopaudio.com/382_Long_Rest.mp3",
                title = "Long Rest"
            },
            {
                url = "https://sounds.tabletopaudio.com/381_Halfling_Sneak.mp3",
                title = "Halfling Sneak"
            },
            {
                url = "https://sounds.tabletopaudio.com/380_The_Great_Lift.mp3",
                title = "The Great Lift"
            },
            {
                url = "https://sounds.tabletopaudio.com/378_Descent.mp3",
                title = "Descent"
            },
            {
                url = "https://sounds.tabletopaudio.com/377_Through_the_Woods.mp3",
                title = "Through the Woods"
            },
            {
                url = "https://sounds.tabletopaudio.com/376_Voyage_Begins.mp3",
                title = "Voyage Begins"
            },
            {
                url = "https://sounds.tabletopaudio.com/375_Rise_of_the_Golem.mp3",
                title = "Rise of the Golem"
            },
            {
                url = "https://sounds.tabletopaudio.com/374_Hall_of_Angels.mp3",
                title = "Hall of Angels"
            },
            {
                url = "https://sounds.tabletopaudio.com/373_Infernal_Machine.mp3",
                title = "Infernal Machine"
            },
            {
                url = "https://sounds.tabletopaudio.com/372_Den_of_Iniquity.mp3",
                title = "Den of Iniquity"
            },
            {
                url = "https://sounds.tabletopaudio.com/371_Whirlpool.mp3",
                title = "Whirlpool"
            },
            {
                url = "https://sounds.tabletopaudio.com/369_Troll_Grotto.mp3",
                title = "Troll Grotto"
            },
            {
                url = "https://sounds.tabletopaudio.com/368_Ghosts_of_Appalachia.mp3",
                title = "Ghosts of Appalachia"
            },
            {
                url = "https://sounds.tabletopaudio.com/367_Rope_Bridge.mp3",
                title = "Rope Bridge"
            },
            {
                url = "https://sounds.tabletopaudio.com/366_Rocs_Nest.mp3",
                title = "Rocs Nest"
            },
            {
                url = "https://sounds.tabletopaudio.com/365_Trail_of_Ashes.mp3",
                title = "Trail of Ashes"
            },
            {
                url = "https://sounds.tabletopaudio.com/364_River_of_Blood.mp3",
                title = "River of Blood"
            },
            {
                url = "https://sounds.tabletopaudio.com/362_Rolling_Emporium.mp3",
                title = "Rolling Emporium"
            },
            {
                url = "https://sounds.tabletopaudio.com/361_Ancient_Beacon.mp3",
                title = "Ancient Beacon"
            },
            {
                url = "https://sounds.tabletopaudio.com/360_Pit_Fighter.mp3",
                title = "Pit Fighter"
            },
            {
                url = "https://sounds.tabletopaudio.com/359_Skull_Island.mp3",
                title = "Skull Island"
            },
            {
                url = "https://sounds.tabletopaudio.com/358_Egg_Chamber.mp3",
                title = "Egg Chamber"
            },
            {
                url = "https://sounds.tabletopaudio.com/357_Promontory.mp3",
                title = "Promontory"
            },
            {
                url = "https://sounds.tabletopaudio.com/356_Adventure_Begins.mp3",
                title = "Adventure Begins"
            },
            {
                url = "https://sounds.tabletopaudio.com/354_Warlocks_Whisper.mp3",
                title = "Warlocks Whisper"
            },
            {
                url = "https://sounds.tabletopaudio.com/353_Spirit_of_the_Plains.mp3",
                title = "Spirit of the Plains"
            },
            {
                url = "https://sounds.tabletopaudio.com/352_Black_Rider.mp3",
                title = "Black Rider"
            },
            {
                url = "https://sounds.tabletopaudio.com/351_Halfling_Lodge.mp3",
                title = "Halfling Lodge"
            },
            {
                url = "https://sounds.tabletopaudio.com/349_Puzzle_Dungeon.mp3",
                title = "Puzzle Dungeon"
            },
            {
                url = "https://sounds.tabletopaudio.com/348_Viking_Village.mp3",
                title = "Viking Village"
            },
            {
                url = "https://sounds.tabletopaudio.com/347_Elven_Procession.mp3",
                title = "Elven Procession"
            },
            {
                url = "https://sounds.tabletopaudio.com/344_Yokai_Forest.mp3",
                title = "Yokai Forest"
            },
            {
                url = "https://sounds.tabletopaudio.com/343_Dungeon_Collapse.mp3",
                title = "Dungeon Collapse"
            },
            {
                url = "https://sounds.tabletopaudio.com/342_Tavern_Celebration.mp3",
                title = "Tavern Celebration"
            },
            {
                url = "https://sounds.tabletopaudio.com/341_Beggars_Rest.mp3",
                title = "Beggars Rest"
            },
            {
                url = "https://sounds.tabletopaudio.com/338_Adventure_Supply.mp3",
                title = "Adventure Supply"
            },
            {
                url = "https://sounds.tabletopaudio.com/337_Village_of_the_Damned.mp3",
                title = "Village of the Damned"
            },
            {
                url = "https://sounds.tabletopaudio.com/336_Medieval_Banquet.mp3",
                title = "Medieval Banquet"
            },
            {
                url = "https://sounds.tabletopaudio.com/335_Abandoned_Chapel.mp3",
                title = "Abandoned Chapel"
            },
            {
                url = "https://sounds.tabletopaudio.com/334_Harpies_Nest.mp3",
                title = "Harpies Nest"
            },
            {
                url = "https://sounds.tabletopaudio.com/333_Arcane_Athenaeum.mp3",
                title = "Arcane Athenaeum"
            },
            {
                url = "https://sounds.tabletopaudio.com/332_Myconid_Colony.mp3",
                title = "Myconid Colony"
            },
            {
                url = "https://sounds.tabletopaudio.com/331_Drowned_Sailors.mp3",
                title = "Drowned Sailors"
            },
            {
                url = "https://sounds.tabletopaudio.com/329_Desert_Temple.mp3",
                title = "Desert Temple"
            },
            {
                url = "https://sounds.tabletopaudio.com/328_Battle_Requiem.mp3",
                title = "Battle Requiem"
            },
            {
                url = "https://sounds.tabletopaudio.com/321_Invisible_Mountain.mp3",
                title = "Invisible Mountain"
            },
            {
                url = "https://sounds.tabletopaudio.com/320_Cultists_Cavern.mp3",
                title = "Cultists Cavern"
            },
            {
                url = "https://sounds.tabletopaudio.com/319_Shamans_Hollow.mp3",
                title = "Shamans Hollow"
            },
            {
                url = "https://sounds.tabletopaudio.com/318_The_Gaping_Maw.mp3",
                title = "The Gaping Maw"
            },
            {
                url = "https://sounds.tabletopaudio.com/316_Goblin_Ambush.mp3",
                title = "Goblin Ambush"
            },
            {
                url = "https://sounds.tabletopaudio.com/315_Dragon_Rider.mp3",
                title = "Dragon Rider"
            },
            {
                url = "https://sounds.tabletopaudio.com/314_Shuttle_Crash.mp3",
                title = "Shuttle Crash"
            },
            {
                url = "https://sounds.tabletopaudio.com/313_Dusk_of_the_Dryad.mp3",
                title = "Dusk of the Dryad"
            },
            {
                url = "https://sounds.tabletopaudio.com/311_Swamp_Thing.mp3",
                title = "Swamp Thing"
            },
            {
                url = "https://sounds.tabletopaudio.com/309_Bloodgate.mp3",
                title = "Bloodgate"
            },
            {
                url = "https://sounds.tabletopaudio.com/308_Skullwharf.mp3",
                title = "Skullwharf"
            },
            {
                url = "https://sounds.tabletopaudio.com/305_Hidden_Valley.mp3",
                title = "Hidden Valley"
            },
            {
                url = "https://sounds.tabletopaudio.com/304_Fog_of_War.mp3",
                title = "Fog of War"
            },
            {
                url = "https://sounds.tabletopaudio.com/303_Summoning.mp3",
                title = "Summoning"
            },
            {
                url = "https://sounds.tabletopaudio.com/302_Floating_Market.mp3",
                title = "Floating Market"
            },
            {
                url = "https://sounds.tabletopaudio.com/301_Pool_of_Radiance.mp3",
                title = "Pool of Radiance"
            },
            {
                url = "https://sounds.tabletopaudio.com/299_Necropolis.mp3",
                title = "Necropolis"
            },
            {
                url = "https://sounds.tabletopaudio.com/298_Gateway_to_Hell.mp3",
                title = "Gateway to Hell"
            },
            {
                url = "https://sounds.tabletopaudio.com/297_Survivors_Bivouac.mp3",
                title = "Survivors Bivouac"
            },
            {
                url = "https://sounds.tabletopaudio.com/294_Cutpurse_Pursuit.mp3",
                title = "Cutpurse Pursuit"
            },
            {
                url = "https://sounds.tabletopaudio.com/290_Wagon_Ride.mp3",
                title = "Wagon Ride"
            },
            {
                url = "https://sounds.tabletopaudio.com/289_Ancient_Artifact.mp3",
                title = "Ancient Artifact"
            },
            {
                url = "https://sounds.tabletopaudio.com/288_Everdeep.mp3",
                title = "Everdeep"
            },
            {
                url = "https://sounds.tabletopaudio.com/287_The_Strange.mp3",
                title = "The Strange"
            },
            {
                url = "https://sounds.tabletopaudio.com/286_Blastfire_Bog.mp3",
                title = "Blastfire Bog"
            },
            {
                url = "https://sounds.tabletopaudio.com/285_High_Rannoc_Village.mp3",
                title = "High Rannoc Village"
            },
            {
                url = "https://sounds.tabletopaudio.com/284_Oasis_City.mp3",
                title = "Oasis City"
            },
            {
                url = "https://sounds.tabletopaudio.com/282_The_Wild_Hunt.mp3",
                title = "The Wild Hunt"
            },
            {
                url = "https://sounds.tabletopaudio.com/281_Escape_from_Shadow.mp3",
                title = "Escape from Shadow"
            },
            {
                url = "https://sounds.tabletopaudio.com/279_Blighted_Farm.mp3",
                title = "Blighted Farm"
            },
            {
                url = "https://sounds.tabletopaudio.com/278_Farmyard.mp3",
                title = "Farmyard"
            },
            {
                url = "https://sounds.tabletopaudio.com/277_A_New_Beginning.mp3",
                title = "A New Beginning"
            },
            {
                url = "https://sounds.tabletopaudio.com/276_Forge_of_Fury.mp3",
                title = "Forge of Fury"
            },
            {
                url = "https://sounds.tabletopaudio.com/275_Lorekeeper_Grove.mp3",
                title = "Lorekeeper_Grove"
            },
            {
                url = "https://sounds.tabletopaudio.com/274_Jungle_Shaman.mp3",
                title = "Jungle Shaman"
            },
            {
                url = "https://sounds.tabletopaudio.com/273_Arcane_Clockworks.mp3",
                title = "Arcane Clockworks"
            },
            {
                url = "https://sounds.tabletopaudio.com/267_Court_of_the_Count.mp3",
                title = "Court of the Count"
            },
            {
                url = "https://sounds.tabletopaudio.com/265_Shrine_of_Talos.mp3",
                title = "Shrine of Talos"
            },
            {
                url = "https://sounds.tabletopaudio.com/263_Mysterious_Grotto.mp3",
                title = "Mysterious Grotto"
            },
            {
                url = "https://sounds.tabletopaudio.com/261_Unto_the_Breach.mp3",
                title = "Unto the Breach"
            },
            {
                url = "https://sounds.tabletopaudio.com/260_Skyship.mp3",
                title = "Skyship"
            },
            {
                url = "https://sounds.tabletopaudio.com/258_Blighted_Forest.mp3",
                title = "Blighted Forest"
            },
            {
                url = "https://sounds.tabletopaudio.com/257_Country_Workshop.mp3",
                title = "Country Workshop"
            },
            {
                url = "https://sounds.tabletopaudio.com/256_Ice_Dragon.mp3",
                title = "Ice Dragon"
            },
            {
                url = "https://sounds.tabletopaudio.com/255_The_Hearth_Inn.mp3",
                title = "The Hearth Inn"
            },
            {
                url = "https://sounds.tabletopaudio.com/254_Desert_Planet_Souk.mp3",
                title = "Desert Planet Souk"
            },
            {
                url = "https://sounds.tabletopaudio.com/253_Submerged.mp3",
                title = "Submerged"
            },
            {
                url = "https://sounds.tabletopaudio.com/252_Vault_of_Terror.mp3",
                title = "Vault of Terror"
            },
            {
                url = "https://sounds.tabletopaudio.com/251_Candledeep.mp3",
                title = "Candledeep"
            },
            {
                url = "https://sounds.tabletopaudio.com/250_Wolf_Pens.mp3",
                title = "Wolf Pens"
            },
            {
                url = "https://sounds.tabletopaudio.com/249_Steampunk_Station.mp3",
                title = "Steampunk Station"
            },
            {
                url = "https://sounds.tabletopaudio.com/246_Magic_Shoppe.mp3",
                title = "Magic Shoppe"
            },
            {
                url = "https://sounds.tabletopaudio.com/244_Vikings.mp3",
                title = "Vikings"
            },
            {
                url = "https://sounds.tabletopaudio.com/243_Jungle_Ruins.mp3",
                title = "Jungle Ruins"
            },
            {
                url = "https://sounds.tabletopaudio.com/242_Spiders_Den.mp3",
                title = "Spiders Den"
            },
            {
                url = "https://sounds.tabletopaudio.com/241_Pirates.mp3",
                title = "Pirates"
            },
            {
                url = "https://sounds.tabletopaudio.com/240_Throne_Room.mp3",
                title = "Throne Room"
            },
            {
                url = "https://sounds.tabletopaudio.com/238_Mind_Flayer_Chamber.mp3",
                title = "Mind Flayer Chamber"
            },
            {
                url = "https://sounds.tabletopaudio.com/237_Training_Grounds.mp3",
                title = "Training Grounds"
            },
            {
                url = "https://sounds.tabletopaudio.com/236_Defiled_Temple.mp3",
                title = "Defiled Temple"
            },
            {
                url = "https://sounds.tabletopaudio.com/235_Rainy_Village.mp3",
                title = "Rainy Village"
            },
            {
                url = "https://sounds.tabletopaudio.com/234_Lush_World.mp3",
                title = "Lush World"
            },
            {
                url = "https://sounds.tabletopaudio.com/233_The_Orrery.mp3",
                title = "The Orrery"
            },
            {
                url = "https://sounds.tabletopaudio.com/231_Icebound_Town.mp3",
                title = "Icebound Town"
            },
            {
                url = "https://sounds.tabletopaudio.com/230_All_Hallows_Eve.mp3",
                title = "All Hallows Eve"
            },
            {
                url = "https://sounds.tabletopaudio.com/228_Mushroom_Forest.mp3",
                title = "Mushroom_Forest"
            },
            {
                url = "https://sounds.tabletopaudio.com/223_Salt_Marsh.mp3",
                title = "Salt_Marsh"
            },
            {
                url = "https://sounds.tabletopaudio.com/222_Wuxia_Tea_House.mp3",
                title = "Wuxia_Tea_House"
            },
            {
                url = "https://sounds.tabletopaudio.com/220_Wuxia_Village.mp3",
                title = "Wuxia_Village"
            },
            {
                url = "https://sounds.tabletopaudio.com/219_Tinkerers_Workshop.mp3",
                title = "Tinkerers_Workshop"
            },
            {
                url = "https://sounds.tabletopaudio.com/218_Sleeping_Ogre.mp3",
                title = "Sleeping_Ogre"
            },
            {
                url = "https://sounds.tabletopaudio.com/216_Waterkeep_Night.mp3",
                title = "Waterkeep_Night"
            },
            {
                url = "https://sounds.tabletopaudio.com/214_Castle_Kitchen.mp3",
                title = "Castle_Kitchen"
            },
            {
                url = "https://sounds.tabletopaudio.com/213_Burning_Village.mp3",
                title = "Burning_Village"
            },
            {
                url = "https://sounds.tabletopaudio.com/210_Temple_Garden.mp3",
                title = "Temple_Garden"
            },
            {
                url = "https://sounds.tabletopaudio.com/208_Ghost_Town.mp3",
                title = "Ghost Town"
            },
            {
                url = "https://sounds.tabletopaudio.com/206_Heart_High_Rise.mp3",
                title = "Heart High Rise"
            },
            {
                url = "https://sounds.tabletopaudio.com/205_Heart_Absolution.mp3",
                title = "Heart Absolution"
            },
            {
                url = "https://sounds.tabletopaudio.com/204_Heart_Meat_Corridor.mp3",
                title = "Heart Meat Corridor"
            },
            {
                url = "https://sounds.tabletopaudio.com/203_Heart_Briar.mp3",
                title = "Heart Briar"
            },
            {
                url = "https://sounds.tabletopaudio.com/202_Heart_Drowned.mp3",
                title = "Heart Drowned"
            },
            {
                url = "https://sounds.tabletopaudio.com/200_Druid_Hilltop.mp3",
                title = "Druid_Hilltop"
            },
            {
                url = "https://sounds.tabletopaudio.com/199_Sun_Dappled_Trail.mp3",
                title = "Sun_Dappled_Trail"
            },
            {
                url = "https://sounds.tabletopaudio.com/198_Shadowfell.mp3",
                title = "Shadowfell"
            },
            {
                url = "https://sounds.tabletopaudio.com/197_Battle_of_the_Amazons.mp3",
                title = "Battle_of_the_Amazons"
            },
            {
                url = "https://sounds.tabletopaudio.com/196_Crossing_the_Styx.mp3",
                title = "Crossing the Styx"
            },
            {
                url = "https://sounds.tabletopaudio.com/194_Tarrasque_Interior.mp3",
                title = "Tarrasque Interior"
            },
            {
                url = "https://sounds.tabletopaudio.com/192_Swamp_Planet.mp3",
                title = "Swamp Planet"
            },
            {
                url = "https://sounds.tabletopaudio.com/191_Dying_World.mp3",
                title = "Dying World"
            },
            {
                url = "https://sounds.tabletopaudio.com/188_Barovian_Village.mp3",
                title = "Barovian Village"
            },
            {
                url = "https://sounds.tabletopaudio.com/184_Underground_Lake.mp3",
                title = "Underground Lake"
            },
            {
                url = "https://sounds.tabletopaudio.com/183_Sea_of_Moving_Ice.mp3",
                title = "Sea of Moving Ice"
            },
            {
                url = "https://sounds.tabletopaudio.com/182_Country_Village.mp3",
                title = "Country Village"
            },
            {
                url = "https://sounds.tabletopaudio.com/180_Abandoned_Windmill.mp3",
                title = "Abandoned Windmill"
            },
            {
                url = "https://sounds.tabletopaudio.com/178_Ice_Throne.mp3",
                title = "Ice Throne"
            },
            {
                url = "https://sounds.tabletopaudio.com/177_Tavern_Music.mp3",
                title = "Tavern Music"
            },
            {
                url = "https://sounds.tabletopaudio.com/176_Barren_Wastes.mp3",
                title = "Barren Wastes"
            },
            {
                url = "https://sounds.tabletopaudio.com/175_Royal_Court.mp3",
                title = "Royal Court"
            },
            {
                url = "https://sounds.tabletopaudio.com/174_Wizards_Tower.mp3",
                title = "Wizards Tower"
            },
            {
                url = "https://sounds.tabletopaudio.com/172_Castle_Jail.mp3",
                title = "Castle Jail"
            },
            {
                url = "https://sounds.tabletopaudio.com/170_The_Underdark.mp3",
                title = "The Underdark"
            },
            {
                url = "https://sounds.tabletopaudio.com/169_The_Feywild.mp3",
                title = "The Feywild"
            },
            {
                url = "https://sounds.tabletopaudio.com/167_Fishing_Village.mp3",
                title = "Fishing Village"
            },
            {
                url = "https://sounds.tabletopaudio.com/166_Quiet_Cove.mp3",
                title = "Quiet Cove"
            },
            {
                url = "https://sounds.tabletopaudio.com/164_Cistern.mp3",
                title = "Cistern"
            },
            {
                url = "https://sounds.tabletopaudio.com/163_Medieval_Fair.mp3",
                title = "Medieval Fair"
            },
            {
                url = "https://sounds.tabletopaudio.com/161_Forest_Day.mp3",
                title = "Forest Day"
            },
            {
                url = "https://sounds.tabletopaudio.com/159_Stables.mp3",
                title = "Stables"
            },
            {
                url = "https://sounds.tabletopaudio.com/158_Waterkeep.mp3",
                title = "Waterkeep"
            },
            {
                url = "https://sounds.tabletopaudio.com/153_Secret_Garden.mp3",
                title = "Secret Garden"
            },
            {
                url = "https://sounds.tabletopaudio.com/148_Barovian_Castle.mp3",
                title = "Barovian Castle"
            },
            {
                url = "https://sounds.tabletopaudio.com/147_Graveyard.mp3",
                title = "Graveyard"
            },
            {
                url = "https://sounds.tabletopaudio.com/146_Floating_Ice_Castle.mp3",
                title = "Floating Ice Castle"
            },
            {
                url = "https://sounds.tabletopaudio.com/142_Mummys_Tomb.mp3",
                title = "Mummys Tomb"
            },
            {
                url = "https://sounds.tabletopaudio.com/141_Hermit_Hut.mp3",
                title = "Hermit Hut"
            },
            {
                url = "https://sounds.tabletopaudio.com/139_Sunken_Temple.mp3",
                title = "Sunken Temple"
            },
            {
                url = "https://sounds.tabletopaudio.com/137_Mill_Town_a.mp3",
                title = "Mill Town a"
            },
            {
                url = "https://sounds.tabletopaudio.com/136_Temple_Of_Helm.mp3",
                title = "Temple Of Helm"
            },
            {
                url = "https://sounds.tabletopaudio.com/135_Dark_Matter.mp3",
                title = "Dark Matter"
            },
            {
                url = "https://sounds.tabletopaudio.com/134_Carriage_Journey.mp3",
                title = "Carriage Journey"
            },
            {
                url = "https://sounds.tabletopaudio.com/133_Halfling_Festival.mp3",
                title = "Halfling Festival"
            },
            {
                url = "https://sounds.tabletopaudio.com/131_The_Bog_Standard.mp3",
                title = "The Bog Standard"
            },
            {
                url = "https://sounds.tabletopaudio.com/124_Spire_The_Vermissian.mp3",
                title = "Spire The Vermissian"
            },
            {
                url = "https://sounds.tabletopaudio.com/123_Spire_The_Hatchery.mp3",
                title = "Spire The Hatchery"
            },
            {
                url = "https://sounds.tabletopaudio.com/102_Vampire_Castle.mp3",
                title = "Vampire Castle"
            },
            {
                url = "https://sounds.tabletopaudio.com/104_River_Town.mp3",
                title = "River Town"
            },
            {
                url = "https://sounds.tabletopaudio.com/114_Dwarven_City.mp3",
                title = "Dwarven City"
            },
            {
                url = "https://sounds.tabletopaudio.com/99_Cavern_of_Lost_Souls.mp3",
                title = "Cavern of Lost Souls"
            },
            {
                url = "https://sounds.tabletopaudio.com/98_Lost_Mine.mp3",
                title = "Lost Mine"
            },
            {
                url = "https://sounds.tabletopaudio.com/91_Elven_Glade.mp3",
                title = "Elven Glade"
            },
            {
                url = "https://sounds.tabletopaudio.com/64_Mountain_Pass.mp3",
                title = "Mountain Pass"
            },
            {
                url = "https://sounds.tabletopaudio.com/56_Medieval_Town.mp3",
                title = "Medieval Town"
            },
            {
                url = "https://sounds.tabletopaudio.com/49_Goblin's_Cave.mp3",
                title = "Goblins Cave"
            },
            {
                url = "https://sounds.tabletopaudio.com/8_New_Dust_to_Dust.mp3",
                title = "Dust to Dust"
            },
            {
                url = "https://sounds.tabletopaudio.com/46_Cathedral.mp3",
                title = "Cathedral"
            },
            {
                url = "https://sounds.tabletopaudio.com/47_There_be_Dragons.mp3",
                title = "There be Dragons"
            }
        })
    end, waitCount)
end
function SetFearHungerPlaylist()
    StopPlaylist()

    Wait.time(function()
        MusicPlayer.setPlaylist({
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/qoziqxyrko/01.%20Ghostpocalypse%20-%205%20Apotheosis.mp3",
                title = "Ghostpocalypse"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/glldnottso/02.%20Fear%20%26%20Hunger.mp3",
                title = "Fear & Hunger"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/yquheusvgi/03.%20Eastern%20Wind.mp3",
                title = "Easten Wind"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/hdrdgfzgry/04.%20Minor%20Terror.mp3",
                title = "Minor Terror"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/bvcjhsxkhd/05.%20Basement%20of%20Flies.mp3",
                title = "Basement of Flies"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/cfijxytiyj/06.%20Mist%20Jingle.mp3",
                title = "Mist Jingle"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/pxmsbuicui/07.%20Muted%20Aggression.mp3",
                title = "Muted Aggression"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/iuqpscwynm/08.%20The%20Four%20Apostles.mp3",
                title = "The Four Apostles"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/qitpzorclo/09.%20God%20of%20the%20Depths.mp3",
                title = "God of the Depths"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/bsqufqtttt/10.%20Creaking%20Throat%20of%20a%20God.mp3",
                title = "Creaking Throat of God"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/dxntoirfyg/11.%20Tomb%20of%20the%20Gods.mp3",
                title = "Tomb of the Gods"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/tltwugmiwv/12.%20Ancient%20City.mp3",
                title = "Ancient City"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/siheldcsws/13.%20Endless%20Loop.mp3",
                title = "Endless Loop"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/gaatepeqbh/14.%20Ma%27habre%20Streets.mp3",
                title = "Mahabre Streets"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/fjytxwppcj/15.%20Song%20for%20Torment.mp3",
                title = "Song for Torment"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/kobqjnpxpw/16.%20The%20Gauntlet.mp3",
                title = "The Gauntlet"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/ofkizdhygd/17.%20Pulse%20and%20Anxiety.mp3",
                title = "Pulse and Anxiety"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/pmoroomimg/18.%20The%20Ascension.mp3",
                title = "The Ascension"
            },
            {
                url = "https://kappa.vgmsite.com/soundtracks/fear-hunger-windows-gamerip-2018/kwvkrdmkvh/19.%20Prelude%20to%20Darkness.mp3",
                title = "Prelude to Darkness"
            }
        })
    end, waitCount)
end
function SetRisenRPlaylist()
    StopPlaylist()

    Wait.time(function()
        MusicPlayer.setPlaylist({
            {
                url = "",
                title = ""
            },
        })
    end, waitCount)
end
function SetRisenBPlaylist()
    StopPlaylist()

    Wait.time(function()
        MusicPlayer.setPlaylist({
            {
                url = "",
                title = ""
            },
        })
    end, waitCount)
end
function SetBattlePlaylist()
    StopPlaylist()

    Wait.time(function()
        MusicPlayer.setPlaylist({
            {
                url = "https://sounds.tabletopaudio.com/430_Fire_Dance.mp3",
                title = "Fire Dance"
            },
            {
                url = "https://sounds.tabletopaudio.com/374_Hall_of_Angels.mp3",
                title = "Hall of Angels"
            },
            {
                url = "https://sounds.tabletopaudio.com/377_Through_the_Woods.mp3",
                title = "Though the Woods"
            },
            {
                url = "https://sounds.tabletopaudio.com/373_Infernal_Machine.mp3",
                title = "Infernal Machine"
            },
            {
                url = "https://sounds.tabletopaudio.com/352_Black_Rider.mp3",
                title = "Black Rider"
            },
            --[[{
                url = "",
                title = ""
            },]]
        })
    end, waitCount)
end

function PrevMusic()
    Wait.time(function()
        MusicPlayer.skipBack()
        MusicPlayer.skipBack()
    end, waitCount)
end
function PlayPlaylist()
    StopPlaylist()
    Wait.time(function()
        MusicPlayer.play()
    end, waitCount)
end
function StopPlaylist()
    MusicPlayer.pause()
end
function NextMusic()
    Wait.time(function()
        MusicPlayer.skipForward()
    end, waitCount)
end
function StartPlaylistPlay()
    Wait.time(|| MusicPlayer.setCurrentAudioclip(MusicPlayer.getPlaylist()[1]), waitCount + 0.1)
end