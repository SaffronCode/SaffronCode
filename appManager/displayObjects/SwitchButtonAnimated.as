package appManager.displayObjects
//appManager.displayObjects.SwitchButtonAnimated
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	[Event(name="change", type="flash.events.Event")]
	public class SwitchButtonAnimated extends MovieClip
	{
		private var _status:Boolean = false ;

		public function SwitchButtonAnimated(status:Boolean = false)
		{
			_status = status ;
			super();
			stop();
			
			this.buttonMode = true ;
			this.addEventListener(MouseEvent.MOUSE_DOWN,switchMe);
			this.addEventListener(Event.ENTER_FRAME,anim);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}

		private function unLoad(e:Event):void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN,switchMe);
			this.removeEventListener(Event.ENTER_FRAME,anim);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}

		private function switchMe(event:MouseEvent):void
		{
			_status = !_status ;
			this.dispatchEvent(new Event(Event.CHANGE));
			trace(_status);
		}

		public function get status():Boolean
		{
			return _status ;
		}

		public function set status(value:Boolean):void
		{
			if(_status!=value)
			{
				switchMe(null);
			}
		}

		private function anim(event:Event):void
		{
			if(_status)
			{
				this.nextFrame();
			}
			else
			{
				this.prevFrame();
			}
		}
	}
}