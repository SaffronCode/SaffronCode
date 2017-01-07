package contents.displayElements
	//contents.displayElements.SoundButton
{
	
	import contents.Contents;
	import contents.soundControll.ContentSoundManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	import soundPlayer.SoundPlayer;
	import soundPlayer.SoundPlayerEvent;
	
	public class SoundButton extends MovieClip
	{
		private var sound1Playing:Boolean,
					sound2Playing:Boolean;
		public function SoundButton()
		{
			super();
			this.stop();
			if(!ContentSoundManager.MusicIsPlaying)// SoundPlayer.getStatuse_pause(ContentSoundManager.MusicID) && SoundPlayer.getStatuse_pause(ContentSoundManager.MusicID2)
			{
				this.gotoAndStop(2);
			}
			SoundPlayer.eventsDispatch.addEventListener(SoundPlayerEvent.PAUSED,musicStoped);
			SoundPlayer.eventsDispatch.addEventListener(SoundPlayerEvent.STOPED,musicStoped);
			SoundPlayer.eventsDispatch.addEventListener(SoundPlayerEvent.PLAYED,musicPlayed);
			
			this.addEventListener(MouseEvent.CLICK,switchMusic);
			this.buttonMode = true ;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		protected function unLoad(event:Event):void
		{
			
			SoundPlayer.eventsDispatch.removeEventListener(SoundPlayerEvent.PAUSED,musicStoped);
			SoundPlayer.eventsDispatch.removeEventListener(SoundPlayerEvent.STOPED,musicStoped);
			SoundPlayer.eventsDispatch.removeEventListener(SoundPlayerEvent.PLAYED,musicPlayed);
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
				trace("Music 2 played");
				sound1Playing = true; 
			}
			else if(e.SoundID == ContentSoundManager.MusicID2)
			{
				trace("Music 1 played");
				sound2Playing = true; 
			}
			if(sound2Playing || sound1Playing)
			{
				trace("Sound is playing");
				this.gotoAndStop(1);
			}
		}
		
		private function musicStoped(e:SoundPlayerEvent)
		{
			if(e.SoundID == ContentSoundManager.MusicID)
			{
				trace("Music1 stopped");
				sound1Playing = false; 
			}
			else if(e.SoundID == ContentSoundManager.MusicID2)
			{
				trace("Music 2 stopped");
				sound2Playing = false; 
			}
			if(!sound2Playing && !sound1Playing && !ContentSoundManager.MusicIsPlaying)
			{
				trace("Sound is stopped");
				this.gotoAndStop(2);
			}
		}
	}
}