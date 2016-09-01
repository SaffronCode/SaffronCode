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
	
	[Event(name="buttonSelecte", type="popForm.PopMenuEvent")]
	[Event(name="FIELD_SELECTED", type="popForm.PopMenuEvent")]
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
		
		private var popFieldType:Class,
					buttonFieldType:Class;
		
		private static var lastScrollY:Number = 0 ;
		
		private var absoluteHeight:Number = NaN ;
		
		/**Add more Height for scrolling*/
		public function localHeight(H:Number)
		{
			myHieghtPlus = H ;
		}
		
		override public function set height(value:Number):void
		{
			absoluteHeight = value ;
		}
		
		/**Returns the content rectangle area*/
		public function getRectArea():Rectangle
		{
			return new Rectangle(maxAreaMC.width/-2,0,maxAreaMC.width,maxAreaMC.height)
		}
		
		override public function get width():Number
		{
			return maxAreaMC.width ;
		}
		
		override public function get height():Number
		{
			return maxAreaMC.height ;
		}
		
		public function PopMenuContenDisplay()
		{
			super();
			
			var samplePopField:PopField = Obj.findThisClass(PopField,this);
			if(samplePopField==null)
			{
				popFieldType = PopField ;
			}
			else
			{
				popFieldType = Obj.getObjectClass(samplePopField);
				Obj.remove(samplePopField);
			}
			var sampleButton:PopButton = Obj.findThisClass(PopButton,this);
			if(sampleButton==null)
			{
				buttonFieldType = PopButton ;
			}
			else
			{
				buttonFieldType =  Obj.getObjectClass(sampleButton);
				trace("buttonFieldType : "+buttonFieldType);
				Obj.remove(sampleButton);
			}
			
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
		
		public function update(content:PopMenuFields):void
		{
			for(var i = 0 ; i<content.fieldDefaults.length ; i++)
			{
				for(var j=0 ; j<field.length ; j++)
				{
					if(field[j].title == content.tagNames[i])
					{
						//Update this field;
						if(field[j] is PopFieldDate)
						{
							trace("Update date");
							field[j].update(content.fieldDefaultDate[i]);
						}
						else
						{
							field[j].update(content.fieldDefaults[i]);
						}
						break;
					}
				}
			}
		}
		
		/**set up the pop menu contents*/
		public function setUp(content:PopMenuContent=null/*,color:ColorTransform*//*,resetScroll:Boolean=true*/)
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
				if(buttonList[i] is DisplayObject)
				{
					this.removeChild(buttonList[i]);
				}
			}
			buttonList = new Vector.<PopButton>();
			
			if(content == null)
			{
				return ;
			}
			if(!content.justify)
			{
				UnicodeStatic.fastUnicodeOnLines(mainText,content.mainTXT,true);
			}
			else
			{
				UnicodeStatic.htmlText(mainText,content.mainTXT,false,true,true);
			}
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
				myDisplay.x = 0 ;
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
					switch(content.fieldDatas.popFieldType[i])
					{
						case(PopMenuFieldTypes.CLICK):
						case(PopMenuFieldTypes.RadioButton):
						case(PopMenuFieldTypes.PHONE):
						case(PopMenuFieldTypes.STRING):
						{
							//trace("It is String field");
							var newfield:PopField = new popFieldType();
							newfield.setUp(
								content.fieldDatas.tagNames[i]
								,content.fieldDatas.fieldDefaults[i]
								,content.fieldDatas.keyBoards[i]
								,content.fieldDatas.isPassWorld[i]
								,content.fieldDatas.editable[i]
								,content.fieldDatas.isArabic[i]
								,content.fieldDatas.numLines[i]
								,content.fieldDatas.backColor[i]
								,content.fieldDatas.languageDirection[i]
								,content.fieldDatas.maxCharacters[i]
								,content.fieldDatas.fieldDefaultBooleans[i]
								);
							this.addChild(newfield);
							newfield.y = Y ;
							Y+=newfield.height+10;
							deltaYForFiedl = 10;//newfield.height*2 ;
							field.push(newfield) ;
							
							switch(content.fieldDatas.popFieldType[i])
							{
								case(PopMenuFieldTypes.CLICK):
								{
									newfield.mouseChildren = false ;
									newfield.mouseEnabled = true ;
									newfield.buttonMode = true ;
									newfield.addEventListener(MouseEvent.CLICK,clicableFieldSelects);
									break;
								}
								case(PopMenuFieldTypes.RadioButton):
								{
									newfield.mouseChildren = false ;
									newfield.mouseEnabled = true ;
									newfield.buttonMode = true ;
									newfield.addEventListener(MouseEvent.CLICK,newfield.switchRadioButton);
									break;
								}
								case(PopMenuFieldTypes.PHONE):
								{
									newfield.phoneControl = true ;
									break
								}
							}
							
							break;
						}
						case(PopMenuFieldTypes.DATE):
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
							
							break;
						}
						case(PopMenuFieldTypes.TIME):
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
							break;
						}
						default:
						{
							throw "This is undefined type of PopMenuField";
						}
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
			
			var lastInLineButton:int = -1 ;
			var lastButFrame:uint = 0 ;
			
			for(i = 0 ; i<content.buttonList.length ; i++)
			{
				if(content.buttonList[i] == '')
				{
					butY+=20;
					buttonList.push(null);
					continue ;
				}
				
				var butData:PopButtonData ;
				
				if(content.buttonList[i] is PopButtonData)
				{
					butData = content.buttonList[i] as PopButtonData;
					if(butData.buttonFrame==0)
					{
						buttonList.push(null);
						continue;
					}
				}
				
				//I am passing complete buttonData with current function to let it controll all state for it self
				but = new buttonFieldType();
				but.y = butY+but.height/2 ;
				this.addChild(but);
				but.setUp(content.buttonList[i],i,content.buttonsInterface[i],content.buttonList[i],(butData!=null)?butData.buttonImage:null);
				
				Obj.setButton(but,buttonSelected);
				
				buttonList.push(but);
				
				but.y = butY+but.height/2 ;
				
				butY += but.height+10 ;
				//trace("lastButFrame == but.currentFrame : "+lastButFrame+" vs "+but.currentFrame);
				if(butData!=null && butData.singleLine)
				{
					if(lastInLineButton == -1)
					{
						//Why??
						//Because this is the first inline button
						//trace("Pop Button began : "+i);
						lastInLineButton = i ;
					}
					else if(lastButFrame == but.currentFrame || butData.ignoreButtonFrameOnLining)
					{
						var butW:Number = but.width ;
						var menuW:Number = maxAreaMC.width ;
						var lineY:Number = buttonList[lastInLineButton].y ;
						/**This value is allways more than 0*/
						var inLineButtons:uint = i-lastInLineButton+1 ;
						var X0:Number = (menuW-butW)/-2;
						var deltaX:Number = (menuW-butW)/(inLineButtons-1) ;
						//trace("butW = "+butW+' inLineButtons = '+inLineButtons+' menuW = '+menuW+' >>> '+lastInLineButton);
						if(butW*inLineButtons<menuW)
						{
							//trace("lastInLineButton : "+lastInLineButton+' buttonList.length : '+buttonList.length);
							for(var k = lastInLineButton ; k<buttonList.length ; k++)
							{
								//trace("Manage button "+k);
								buttonList[k].y = lineY ;
								buttonList[k].x = X0 + (k-lastInLineButton)*deltaX ;
							}
							//trace("This button has problem : "+JSON.stringify(butData));
							butY = lineY+but.height/2+10 ;
						}
						else
						{
							//trace("Time to go to next line for : "+i);
							lastInLineButton = i ;
						}
					}
					else
					{
						//trace("The butoon frame is different");
						lastInLineButton = i ;
					}
					//trace("lastInLineButton : "+lastInLineButton);
				}
				else
				{
					//Cansel inline buttons
					//trace("Cansel the inline buttons");
					lastInLineButton = -1 ;
				}
				
				lastButFrame = but.currentFrame ;
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
			
			var scrollHeight:Number = absoluteHeight ;
			
			if(isNaN(scrollHeight))
			{
				scrollHeight = maxAreaMC.height+stagePlusHaight+myHieghtPlus ;
			}
			
			var scrollRect:Rectangle = new Rectangle(this.x-maxAreaMC.width/2,thisY,maxAreaMC.width,scrollHeight) ;
			
			//prevent maxAreaMC to rduce height size
			//maxAreaMC.scaleY = 0 ;
			maxAreaMC.height -= 5 ;
			var areaRect:Rectangle ;
			
			if(butY<=scrollRect.height+10)
			{
				areaRect = new Rectangle(maxAreaMC.width/-2,0,maxAreaMC.width,butY);
			}
			else
			{
				trace("The menu had a scroller, so you are free to add extra area for scrolling.");
				areaRect = new Rectangle(maxAreaMC.width/-2,0,maxAreaMC.width,butY+scrollRect.height/2);
			}
			
			//I forgot this line
				this.graphics.clear();
			this.graphics.beginFill(0xff0000,0);
			this.graphics.drawRect(areaRect.width/-2,0,areaRect.width,areaRect.height);
			
			//trace(maxAreaMC.height+' vs '+this.height+' vs '+butY);
			lastScrollY = 0 ;
			if(!content.resetScroll && scroll!=null)
			{
				lastScrollY = this.y ;
			}
			scroll = new ScrollMT(this,scrollRect,areaRect,false,false,content.resetScroll);
			if(!content.resetScroll)
			{
				scroll.setPose(NaN,lastScrollY);
				scroll.stopFloat();
			}
			//trace("* : this.height:"+this.height+' vs scrollRect.height:'+scrollRect.height);
			if(this.height<=scrollRect.height+10)
			{
				scroll.reset();
				scroll.lock();
			}
		}
		
		
		private function clicableFieldSelects(e:MouseEvent)
		{
			//trace("Dispatch selected field");
			var targ:PopField = e.currentTarget as PopField ;
			targ.title;
			targ.data ;
			
			var fieldData:Object = {} ;
			fieldData[targ.title] = targ.data ;
			
			this.dispatchEvent(new PopMenuEvent(PopMenuEvent.FIELD_SELECTED,targ.title,fieldData,targ.title,true));
		}
		
		public function updateScrollheight()
		{
			trace("myHieghtPlus : "+maxAreaMC.height+'+'+stagePlusHaight+'+'+myHieghtPlus);
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
		
		/**This will returns all PopFieldInterfaces*/
		public function getFields():Vector.<PopFieldInterface>
		{
			return field.concat();
		}
		
		/**Returns field values*/
		public function getFieldValue(fieldTitle:String):*
		{
			for(var i = 0 ; i<field.length ; i++)
			{
				if(field[i].title == fieldTitle)
				{
					return field[i].data ;
				}
			}
			return null ;
		}
		
		public static function addMoreHeight(moreHeight:Number):void
		{
			// TODO Auto Generated method stub
			stagePlusHaight = moreHeight ;
		}
	}
}