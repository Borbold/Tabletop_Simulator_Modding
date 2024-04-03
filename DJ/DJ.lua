function onLoad(savedData)
    waitCount = 0.4
    StopPlaylist()
end

function SetMinecraftPlaylist()
    StopPlaylist()

    MusicPlayer.setCurrentAudioclip({
        url = "https://vgmsite.com/soundtracks/minecraft/aoqfyvljpe/1-01.%20Key.mp3",
        title = "Key"
    })
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

    MusicPlayer.setCurrentAudioclip({
        url = "https://sounds.tabletopaudio.com/405_Brood_Mother.mp3",
        title = "Brood Mother"
    })
    Wait.time(function()
        MusicPlayer.setPlaylist({
            {
                url = "https://sounds.tabletopaudio.com/405_Brood_Mother.mp3",
                title = "Brood Mother"
            }
        })
    end, waitCount)
end

function PrevMusic()
    Wait.time(function()
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