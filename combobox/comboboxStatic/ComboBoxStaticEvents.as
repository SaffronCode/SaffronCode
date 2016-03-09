package combobox.comboboxStatic
{
	import flash.events.Event;
	
	public class ComboBoxStaticEvents extends Event
	{
		/**selcet itme from menu*/
		public static const SELECT:String = "SELECT";
		
		/**open menu event*/
		public static const OPEN:String = "OPEN";
		
		
		/**close menu event*/
		public static const CLOSE:String = "CLOSE";
		
		
		private var _id:String;
		public function get id():String
		{
			return _id
		}
		
		private var _comboBoxId:String;
		public function get comboBoxId():String
		{
			return _comboBoxId
		}
		
		public function ComboBoxStaticEvents(type:String,id:String=null,comboBoxId:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_id = id
			_comboBoxId = comboBoxId
		}
	}
}