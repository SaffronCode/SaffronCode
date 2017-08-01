package tabMenu
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	[Event(name="SELECT", type="tabMenu.TabMenuEvent")]
	public class TabMenuManager extends EventDispatcher
	{
		public static var event:TabMenuManager
		private static var _currentTabe:Object;
		public function TabMenuManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function setup():void
		{
			event = new TabMenuManager();
			_currentTabe  = new Object();
		}
		public static function setCurrentTabe(GroupName_p:String,TabeName_p:String,status_p:Boolean):void
		{
			if(_currentTabe[GroupName_p]==null)
			{
				_currentTabe[GroupName_p] = new Object();
			}
			_currentTabe[GroupName_p][TabeName_p]= status_p; 
		}
		public static function getCurrentTabe(GroupName_p:String,TabeName_p:String):Boolean
		{
			if(_currentTabe[GroupName_p]!=null && _currentTabe[GroupName_p][TabeName_p]!=null)
			{
				return _currentTabe[GroupName_p][TabeName_p]; 
			}
			return false
		}
		public static function getAtiveGroup(GroupName_p:String):Boolean
		{
			return _currentTabe[GroupName_p] != null;
		}

	}
}