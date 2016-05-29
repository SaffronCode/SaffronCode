package tabMenu
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	[Event(name="SELECT", type="tabMenu.TabMenuEvent")]
	public class TabMenuManager extends EventDispatcher
	{
		public static var event:TabMenuManager
		public function TabMenuManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function setup():void
		{
			event = new TabMenuManager()
		}
	}
}