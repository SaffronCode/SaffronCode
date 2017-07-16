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
		protected var _titleMc:TitleText
		protected var upLoadDate:Date;
		private var _fun:Function;
		private var _data:*;
		private var _timerId:uint;
		private var _title:String;
		public function get data():*
		{
			return _data
		}
		public function ComboBoxSender()
		{
			super();
			_titleMc = Obj.get('title_mc',this)	
			ComponentManager.evt.addEventListener(ComponentManagerEvent.UPDATE,getUpdate)
		}
		
		protected function getUpdate(event:Event):void
		{	
			update()
		}
		public function update():void
		{
			
		}
		protected function load(Fun_p:Function,Title_p:String=null):void
		{
			_fun = Fun_p
			_title = Title_p
			upLoadDate = new Date()
			upLoadDate.date-=7	
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
				var _bottonArray:Array = _data.buttonArray()
				for(var i:int=0;i<_bottonArray.length;i++)
				{
					if(getObj(this.name) == _bottonArray[i].id)
					{
						var _defaultValue:PopButtonData = _bottonArray[i]
					}
				}
				
				if(_defaultValue!=null)
				{
					_titleMc.setUp(_defaultValue.title)
					setObj(this.name,_defaultValue.id)
				}
				else
				{
					setObj(this.name,null)
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
		protected function OpenList(event:MouseEvent=null):void
		{	
			openListPopUp()
		}
		
		public function openListPopUp():void
		{
			trace('_data.title() :',_data.title());
			if(_title!=null)
			{
				Hints.selector(_title,'',_data.buttonArray(),selector,null,1,2,onBackFun)
			}
			else
			{
				Hints.selector(_data.title(),'',_data.buttonArray(),selector,null,1,2,onBackFun)
			}
			
		}
		
		protected function onBackFun():void
		{
			
			
		}
		protected function selector(event:PopMenuEvent):void
		{		
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
			trace('combobox server erroe')	
		}


	}
}