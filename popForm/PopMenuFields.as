package popForm
{
	import flash.text.SoftKeyboardType;

	public class PopMenuFields
	{
		public var tagNames:Vector.<String> ;
		
		public var fieldDefaults:Vector.<String> ;
		public var fieldDefaultDate:Vector.<Date> ;
		public var fieldDefaultBooleans:Vector.<Array> ;
		
		public var keyBoards:Vector.<String> ;
		
		public var isPassWorld:Vector.<Boolean>;
		
		public var editable:Vector.<Boolean>;
		
		public var isArabic:Vector.<Boolean>;
		
		public var booleanValues:Vector.<Boolean>;
		
		public var numLines:Vector.<uint>;
		
		/**1 for arabic, 2 for english*/
		public var languageDirection:Vector.<uint> ;
		
		public var backColor:Vector.<uint> ;
		
		/**This will shows if the pop MenuField is STRING or DATE or TIME from the PoMenuFieldTypes*/
		public var popFieldType:Vector.<uint> ;
		
		public var maxCharacters:Vector.<uint> ;
		/***/
		public function PopMenuFields()
		{
			tagNames = new Vector.<String>();
			fieldDefaults = new Vector.<String>();
			fieldDefaultDate = new Vector.<Date>();
			fieldDefaultBooleans = new Vector.<Array>();
			booleanValues = new Vector.<Boolean>();
			keyBoards = new Vector.<String>();
			isPassWorld = new Vector.<Boolean>();
			editable = new Vector.<Boolean>();
			isArabic = new Vector.<Boolean>();
			numLines = new Vector.<uint>;
			languageDirection = new Vector.<uint>();
			backColor = new Vector.<uint>();
			
			popFieldType = new Vector.<uint>();
			maxCharacters = new Vector.<uint>();
		}
		
		/**add new field<br>
		 * frameForDirection: 1 for rtl and 2 for ltr script<br>
		 * if the field is read only, you can set numLines to 0 and make it change the lines by it's needs*/
		public function addField(tagName:String,fieldDefault:*='',keyBoardType:String = SoftKeyboardType.DEFAULT,isPass:Boolean=false,Editable:Boolean = true,isArabic_v:Boolean=true,numLine:uint=1,frameForDirection:uint=1,fieldColorFrame:uint=1,maxChar:uint=0)
		{
			keyBoardType = (keyBoardType==null)?SoftKeyboardType.DEFAULT:keyBoardType;
			
			tagNames.push(tagName);
			fieldDefaults.push(fieldDefault);
			fieldDefaultDate.push(null);
			fieldDefaultBooleans.push(null);
			booleanValues.push(false);
			keyBoards.push(keyBoardType);
			isPassWorld.push(isPass);
			editable.push(Editable);
			isArabic.push(isArabic_v);
			numLines.push(numLine);
			languageDirection.push(frameForDirection);
			backColor.push(fieldColorFrame);
			
			popFieldType.push(PopMenuFieldTypes.STRING);
			maxCharacters.push(maxChar);
		}
		
		public function addPhoneField(tagName:String,fieldDefault:String='',isArabic_v:Boolean=true,frameForDirection:uint=1,fieldColorFrame:uint=1,isEditable:Boolean=true)
		{
			tagNames.push(tagName);
			fieldDefaults.push(fieldDefault);
			fieldDefaultDate.push(null);
			fieldDefaultBooleans.push(null);
			booleanValues.push(false);
			keyBoards.push(SoftKeyboardType.NUMBER);
			isPassWorld.push(false);
			editable.push(isEditable);
			isArabic.push(isArabic_v);
			numLines.push(1);
			languageDirection.push(frameForDirection);
			backColor.push(fieldColorFrame);
			
			popFieldType.push(PopMenuFieldTypes.PHONE);
			maxCharacters.push(50);
		}
		
		/**add new field<br>
		 * frameForDirection: 1 for rtl and 2 for ltr script*/
		public function addClickField(tagName:String,fieldDefault:String='',/*keyBoardType:String = SoftKeyboardType.DEFAULT*//*,isPass:Boolean=false*//*,Editable:Boolean = true,*/isArabic_v:Boolean=true,numLine:uint=1,frameForDirection:uint=1,fieldColorFrame:uint=1)
		{
			//keyBoardType = (keyBoardType==null)?SoftKeyboardType.DEFAULT:keyBoardType;
			
			tagNames.push(tagName);
			fieldDefaults.push(fieldDefault);
			fieldDefaultDate.push(null);
			fieldDefaultBooleans.push(null);
			booleanValues.push(false);
			keyBoards.push(null);
			isPassWorld.push(false);
			editable.push(true);
			isArabic.push(isArabic_v);
			numLines.push(numLine);
			languageDirection.push(frameForDirection);
			backColor.push(fieldColorFrame);
			
			popFieldType.push(PopMenuFieldTypes.CLICK);
			maxCharacters.push(0);
		}
		
		/**add new field<br>
		 * frameForDirection: 1 for rtl and 2 for ltr script*/
		public function addDateField(tagName:String,fieldDefaultDates:Date=null,Editable:Boolean = true,isArabic_v:Boolean=true,frameForDirection:uint=1,fieldColorFrame:uint=1)
		{
			//keyBoardType = (keyBoardType==null)?SoftKeyboardType.DEFAULT:keyBoardType;
			
			tagNames.push(tagName);
			fieldDefaults.push('');
			fieldDefaultDate.push(fieldDefaultDates);
			fieldDefaultBooleans.push(null);
			booleanValues.push(false);
			keyBoards.push(null);
			isPassWorld.push(false);
			editable.push(Editable);
			isArabic.push(isArabic_v);
			numLines.push(1);
			languageDirection.push(frameForDirection);
			backColor.push(fieldColorFrame);
			
			popFieldType.push(PopMenuFieldTypes.DATE);
			maxCharacters.push(0);
		}
		
		/**add new field<br>
		 * frameForDirection: 1 for rtl and 2 for ltr script*/
		public function addBooleanField(tagName:String,booleanValue:Boolean,frameForDirection:uint=1,fieldColorFrame:uint=1,Arabic:Boolean=true)
		{
			//keyBoardType = (keyBoardType==null)?SoftKeyboardType.DEFAULT:keyBoardType;
			tagNames.push(tagName);
			fieldDefaults.push(null);
			fieldDefaultDate.push(null);
			fieldDefaultBooleans.push(null);
			booleanValues.push(booleanValue);
			keyBoards.push(null);
			isPassWorld.push(false);
			editable.push(true);
			isArabic.push(Arabic);
			numLines.push(1);
			languageDirection.push(frameForDirection);
			backColor.push(fieldColorFrame);
			
			popFieldType.push(PopMenuFieldTypes.BOOLEAN);
			maxCharacters.push(0);
		}
		
		/**add new field<br>
		 * frameForDirection: 1 for rtl and 2 for ltr script*/
		public function addTimeField(tagName:String,fieldDefaultDates:Date=null,Editable:Boolean = true,isArabic_v:Boolean=true,frameForDirection:uint=1,fieldColorFrame:uint=1)
		{
			//keyBoardType = (keyBoardType==null)?SoftKeyboardType.DEFAULT:keyBoardType;
			
			tagNames.push(tagName);
			fieldDefaults.push('');
			fieldDefaultDate.push(fieldDefaultDates);
			fieldDefaultBooleans.push(null);
			booleanValues.push(false);
			keyBoards.push(null);
			isPassWorld.push(false);
			editable.push(Editable);
			isArabic.push(isArabic_v);
			numLines.push(1);
			languageDirection.push(frameForDirection);
			backColor.push(fieldColorFrame);
			
			popFieldType.push(PopMenuFieldTypes.TIME);
			maxCharacters.push(0);
		}
	}
}