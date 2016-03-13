package componentStatic
{//componentStatic.ComboBoxSender
	import appManager.displayContentElemets.TitleText;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import popForm.Hints;
	import popForm.PopButtonData;
	import popForm.PopMenuEvent;
	
	
	public class ComboBoxSender extends ComponentManager
	{
		private var _titleMc:TitleText
		protected var upLoadDate:Date;
		private var _fun:Function;
		private var _data:*;
		private var _timerId:uint;
		public function ComboBoxSender()
		{
			super();
			ComponentManager.evt.addEventListener(ComponentManagerEvent.UPDATE,getUpdate)
		}
		
		protected function getUpdate(event:Event):void
		{
			// TODO Auto-generated method stub
			update()
		}
		public function update():void
		{
			
		}
		protected function load(Fun_p:Function):void
		{
			_fun = Fun_p
			
			upLoadDate = new Date()
			upLoadDate.date-=7	
			_titleMc = Obj.get('title_mc',this)	
			if(_titleMc!=null)
			{
				_titleMc.text = ''	
			}
			_data = _fun()
		}
		protected function Server_Result(event:Event=null):void
		{
			
			if(_data!=null)
			{	
				for(var i:int=0;i<_data.buttonArray().length;i++)
				{
					if(getObj(this.name) == _data.buttonArray()[i].id)
					{
						var _defaultValue:PopButtonData = _data.buttonArray()[i]
					}
				}
				
				if(_defaultValue!=null)
				{
					_titleMc.setUp(_defaultValue.title)
					setObj(this.name,_defaultValue.id)
				}
				this.addEventListener(MouseEvent.CLICK,OpenList)
				clearTimeout(_timerId)	
			}
			else
			{
				_timerId = setTimeout(Server_Result,100)
			}
			
		}
		
		protected function Connectoin_Error(event:Event):void
		{
			if(_data!=null)
			{
				_data.reLoad()
			}
		}
		private function OpenList(event:MouseEvent):void
		{
			// TODO Auto Generated method stub
			Hints.selector(_data.title(),'',_data.buttonArray(),selector)	
		}
		protected function selector(event:PopMenuEvent):void
		{
			// TODO Auto Generated method stub
			_titleMc.setUp(event.buttonTitle)
			setObj(this.name,event.buttonID)
			selected()
		}
		protected function selected():void
		{
			trace('select item')
		}
		protected function Server_Error(event:Event):void
		{
			// TODO Auto-generated method stub
			trace('combobox server erroe')
			
		}


	}
}