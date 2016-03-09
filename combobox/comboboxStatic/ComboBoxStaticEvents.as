package combobox.comboboxStatic
{
	import contents.LinkData;
	
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
		
		private var _linkData:LinkData;
		public function get linkData():LinkData
		{
			return _linkData
		}
		public function ComboBoxStaticEvents(type:String,id:String=null,comboBoxId:String=null,linkData:LinkData=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_id = id
			_comboBoxId = comboBoxId
			_linkData = linkData	
		}
	}
}