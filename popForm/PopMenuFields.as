package popForm
{
	import flash.text.SoftKeyboardType;

	public class PopMenuFields
	{
		public var tagNames:Vector.<String> ;
		
		public var fieldDefaults:Vector.<String> ;
		
		public var keyBoards:Vector.<String> ;
		
		public var isPassWorld:Vector.<Boolean>;
		
		public var editable:Vector.<Boolean>;
		
		public var isArabic:Vector.<Boolean>;
		
		public var numLines:Vector.<uint>;
		/***/
		public function PopMenuFields()
		{
			tagNames = new Vector.<String>();
			fieldDefaults = new Vector.<String>();
			keyBoards = new Vector.<String>();
			isPassWorld = new Vector.<Boolean>();
			editable = new Vector.<Boolean>();
			isArabic = new Vector.<Boolean>();
			numLines = new Vector.<uint>;
		}
		
		/**add new field*/
		public function addField(tagName:String,fieldDefault:String='',keyBoardType:String = SoftKeyboardType.DEFAULT,isPass:Boolean=false,Editable:Boolean = true,isArabic_v:Boolean=true,numLine:uint=1)
		{
			keyBoardType = (keyBoardType==null)?SoftKeyboardType.DEFAULT:keyBoardType;
			
			tagNames.push(tagName);
			fieldDefaults.push(fieldDefault);
			keyBoards.push(keyBoardType);
			isPassWorld.push(isPass);
			editable.push(Editable);
			isArabic.push(isArabic_v);
			numLines.push(numLine);
		}
	}
}