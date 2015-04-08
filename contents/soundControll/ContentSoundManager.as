package contents.soundControll
{
	import contents.Contents;
	
	import flash.display.Stage;
	import flash.net.SharedObject;
	
	import soundPlayer.SoundPlayer;

	public class ContentSoundManager
	{
		public static const MusicID:uint = 1001,
							EffectsID:uint = 1002,
							NarationID:uint = 1003;
		
		private static var lastMusicState:SharedObject = SharedObject.getLocal('lastMusicState','/');
							
		public static function setUp(myStage:Stage)
		{
			SoundPlayer.setUp(myStage,true,false);
			SoundPlayer.addSound(Contents.homePage.musicURL,Contents.id_music,true,1);
			
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
	}
}