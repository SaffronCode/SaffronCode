package combobox.comboboxStatic
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

[Event(name="SELECT", type="combobox.comboboxStatic.ComboBoxStaticEvents")]
[Event(name="OPEN", type="combobox.comboboxStatic.ComboBoxStaticEvents")]
[Event(name="CLOSE", type="combobox.comboboxStatic.ComboBoxStaticEvents")]
	public class ComboBoxStaticManager extends EventDispatcher
	{
		public static var evt:ComboBoxStaticManager
		public static var scrolSplit:String="h"
		private static var _defaultLable:Object = new Object()	
		private static var _comboboxStatus:Object = new Object()	
		public static var dynamicLinkY:Number = 0	
		public function ComboBoxStaticManager()
		{
			super()
		}
		public static function setup():void
		{
			evt = new ComboBoxStaticManager()
		}
		/** DefaultLable_p : for static combobox list inserts fram lable and for dynamic combobox list inserts string title */
		public static function setDefaultItem(ComboBoxId_p:String,DefaultLabe_p:String):void
		{
			_defaultLable[ComboBoxId_p] = DefaultLabe_p
		}
		
		public static function  defalutLable(ComboBoxId_p:String):String
		{
			return _defaultLable[ComboBoxId_p]
		}
		
		internal static function setStatus(ComboBoxId_p:String,Status:Boolean):void
		{
			_comboboxStatus[ComboBoxId_p] = Status
		}
		
		public static function AllComboBoxClosed():Boolean
		{
			var _status:Boolean = true
			for(var objName:String in _comboboxStatus)
			{
				if(_comboboxStatus[objName])
				{
					_status = false
				}
			}
			return _status
		}
		
	}
}