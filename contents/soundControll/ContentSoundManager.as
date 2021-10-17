package contents.soundControll
{
	import contents.Contents;
	
	import flash.display.Stage;
	import flash.media.SoundMixer;
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
		
		private static var lastMusicVolume:Number ;

		private static var muted:Boolean = false ;
		
		/**2 sound id to swap musics smoothly*/
		private static var currentSoundId:uint,
							otherSoundId:uint;
							
		public static function setUp(myStage:Stage,PlaySounOnBackGroundTo:Boolean):void
		{
			currentSoundId = Contents.id_music ;
			otherSoundId = Contents.id_music2 ;
			
			SoundPlayer.setUp(myStage,!PlaySounOnBackGroundTo,false);
			//SoundPlayer.addSound(Contents.homePage.musicURL,Contents.id_music,true,1);
			changeMainMusic();
			
			if(lastMusicState.data.state == undefined)
			{
				lastMusicState.data.state = true ;
				lastMusicState.flush();
			}
			
			if(lastMusicState.data.state)
			{
				SoundPlayer.play(currentSoundId);
			}
		}
		
		public static function get MusicIsPlaying():Boolean
		{
			//Forgotten ! befor the return solved on 94-06-20
			return !SoundPlayer.getStatuse_pause(currentSoundId) || !SoundPlayer.getStatuse_pause(otherSoundId);
		}
		
		public static function killOtherSounds():void
		{
			var firstSoundPlaying:Boolean = MusicIsPlaying;
			var soundPose:Number = SoundPlayer.getPlayedPrecent(currentSoundId);
			pauseMusic();
			SoundMixer.stopAll();
			SoundPlayer.addSound(lastPlayingMusic,currentSoundId,true,muted?0:lastMusicVolume);
			if(firstSoundPlaying)
			{
				startMusic(soundPose);
			}
		}
		
		public static function startMusic(soundPlayingFrom:Number=NaN):void
		{
			if(isNaN(soundPlayingFrom))
			{
				SoundPlayer.play(currentSoundId);
			}
			else
			{
				SaffronLogger.log("soundPose  : "+soundPlayingFrom);
			}
			SoundPlayer.play(currentSoundId,true,true,soundPlayingFrom);
			lastMusicState.data.state = true ;
			lastMusicState.flush();
			if(muted)SoundPlayer.volumeContril(currentSoundId,0);
		}
		
		public static function pauseMusic():void
		{
			SoundPlayer.pause(currentSoundId);
			lastMusicState.data.state = false ;
			lastMusicState.flush();
		}
		
		public static function muteMusic():void
		{
			muted = true ;
			SoundPlayer.volumeContril(currentSoundId,0);
		}
		
		public static function unMuteMusit():void
		{
			muted = false 
			SoundPlayer.volumeContril(currentSoundId,1);
		}

		public static function changeVolume(volume:Number):void
		{
			SoundPlayer.volumeContril(currentSoundId,muted?0:volume);
		}
		
		/**This will change the current playing music ( not tested yet )*/
		public static function changeMainMusic(musicURL:String='',volume:Number=1):void
		{
			
			//SoundPlayer.pause(currentSoundId);
			var musicWasPlaying:Boolean = MusicIsPlaying ;
			if(lastPlayingMusic==null && musicURL=='')
			{
				musicURL = Contents.homePage.musicURL ;
				volume = Contents.homePage.musicVolume ;
			}
			lastMusicVolume = volume ;
			if(muted==false && (musicURL=='' || lastPlayingMusic == musicURL))
			{
				SaffronLogger.log("Music is duplicated on ContentSoundManager.changeMainMusic : "+musicURL);
				SoundPlayer.volumeContril(currentSoundId,volume);
				SaffronLogger.log("Change volume to : "+volume);
				return ;
			}
			
			SaffronLogger.log("Change the music to : "+musicURL);
			SaffronLogger.log("Change volume to : "+volume);
			SaffronLogger.log("Pause the sound : "+currentSoundId);
			SoundPlayer.pause(currentSoundId);
			SaffronLogger.log("Add the sound : "+otherSoundId);
			SoundPlayer.addSound(musicURL,otherSoundId,true,muted?0:volume);
			if(lastPlayingMusic==null || musicWasPlaying)
			{
				SaffronLogger.log("lastPlayingMusic : "+lastPlayingMusic);
				SaffronLogger.log("musicWasPlaying : "+musicWasPlaying);
				SoundPlayer.play(otherSoundId);

			}
			if(muted)SoundPlayer.volumeContril(currentSoundId,0);
			
			lastPlayingMusic = musicURL ;
			
			otherSoundId = otherSoundId+currentSoundId ;
			currentSoundId = otherSoundId-currentSoundId ;
			otherSoundId = otherSoundId-currentSoundId;
		}
	}
}