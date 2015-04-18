/**
 * 
				//☻s are removed Ys in current version
 * 
 * 
 */

package popForm
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	[Event(name="buttonSelecte", type="nabat.forms.popForm.PopMenuEvent")]
	public class PopMenuContenDisplay extends MovieClip
	{
		private static var stagePlusHaight:Number = 0;
		
		private var myHieghtPlus:Number = 0 ;
		
		
		private var mainText:TextField;
		
		private var mainTextMinHeight:Number ;
		
		private var buttonList:Vector.<PopButton>;
		
		private var field:Vector.<PopFieldInterface> ;
		
		private var myDisplay:DisplayObject ;
		
		private var maxAreaMC:MovieClip ;

		private var scroll:ScrollMT;
		
		private var thisY:Number ;
		
		public var height0:Number; 
		
		/**Add more Height for scrolling*/
		public function localHeight(H:Number)
		{
			myHieghtPlus = H ;
		}
		
		public function PopMenuContenDisplay()
		{
			super();
			
			thisY = this.y ;
			
			maxAreaMC = Obj.get("maxArea_mc",this) ;
			var areaW:Number = maxAreaMC.width;
			var areaH:Number = maxAreaMC.height ;
			maxAreaMC.scaleX = maxAreaMC.scaleY = 1 ;
			maxAreaMC.removeChildren();
			maxAreaMC.graphics.clear();
			maxAreaMC.graphics.beginFill(0);
			//Why areaH/2 ????
			maxAreaMC.graphics.drawRect(areaW/-2,0/*areaH/-2*/,areaW,areaH);
			maxAreaMC.alpha = 0 ;
			
			field = new Vector.<PopFieldInterface>();
			
			mainText = Obj.get('main_txt',this);
			mainTextMinHeight = mainText.height ;
			
			if(!DevicePrefrence.isTablet)
			{
				var txtFormat:TextFormat = mainText.getTextFormat();
				txtFormat.size = txtFormat.size+10;
				mainText.defaultTextFormat = txtFormat ;
			}
			mainText.text = '' ;
			
			buttonList = new Vector.<PopButton>();
			
			height0 = this.height ;
		}
		
		/**set up the pop menu contents*/
		public function setUp(content:PopMenuContent=null/*,color:ColorTransform*/)
		{
			this.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
			
			while(field.length>0)
			{
				this.removeChild(field[0]);
				field.shift();
			}
			
			if(myDisplay!=null)
			{
				this.removeChild(myDisplay);
				myDisplay = null ;
			}
			
			for(var i = 0 ; i<buttonList.length ;i++)
			{
				this.removeChild(buttonList[i]);
			}
			buttonList = new Vector.<PopButton>();
			
			if(content == null)
			{
				return ;
			}
			
			UnicodeStatic.fastUnicodeOnLines(mainText,content.mainTXT,true);
			if(content.displayObject == null)
			{
				mainText.height = Math.max(mainText.height,mainTextMinHeight);
			}
			var Y:Number ;
			if(content.mainTXT=='')
			{
				//☻
				Y = mainText.y;//+10 ;
			}
			else
			{
				Y = mainText.height+mainText.y;
			}
			
			if(content.displayObject!=null)
			{
				myDisplay = content.displayObject ;
				myDisplay.y = Y ;
				this.addChild(myDisplay);
				Y+=myDisplay.height+10 ;
			}
			
			var deltaYForFiedl:Number = 0 ;
			
			var deltaXForButtons:Number = 10,
				//☻
				deltaYForButtons:Number = 0;//20;
			
			//trace('content.haveField : '+content.haveField);
			
			
			
			if(content.haveField)
			{
				for(i = 0 ; i<content.fieldDatas.fieldDefaults.length ; i++)
				{
					//trace("content.fieldDatas.keyBoards[i] : "+content.fieldDatas.keyBoards[i]);
					if(content.fieldDatas.popFieldType[i] == PopMenuFieldTypes.STRING)
					{
						trace("It is String field");
						var newfield:PopField = new PopField(
							content.fieldDatas.tagNames[i]
							,content.fieldDatas.fieldDefaults[i]
							,content.fieldDatas.keyBoards[i]
							,content.fieldDatas.isPassWorld[i]
							,content.fieldDatas.editable[i]
							,content.fieldDatas.isArabic[i]
							,content.fieldDatas.numLines[i]
							,content.fieldDatas.languageDirection[i]
							,content.fieldDatas.backColor[i]
						);
						this.addChild(newfield);
						newfield.y = Y ;
						Y+=newfield.height+10;
						deltaYForFiedl = 10;//newfield.height*2 ;
						field.push(newfield) ;
					}
					else if(content.fieldDatas.popFieldType[i] == PopMenuFieldTypes.DATE)
					{
						trace("add date input field");
						var newfieldDate:PopFieldDate = new PopFieldDate(
							content.fieldDatas.tagNames[i]
							,content.fieldDatas.fieldDefaultDate[i]
							,content.fieldDatas.isArabic[i]
							,content.fieldDatas.languageDirection[i]
							,content.fieldDatas.backColor[i]
						);
						this.addChild(newfieldDate);
						newfieldDate.y = Y ;
						Y+=newfieldDate.height+10;
						deltaYForFiedl = 10;//newfield.height*2 ;
						field.push(newfieldDate) ;
					}
					else if(content.fieldDatas.popFieldType[i] == PopMenuFieldTypes.TIME)
					{
						trace("add Time input field");
						var newfieldTime:PopFieldTime = new PopFieldTime(
							content.fieldDatas.tagNames[i]
							,content.fieldDatas.fieldDefaultDate[i]
							,content.fieldDatas.isArabic[i]
							,content.fieldDatas.languageDirection[i]
							,content.fieldDatas.backColor[i]
						);
						this.addChild(newfieldTime);
						newfieldTime.y = Y ;
						Y+=newfieldTime.height+10;
						deltaYForFiedl = 10;//newfield.height*2 ;
						field.push(newfieldTime) ;
					}
					else
					{
						throw "This is undefined type of PopMenuField";
					}
				}
				//Y -= newfield.height ;
			}
			else
			{
				//☻
				deltaYForFiedl = 0;//20 ;
			}
			
			var butY:Number = Y+deltaYForFiedl+deltaYForButtons ;
			
			//trace("butY1 : "+butY+' : '+Y+'+'+deltaYForFiedl+'+'+deltaYForButtons);
			
			var but:PopButton;
			
			for(i = 0 ; i<content.buttonList.length ; i++)
			{
				if(content.buttonList[i] == '')
				{
					butY+=20;
					continue ;
				}
				
				//I am passing complete buttonData with current function to let it controll all state for it self
				but = new PopButton(content.buttonList[i]/*,color*/,i,content.buttonsInterface[i],content.buttonList[i]);
				
				Obj.setButton(but,buttonSelected);
				
				buttonList.push(but);
				this.addChild(but);
				but.y = butY+but.height/2 ;
				
				butY += but.height+10 ;
			}
			if(content.buttonList.length!=0)
			{
				//Added to prevet page from stop scroll if there are buttons
				butY+=20;
			}
			/*for(i = 0 ; i<content.bigButtonList.length ; i++)
			{
				if(content.bigButtonList[i] == '')
				{
					butY+=20;
					continue ;
				}
				
				but = new PopButton(content.bigButtonList[i],i,1);
				
				Obj.setButton(but,buttonSelected);
				
				buttonList.push(but);
				this.addChild(but);
				but.y = butY ;
				
				butY += but.height+10 ;
				
			}*/
			
			maxAreaMC.scaleY = 1 ;
			
			var scrollRect:Rectangle = new Rectangle(this.x-maxAreaMC.width/2,thisY,maxAreaMC.width,maxAreaMC.height+stagePlusHaight+myHieghtPlus) ;
			
			//prevent maxAreaMC to rduce height size
			//maxAreaMC.scaleY = 0 ;
			maxAreaMC.height -= 5 ;
			var areaRect:Rectangle = new Rectangle(maxAreaMC.width/-2,0,maxAreaMC.width,butY) ;
			
			//I forgot this line
				this.graphics.clear();
			this.graphics.beginFill(0xff0000,0);
			this.graphics.drawRect(areaRect.width/-2,0,areaRect.width,areaRect.height);
			
			//trace(maxAreaMC.height+' vs '+this.height+' vs '+butY);
			
			scroll = new ScrollMT(this,scrollRect,areaRect);
			//trace("* : this.height:"+this.height+' vs scrollRect.height:'+scrollRect.height);
			if(this.height<=scrollRect.height+10)
			{
				scroll.reset();
				scroll.lock();
			}
		}
		
		public function updateScrollheight()
		{
			trace(maxAreaMC.height+'+'+stagePlusHaight+'+'+myHieghtPlus);
			var scrollRect:Rectangle = new Rectangle(this.x-maxAreaMC.width/2,thisY,maxAreaMC.width,maxAreaMC.height+stagePlusHaight+myHieghtPlus) ;
			var areaRect:Rectangle = new Rectangle(maxAreaMC.width/-2,0,maxAreaMC.width,10) ;
			scroll = new ScrollMT(this,scrollRect,areaRect,true);
			//trace("* : this.height:"+this.height+' vs scrollRect.height:'+scrollRect.height);
			if(this.height<=scrollRect.height+10)
			{
				scroll.reset();
				scroll.lock();
			}
		}
		
		/**one of the buttons are selected*/
		private function buttonSelected(e:MouseEvent)
		{
			var outField:Object = {};
			for(var i = 0 ; i<field.length ; i++)
			{
				//trace("field[i].title : "+field[i].title);
				//trace("field[i].data : "+field[i].data);
				outField[field[i].title] = field[i].data ;
			}
			this.dispatchEvent(new PopMenuEvent(PopMenuEvent.POP_BUTTON_SELECTED,PopButton(e.currentTarget).ID,outField,PopButton(e.currentTarget).title));
		}
		
		public static function addMoreHeight(moreHeight:Number):void
		{
			// TODO Auto Generated method stub
			stagePlusHaight = moreHeight ;
		}
	}
}