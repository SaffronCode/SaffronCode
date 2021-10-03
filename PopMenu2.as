package
{
	import popForm.PopMenu;
	import popForm.PopMenuContent;
	import popForm.PopMenuDispatcher;
	import popForm.PopMenuTypes;
	
	public class PopMenu2 extends PopMenu
	{
		private static var ME2:PopMenu2 ;
		
		public function PopMenu2()
		{
			super();
			ME2 = this;
		}
		
		public static function popUp(title:String='' , type:PopMenuTypes=null , content:PopMenuContent=null,closeOnTime:uint=0,onButtonSelects:Function = null):void
		{
			//SaffronLogger.log('POP 2 MENU OPENED '+Math.random());
			ME2.popUp2(title, type, content,closeOnTime,onButtonSelects);
		}		
		
		public static function get popDispatcher():PopMenuDispatcher
		{
			return ME2.popDispatcher ;
		}
		public static function close():void
		{
			if(ME2)
				ME2.close();
		}
		
		/**this will tell if the popMenuIsOpen*/
		public static function get isOpen():Boolean
		{
			return ME2.show ;
		}
		
	}
}