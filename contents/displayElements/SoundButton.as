package contents.displayElements
{
	
	import contents.Contents;
	import contents.soundControll.ContentSoundManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	import soundPlayer.SoundPlayer;
	import soundPlayer.SoundPlayerEvent;
	
	public class SoundButton extends MovieClip
	{
		
		public function SoundButton()
		{
			super();
			this.stop();
			if(SoundPlayer.getStatuse_pause(Contents.id_soundEffects))
			{
				this.gotoAndStop(2);
			}
			SoundPlayer.eventsDispatch.addEventListener(SoundPlayerEvent.PAUSED,musicStoped);
			SoundPlayer.eventsDispatch.addEventListener(SoundPlayerEvent.STOPED,musicStoped);
			SoundPlayer.eventsDispatch.addEventListener(SoundPlayerEvent.PLAYED,musicPlayed);
			
			this.addEventListener(MouseEvent.CLICK,switchMusic);
			this.buttonMode = true ;
		}
		
		private function switchMusic(e:MouseEvent)
		{
			if( this.currentFrame == 1 )
			{
				ContentSoundManager.pauseMusic() ;
			}
			else
			{
				ContentSoundManager.startMusic() ;
			}
		}
		
		private function musicPlayed(e:SoundPlayerEvent)
		{
			if(e.SoundID == ContentSoundManager.MusicID)
			{				
				this.gotoAndStop(1);
			}
		}
		
		private function musicStoped(e:SoundPlayerEvent)
		{
			if(e.SoundID == ContentSoundManager.MusicID)
			{
				this.gotoAndStop(2);
			}
		}
	}
}