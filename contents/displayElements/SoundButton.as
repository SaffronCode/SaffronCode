package contents.displayElements
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
		
		public function SoundButton()
		{
			super();
			this.stop();
			if(SoundPlayer.getStatuse_pause(ContentSoundManager.MusicID))
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
			// TODO Auto-generated method stub
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