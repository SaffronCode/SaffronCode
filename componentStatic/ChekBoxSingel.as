package componentStatic
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ChekBoxSingel extends ComponentManager
	{
		private var _status:Boolean;
		public function ChekBoxSingel()
		{
			super();
			update()
			ComponentManager.evt.addEventListener(ComponentManagerEvent.UPDATE,getUpdate)
		}
		protected function getUpdate(event:Event):void
		{
			// TODO Auto-generated method stub
			update()
		}
		private function update():void
		{
			_status = false
			if(getObj(this.name)!=null)
			{
				var _str:String = String(getObj(this.name)).toLowerCase()
				if(_str=='true')
				{
					_status = true
				}
			}
			setStatus()
			this.addEventListener(MouseEvent.CLICK,click_fun)
			setObj(this.name,_status)
		}
		protected function click_fun(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			_status = !_status
			setObj(this.name,_status)
			setStatus()	
		}
		private function setStatus():void
		{
			this.gotoAndStop(_status)
		}
	}
}