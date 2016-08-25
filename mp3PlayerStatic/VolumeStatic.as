package mp3PlayerStatic
{//mp3PlayerStatic.VolumeStatic
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import volume.Volume;
	
	public class VolumeStatic extends MovieClip
	{
		private var volumeMc:Volume;
		public function VolumeStatic()
		{
			super();
			volumeMc = Obj.findThisClass(Volume,this)
			this.addEventListener(Event.ENTER_FRAME,cheker)	
			this.addEventListener(Event.REMOVED_FROM_STAGE,unload)	
			setVolume(MediaPlayerStatic.volume)	
		}
		
		protected function unload(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ENTER_FRAME,cheker)
			if(MediaPlayerStatic.evt!=null)
			{
				MediaPlayerStatic.evt.removeEventListener(MediaPlayerEventStatic.VOLUME,getVolume)	
			}
		}
		
		protected function getVolume(event:MediaPlayerEventStatic):void
		{
			// TODO Auto-generated method stub
			setVolume(event.volumeNumber)
		}
		private function setVolume(Volume_p:Number):void
		{
			if(volumeMc!=null)
			{
				volumeMc.setup(Volume_p*100,0,100,onMousUP,onMouseDOWN)
			}
		}
		
		protected function cheker(event:Event):void
		{
			// TODO Auto-generated method stub
			if(MediaPlayerStatic.isReady)
			{
				this.removeEventListener(Event.ENTER_FRAME,cheker)
				setVolume(MediaPlayerStatic.volume)	
				MediaPlayerStatic.evt.addEventListener(MediaPlayerEventStatic.VOLUME,getVolume)	
			}
		}
		
		private function onMouseDOWN():void
		{
			// TODO Auto Generated method stub
			trace('mouse down :',volumeMc.value/100)
		}
		
		private function onMousUP():void
		{
			// TODO Auto Generated method stub
			trace('mouse up :',volumeMc.value/100)
			MediaPlayerStatic.evt.dispatchEvent(new MediaPlayerEventStatic(MediaPlayerEventStatic.VOLUME,volumeMc.value/100))
			
		}
		
	}
}