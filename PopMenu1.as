package
{
	import popForm.PopMenu;
	import popForm.PopMenuContent;
	import popForm.PopMenuDispatcher;
	import popForm.PopMenuTypes;
	
	public class PopMenu1 extends PopMenu
	{
		private static var ME1:PopMenu1 ;
		
		public function PopMenu1()
		{
			super();
			ME1 = this;
		}
		
		public static function popUp(title:String='' , type:PopMenuTypes=null , content:PopMenuContent=null,closeOnTime:uint=0,onButtonSelects:Function = null)
		{
			//trace('POP 1 MENU OPENED '+Math.random());
			ME1.popUp2(title, type, content,closeOnTime,onButtonSelects);
		}		
		
		public static function get popDispatcher():PopMenuDispatcher
		{
			return ME1.popDispatcher ;
		}
		public static function close()
		{
			if(ME1)
			{
				ME1.close();
			}
		}
		
		/**this will tell if the popMenuIsOpen*/
		public static function get isOpen():Boolean
		{
			return ME1.show ;
		}
		
		/**Returns the content width*/
		public static function width():Number
		{
			if(ME1)
			{
				return ME1.getContentWidth();
			}
			return 0 ;
		}
		
		/**Returns the content height*/
		public static function height():Number
		{
			if(ME1)
			{
				return ME1.getContentHeight();
			}
			return 0 ;
		}
	}
}