package contents.soundControll
{
	import contents.Contents;
	
	import flash.display.Stage;
	import flash.net.SharedObject;
	
	import soundPlayer.SoundPlayer;

	public class ContentSoundManager
	{
		public static const MusicID:uint = 1001,
							MusicID2:uint = 1004,
							EffectsID:uint = 1002,
							NarationID:uint = 1003;
		
		private static var lastMusicState:SharedObject = SharedObject.getLocal('lastMusicState','/');
		
		/**This is the last playing music*/
		private static var lastPlayingMusic:String ;
		
		/**2 sound id to swap musics smoothly*/
		private static var currentSoundId:uint,
							otherSoundId:uint;
							
		public static function setUp(myStage:Stage)
		{
			currentSoundId = Contents.id_music ;
			otherSoundId = Contents.id_music2 ;
			
			SoundPlayer.setUp(myStage,true,false);
			//SoundPlayer.addSound(Contents.homePage.musicURL,Contents.id_music,true,1);
			changeMainMusic();
			
			if(lastMusicState.data.state == undefined)
			{
				lastMusicState.data.state = true ;
				lastMusicState.flush();
			}
			
			if(lastMusicState.data.state)
			{
				SoundPlayer.play(MusicID);
			}
		}
		
		public static function get MusicIsPlaying():Boolean
		{
			return SoundPlayer.getStatuse_pause(MusicID);
		}
		
		public static function startMusic()
		{
			SoundPlayer.play(MusicID);
			lastMusicState.data.state = true ;
			lastMusicState.flush();
		}
		
		public static function pauseMusic()
		{
			SoundPlayer.pause(MusicID);
			lastMusicState.data.state = false ;
			lastMusicState.flush();
		}
		
		public static function muteMusic()
		{
			SoundPlayer.volumeContril(MusicID,0);
		}
		
		public static function unMuteMusit()
		{
			SoundPlayer.volumeContril(MusicID,1);
		}
		
		/**This will change the current playing music ( not tested yet )*/
		public static function changeMainMusic(musicURL:String='',volume:Number=1):void
		{
			// TODO Auto Generated method stub
			trace("Change the music to : "+musicURL);
			trace("Change volume to : "+volume);
			SoundPlayer.pause(MusicID);
			if(musicURL=='')
			{
				musicURL = Contents.homePage.musicURL ;
			}
			if(lastPlayingMusic == musicURL)
			{
				trace("Music is duplicated on ContentSoundManager.changeMainMusic : "+musicURL);
				return ;
			}
			SoundPlayer.pause(currentSoundId);
			SoundPlayer.addSound(musicURL,otherSoundId,true,volume);
			SoundPlayer.play(otherSoundId);
			
			lastPlayingMusic = musicURL ;
			
			otherSoundId = otherSoundId+currentSoundId ;
			currentSoundId = otherSoundId-currentSoundId ;
			otherSoundId = otherSoundId-currentSoundId;
		}
	}
}