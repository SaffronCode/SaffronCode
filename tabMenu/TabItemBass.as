package tabMenu
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;


	public class TabItemBass extends MovieClip
	{
		protected var _group:String,
					_bg:MovieClip,
					_name:String,
					_defaultTabe:String,
					_selected:Boolean,
					_activeCurrentTab:Boolean;
					
		private var _timerId:uint;	
		
		
		public function TabItemBass(GroupName_p:String=null,ActiveCurrentTab_p:Boolean=false)
		{
			super();
			_group = GroupName_p;
			_activeCurrentTab = ActiveCurrentTab_p;		
			_name = this.name.split('_')[0];
			try
			{			
				this.gotoAndStop(_name);
				_bg = Obj.get('bg',this);
			}
			catch(e:Error)
			{
				trace('<<<Frame label '+_name+' not found in scene '+_name+'.>>>');
			}
			_defaultTabe = this.name.split('_')[1];	
			TabMenuManager.event.addEventListener(TabMenuEvent.SELECT,onSelected);			
			if(_activeCurrentTab && TabMenuManager.getCurrentTabe(GroupName_p,_name)==true)
			{
				_timerId = setTimeout(sendEventBytimer,5);
			}
			else if( !TabMenuManager.getAtiveGroup(GroupName_p)&& _defaultTabe!=null && _defaultTabe.toLowerCase()=='true')
			{
				_timerId = setTimeout(sendEventBytimer,5);
			}
			this.addEventListener(MouseEvent.CLICK,click_fun);	
		}
		
		private function sendEventBytimer():void
		{
			
			sendEvent();
			clearTimeout(_timerId);
		}
		
		/** defined active tab selected metod or add _true of end name tabe simple 'tabname_true' if add true this tab is default selected tab*/
		public function setup():void
		{
			sendEvent();
		}
		
		protected function onSelected(event:TabMenuEvent):void
		{
			
			if(event.group == _group)
			{
				if(event.name == _name && _bg!=null)
				{
					_selected = true;
				}
				else if(_bg!=null)
				{
					_selected = false;
					if(_activeCurrentTab && TabMenuManager.getAtiveGroup(event.group))
					{
						TabMenuManager.setCurrentTabe(_group,_name,false);
					}
				}
				if(_bg!=null)
				{		
					_bg.gotoAndStop(_selected);
				}
			}
		}
		
		protected function click_fun(event:MouseEvent):void
		{
			
			if(!_selected)
			{			
				sendEvent();
				if(_activeCurrentTab)
				{
					TabMenuManager.setCurrentTabe(_group,_name,true);
				}
			}
		}
		protected function sendEvent():void
		{
			TabMenuManager.event.dispatchEvent(new TabMenuEvent(TabMenuEvent.SELECT,_group,_name));
		}
	}
}