package popForm
{
	import flash.display.DisplayObject;

	public class PopMenuContent
	{
		
		public var mainTXT:String ;
		
		public var buttonList:Array ;
		
		/**NEW !  This is frame number for each button*/
		public var buttonsInterface:Array ;
		
		public var fieldDatas:PopMenuFields ;
		
		public var haveField:Boolean ;
		
		/**generate popMenuContent manager<br>
		 * enter default text of "" space on haveField to show it as field
		 * enter buttons name on buttonArray array in string*/
		
		public var displayObject:DisplayObject ;
		
		public function PopMenuContent(MainText:String = '' ,
									   HaveField:PopMenuFields = null ,
									   buttonsArray:Array = null,
									   innerDisplayObject:DisplayObject = null,
									   buttonFrames_v:Array = null)
		{
			displayObject = innerDisplayObject ;
			
			var i:int ;
			
			if(buttonsArray == null)
			{
				buttonList = new Array() ;
			}
			else
			{
				buttonList = buttonsArray.concat() ;
			}
			
			if(buttonFrames_v == null)
			{
				buttonsInterface = new Array() ;
				for(i = 0 ; i<buttonList.length ; i++)
				{
					buttonsInterface.push(1);
				}
			}
			else
			{
				buttonsInterface = buttonFrames_v.concat() ;
				var lastFrame:uint = buttonsInterface[buttonsInterface.length-1] ;
				for(i = buttonsInterface.length ; i<buttonsArray.length ; i++)
				{
					buttonsInterface.push(lastFrame);
				}
			}
			
			
			if(HaveField==null)
			{
				fieldDatas = null;
				haveField = false;
			}
			else
			{
				fieldDatas = HaveField;
				haveField = true;
			}
			
			mainTXT = MainText ;
		}
	}
}