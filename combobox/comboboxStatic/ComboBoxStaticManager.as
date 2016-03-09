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
		public function ComboBoxStaticManager()
		{
			super()
		}
		public static function setup():void
		{
			evt = new ComboBoxStaticManager()
		}
		
	}
}