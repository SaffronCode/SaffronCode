package mp3PlayerStatic
{//mp3PlayerStatic.PlayPause
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PlayPause extends MovieClip
	{
		private var _playStatus:Boolean;
		public function PlayPause()
		{
			super();
			_playStatus = MediaPlayerStatic.playStatus	
			this.gotoAndStop(!_playStatus)
			this.alpha = 0.3	
			this.addEventListener(Event.ENTER_FRAME,cheker)	
			this.addEventListener(Event.REMOVED_FROM_STAGE,unload)		
		}
		
		protected function unload(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ENTER_FRAME,cheker)	
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unload)
		}
		
		protected function cheker(event:Event):void
		{
			// TODO Auto-generated method stub
			if(MediaPlayerStatic.isReady)
			{
				_playStatus = MediaPlayerStatic.playStatus
				this.gotoAndStop(!_playStatus)	
				MediaPlayerStatic.evt.addEventListener(MediaPlayerEventStatic.PLAY,playFun)	
				MediaPlayerStatic.evt.addEventListener(MediaPlayerEventStatic.PAUSE,pauseFun)
				this.removeEventListener(Event.ENTER_FRAME,cheker)	
				this.addEventListener(MouseEvent.CLICK,click_fun)
				this.alpha = 1
			}
		}
		
		protected function pauseFun(event:Event):void
		{
			// TODO Auto-generated method stub
			_playStatus = false	
			this.gotoAndStop(!_playStatus)	
		}
		
		protected function playFun(event:Event):void
		{
			// TODO Auto-generated method stub
			_playStatus = true	
			this.gotoAndStop(!_playStatus)	
		}
		
		protected function click_fun(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			_playStatus = !_playStatus
			if(_playStatus)	
			{
				MediaPlayerStatic.evt.dispatchEvent(new MediaPlayerEventStatic(MediaPlayerEventStatic.PLAY))
			}
			else
			{
				MediaPlayerStatic.evt.dispatchEvent(new MediaPlayerEventStatic(MediaPlayerEventStatic.PAUSE))
			}		
		}
	}
}