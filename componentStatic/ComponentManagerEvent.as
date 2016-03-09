package componentStatic
{
	import flash.events.Event;
	
	public class ComponentManagerEvent extends Event
	{
		/**chang fidle value*/
		public static const CHANG:String = "CHANG";
		
		
		public static const UPDATE:String = "UPDATE";
		private var _componentName:String;
		public function get componentName():String
		{
			return _componentName
		}
		
		private var _componentType:String;
		public function get componentType():String
		{
			return _componentType
		}
		public function ComponentManagerEvent(type:String,componentName:String='',componentType:String='', bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);	
			_componentName = componentName
			_componentType = componentType
		}
	}
}