package contents.displayElements
{
	import contents.Contents;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
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
			if(this.currentFrame ==1)
			{
				SoundPlayer.pause(Contents.id_music);
			}
			else
			{
				SoundPlayer.play(Contents.id_music);				
			}
		}
		
		private function musicPlayed(e:SoundPlayerEvent)
		{
			if(e.SoundID == Contents.id_music)
			{				
				this.gotoAndStop(1);
			}
		}
		
		private function musicStoped(e:SoundPlayerEvent)
		{
			if(e.SoundID == Contents.id_music)
			{
				this.gotoAndStop(2);
			}
		}
	}
}