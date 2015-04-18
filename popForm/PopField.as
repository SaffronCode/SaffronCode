package popForm
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.SoftKeyboardType;
	import flash.text.TextField;
	
	public class PopField extends PopFieldInterface
	{
		private var myTXT:TextField ;
		
		private var tagNameTXT:TextField ;
		
		private var backMC:MovieClip ;
		private var myTitle:String;
		
		
		/**this will returns last inputed text to client*/
		public function get text():String
		{
			return myTXT.text ;
		}
		
		override public function get title():String
		{
			return myTitle;
		}
		
		override public function get data():*
		{
			return title ;
		}
		
		public function changeColor(colorFrame:uint)
		{
			backMC.gotoAndStop(colorFrame);
		}
		
		public function PopField(tagName:String,defaultText:String,KeyBordType:String = SoftKeyboardType.DEFAULT,isPass:Boolean = false,editable:Boolean = true,isAraic:Boolean=true,numLines:uint = 1,color:uint=1,frame:uint=1)
		{
			super();
			
			//New lines to manage language style ( like rtl and ltr )
			this.gotoAndStop(frame);
			
			
			myTitle = tagName ;
			backMC = Obj.get("back_mc",this);
			
			//New Line to manage textfield background color 
			changeColor(color);
			
			tagNameTXT = Obj.get("tag_txt",Obj.get("tag_txt",this));
			tagNameTXT.text = "" ;
			TextPutter.OnButton(tagNameTXT,tagName,true,false,true);
			myTXT = Obj.get('txt_txt',this);
			myTXT.borderColor = 0xD92C5C;
			myTXT.displayAsPassword = isPass ;
			myTXT.mouseEnabled = myTXT.selectable = editable ;
			
			if(numLines>1)
			{
				var Y0:Number = myTXT.height ;
				myTXT.multiline = true ;
				myTXT.wordWrap = true ;
				for(var i = 0 ; i<numLines ; i++)
				{
					myTXT.appendText('a\n') ;
				}
				myTXT.text = myTXT.text.substring(0,myTXT.text.length-1);
				myTXT.height = myTXT.textHeight+10;
				var Y1:Number = myTXT.height ;
				backMC.height += Y1-Y0 ;
				backMC.y+=(Y1-Y0)/2;
				myTXT.text = '' ;
			}
			else
			{
				myTXT.multiline = true ;
				myTXT.wordWrap = true ;
			}
			myTXT.text = (defaultText==null)?'': defaultText ;
			
			//FarsiInputText.steKeyBord(myTXT,false);
			if(editable)
			{
				FarsiInputCorrection.setUp(myTXT,KeyBordType);
			}
			else
			{
				//remove texts back ground
				backMC.visible = false;
				if(isAraic)
				{
					UnicodeStatic.fastUnicodeOnLines(myTXT,defaultText);
				}
				else
				{
					myTXT.text = defaultText ;
				}
			}
		}
		
		/**item is added to stage
		private function imAdded(e:Event)
		{
			FarsiInputCorrection.setUp(myTXT,keyBordType);
		}*/
	}
}