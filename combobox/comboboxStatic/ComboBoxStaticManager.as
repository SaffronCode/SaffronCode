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
		private static var defaultLable:Object = new Object()	
		public function ComboBoxStaticManager()
		{
			super()
		}
		public static function setup():void
		{
			evt = new ComboBoxStaticManager()
		}
		public static function setDefaultItem(ComboBoxId_p:String,DefaultLabe_p:String):void
		{
			defaultLable[ComboBoxId_p] = DefaultLabe_p
		}
		
		public static function  defalutLable(ComboBoxId_p:String):String
		{
			return defaultLable[ComboBoxId_p]
		}
		
	}
}