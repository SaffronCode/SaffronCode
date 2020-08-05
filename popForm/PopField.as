package popForm
{
	import com.mteamapp.StringFunctions;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.TextField;
	
	import appManager.displayContentElemets.TextParag;
	import flash.utils.setTimeout;
	import contents.alert.Alert;
	import animation.Anim_Frame_Controller;
	
	/**Text field is changed*/
	[Event(name="change", type="flash.events.Event")]
	/**Text field is changing*/
	[Event(name="render", type="flash.events.Event")]
	public class PopField extends PopFieldInterface
	{
		private var myTXT:TextField ;

		//private var _letSelectByCLick:Boolean = false ;
		
		private var tagNameTXT:TextField,
					tagFrameControl:Anim_Frame_Controller,
					tagContainer:MovieClip ;
		
		/**This will make this popField run as switcher*/
		private var activeRadioMode:Boolean ;
		
		private var backMC:MovieClip ;
		private var submitMC:MovieClip ;
		private var myTitle:String;
		
		/**If this was true, data function will controll the phone correction befor returning the value*/
		public var phoneControl:Boolean = false ;
		
		private var radioButtonArray:Array ;
		
		private var nativeKeyBoard:FarsiInputCorrection ;
		private var isEditable:Boolean;
		private var IsArabic:Object;
		private var lastTXT:String;

		private var parag:TextParag;
		private var fieldNumLines:uint;
		
		/**You can set the min value to prevent field numbers get below this number*/
		public var min:Number = NaN ;
		
		/**The button that makes password visible to all*/
		private var showPassMC:MovieClip ;
		
		private var increaseMC:MovieClip,
					decreaseMC:MovieClip

					private var textContainerMC:MovieClip;
					
		private var clearMC:MovieClip ;
		private var _multiLineTag:Boolean=false;
		
		public static var borderColor:uint = 0xD92C5C;

		private var onSubmited:Function ;
		
		
		public function get textField():TextField
		{
			return myTXT ;
		}
		
		
		/**this will returns last inputed text to client*/
		public function get text():String
		{
			if(isEditable)
			{
				return myTXT.text ;
			}
			else
			{
				return lastTXT ; 
			}
		}
		
		public function set textWithoutChangeEvent(value:String):void
		{
			this.addEventListener(Event.CHANGE,eventStopper,false,1000);
			text = value ;
			this.removeEventListener(Event.CHANGE,eventStopper);
		}
		
		private function eventStopper(e:Event):void
		{
			e.stopImmediatePropagation();
		}
		
		public function set text(value:String):void
		{
			if(value==null)
			{
				value = '' ;
			}
			
			lastTXT = value ;
			
			if(isEditable)
			{
				myTXT.text = lastTXT ;
				myTXT.dispatchEvent(new Event(Event.CHANGE));
			}
			else
			{
				if(fieldNumLines==1)
				{
					TextPutter.OnButton(myTXT,lastTXT,IsArabic,true,false,true);
				}
				else
				{
					parag.setUp(lastTXT,IsArabic,true);
				}
				/*if(IsArabic)
				{
					UnicodeStatic.fastUnicodeOnLines(myTXT,lastTXT);
				}
				else
				{
					myTXT.text = lastTXT ;
				}*/
			}
			
		}
		override public function get title():String
		{
			return myTitle;
		}
		
		override public function update(data:*):void
		{
			if(data!=null)
			{
				myTXT.text = data as String ;
				myTXT.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		override public function get data():*
		{
			text = myTXT.text;
			if(phoneControl)
			{
				var cash:String = PhoneNumberEditor.clearPhoneNumber(text);
				if(cash == 'false')
				{
					SaffronLogger.log("This phone number is incorrect");
					return text ;
				}
				else
				{
					return cash ;
				}
			}
			return text ;
		}
		
		public function changeColor(colorFrame:uint):void
		{
			backMC.gotoAndStop(colorFrame);
		}
		
		public function PopField()
		{
			super();
			stop();
		}
		
		/**Changing the form color without making effect on other values*/
		public function colorChange(colorFrame:uint):void
		{
			changeColor(colorFrame);
		}
		public function set tagText(value:String):void
		{
			if(value==null)
			{
				value = '' ;
			}

			if(_multiLineTag){
				TextPutter.onTextArea(tagNameTXT,value,StringFunctions.isPersian(value),true,true,0,false,false,-1,false,0,false);
			}
			else
			{
				TextPutter.OnButton(tagNameTXT,value,StringFunctions.isPersian(value),false,true);
			}

		}

		public function onEnterPressed(func:Function):void
		{
			onSubmited = func ;
			if(nativeKeyBoard!=null)
			{
				nativeKeyBoard.onEnterPressed(func);
			}
		}
		
		public function setUp(tagName:String,defaultText:String,KeyBordType:String = SoftKeyboardType.DEFAULT,isPass:Boolean = false,editable:Boolean = true,isAraic:Boolean=true,numLines:uint = 1,color:uint=1,frame:uint=1,maxChar:uint=0,otherOptions:Array=null,deleteDefautlText:Boolean=false,activateRadioSwitcher:Boolean=false,returnKey:String=ReturnKeyLabel.DEFAULT,onTypedFunction:Function=null,justShowNativeText:Boolean=false,multiLineTag:Boolean=false,justify:Boolean=true,selectAllCharchter:Boolean=false):PopField
		{
			
			var Y0:Number ;
			var Y1:Number ;

			onSubmited = onTypedFunction ;
			
			if(defaultText!=null)
				lastTXT = defaultText ;
			
			radioButtonArray = otherOptions ;
			
			isEditable = editable ;
			IsArabic = isAraic ;
			
			if(editable && numLines==0)
			{
				SaffronLogger.log("You cant have dynamic field size on editable texts");
				numLines = 1 ;
			}
			fieldNumLines = numLines ;
			
			activeRadioMode = activateRadioSwitcher ;
			
			//New lines to manage language style ( like rtl and ltr )
			this.gotoAndStop(frame);
			
			
			myTitle = tagName ;
			backMC = Obj.getAllChilds("back_mc",this,true)[0];
			if(backMC==null)
			{
				backMC = new MovieClip();
			}
			submitMC = Obj.get("submit_mc",this);

			
			//New Line to manage textfield background color 
			changeColor(color);
			
			tagContainer = Obj.getAllChilds("tag_txt",this,true)[0];
			if(tagContainer)
			{
				tagNameTXT = Obj.getAllChilds("tag_txt",tagContainer,true)[0];
				tagNameTXT.text = "" ;
			}
			
			showPassMC = Obj.get("show_pass_mc",this);
			if(showPassMC)
			{
				showPassMC.buttonMode = true ;
				showPassMC.addEventListener(MouseEvent.MOUSE_DOWN,showPassNow);
				showPassMC.visible = isPass ;
			}
			
			increaseMC = Obj.getAllChilds("increase_mc",this,true)[0];
			decreaseMC = Obj.getAllChilds("decrease_mc",this,true)[0];
			if(increaseMC)
			{
				increaseMC.addEventListener(MouseEvent.CLICK,increaseValue);
			}
			if(decreaseMC)
			{
				decreaseMC.addEventListener(MouseEvent.CLICK,decreaseValue);
			}
			clearMC = Obj.get("clear_mc",this);
			if(clearMC)
			{
				clearMC.buttonMode = true ;
				clearMC.addEventListener(MouseEvent.CLICK,clearText);
				clearMC.visible = false ;
			}
			_multiLineTag = multiLineTag;
			if(tagNameTXT!=null)
			{
				if(multiLineTag){
					TextPutter.onTextArea(tagNameTXT,tagName,StringFunctions.isPersian(tagName),true,true,0,false,false,-1,false,0,false);
				}
				else
				{
					TextPutter.OnButton(tagNameTXT,tagName,StringFunctions.isPersian(tagName),false,true);
				}
			}
			myTXT = Obj.getAllChilds('txt_txt',this,false)[0];
			myTXT.addEventListener(Event.CLOSE, dispatchChangeForMeToo);
			myTXT.addEventListener(Event.CHANGE, dispatchRenderEventForMe);
			
			myTXT.maxChars = maxChar ;
			myTXT.borderColor = borderColor;
			myTXT.displayAsPassword = isPass ;
			myTXT.mouseEnabled = myTXT.selectable = editable ;

			if(submitMC!=null)
			{
				submitMC.buttonMode = true ;
				submitMC.addEventListener(MouseEvent.CLICK,activateSubmitIfSomethingEntered);
			}
			
			if(tagContainer!=null && tagContainer.totalFrames>1 && tagFrameControl==null)
			{
				tagFrameControl = new Anim_Frame_Controller(tagContainer,defaultText==''?0:uint.MAX_VALUE,false);
				Obj.addEventListener(myTXT,FarsiInputCorrectionEvent.TEXT_FIELD_SELECTED,checkTagAnimation);
				Obj.addEventListener(myTXT,FarsiInputCorrectionEvent.TEXT_FIELD_CLOSED,checkTagAnimation);
				Obj.addEventListener(myTXT,Event.CHANGE,checkTagAnimation);
				function checkTagAnimation(e:Event):void
				{
					if(e.type!=FarsiInputCorrectionEvent.TEXT_FIELD_SELECTED && myTXT.text=='')
						tagFrameControl.gotoFrame(0);
					else
						tagFrameControl.gotoFrame(uint.MAX_VALUE);
				}
			}


			if(numLines>1)
			{
				Y0 = myTXT.height;
				myTXT.multiline = true ;
				myTXT.wordWrap = true ;
				for(var i = 0 ; i<numLines-1 ; i++)
				{
					myTXT.appendText('a\n') ;
				}
				myTXT.text = myTXT.text.substring(0,myTXT.text.length-1);
				myTXT.height = myTXT.textHeight+10;
				Y1 = myTXT.height;
				backMC.height += Y1-Y0 ;
				backMC.y+=(Y1-Y0)/2;
				myTXT.text = '' ;
			}
			else
			{
				//Why do i need multiline textfield if I desided to use single line text??
				myTXT.multiline = false ;
				myTXT.wordWrap = false ;
			}
			lastTXT = (lastTXT==null)?'': lastTXT ;
			myTXT.text = lastTXT;
			
			
			//FarsiInputText.steKeyBord(myTXT,false);
			if(editable)
			{
				nativeKeyBoard = FarsiInputCorrection.setUp(myTXT,KeyBordType,true,true,deleteDefautlText,justShowNativeText && !activeRadioMode,true,true,returnKey,onTypedFunction,null,selectAllCharchter);
				this.addEventListener(MouseEvent.CLICK,editThisText);
			}
			else
			{
				//remove texts back ground
				
				if(numLines==0)
				{
					myTXT.multiline = true ;
					myTXT.wordWrap = true ;
				}
				backMC.visible = false ;
				
				if(textContainerMC==null)
				{
					textContainerMC = new MovieClip();
					myTXT.parent.addChild(textContainerMC);
					textContainerMC.addChild(myTXT);
					textContainerMC.x = myTXT.x;
					textContainerMC.y = myTXT.y;
					myTXT.x = myTXT.y = 0 ;
				}
				
				if(isAraic)
				{
					if(numLines==1)
					{
						myTXT.multiline = false ;
						myTXT.wordWrap = false ;
						TextPutter.OnButton(myTXT,lastTXT,true,true,false,true);
					}
					else
					{
						myTXT.height = myTXT.height*Math.max(1,numLines);
						parag = new TextParag(0,myTXT);
						parag.x = textContainerMC.x ;
						parag.y = textContainerMC.y ;
						this.addChild(parag);
						parag.setUp(lastTXT,true,justify,false,false,false,false);
						//TextPutter.onStaticArea(myTXT,defaultText,true,true,false);
					}
				}
				else
				{
					if(numLines==1)
					{
						TextPutter.OnButton(myTXT,lastTXT,false,true,false,true);
					}
					else
					{
						myTXT.text = lastTXT ;
					}
				}
				
				if(numLines==0)
				{
					Y0 = myTXT.height;
					myTXT.height = myTXT.textHeight+10;
					Y1 = myTXT.height ;
					backMC.height += Y1-Y0 ;
					backMC.y+=(Y1-Y0)/2;
				}
			}
			
			if(activateRadioSwitcher)
			{
				this.mouseChildren = false ;
				this.mouseEnabled = true ;
				this.buttonMode = true ;
				this.addEventListener(MouseEvent.CLICK,switchRadioButton);
				this.removeEventListener(MouseEvent.CLICK,editThisText);
			}

			return this ;
		}

		private function activateSubmitIfSomethingEntered(e:MouseEvent):void
		{
			if(myTXT.text!='')
			{
				e.stopImmediatePropagation();
				if(onSubmited!=null)
				{
					onSubmited();
				}
			}
		}
		
		/**Return true if the field is in password mode*/
		public function isPassword():Boolean
		{
			if(myTXT!=null)
				return myTXT.displayAsPassword ;
			return false ;
		}
		
		public function set backgroundVisible(value:Boolean):void
		{
			backMC.visible = value ;
		}
		
		protected function clearText(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			SaffronLogger.log("Clear****************");
			myTXT.text = '';
			myTXT.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function dispatchRenderEventForMe(e:Event):void 
		{
			if(clearMC)
				clearMC.visible = myTXT.text.length>0 ; 
			this.dispatchEvent(new Event(Event.RENDER));
		}
		
		protected function increaseValue(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			var num:Number = Number(myTXT.text) ;
			if(!isNaN(num))
			{
				num++;
				myTXT.text = num.toString();
				myTXT.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		protected function decreaseValue(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			var num:Number = Number(myTXT.text) ;
			if(!isNaN(num) && num>min)
			{
				num--;
				myTXT.text = num.toString();
				myTXT.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		override public function get height():Number
		{
			var tagHeight:Number = super.height;
			if(tagNameTXT!=null)
			{
				tagHeight = Math.max(tagHeight,tagNameTXT.height+tagNameTXT.y);
			}
			if(myTXT==null)
			{
				return tagHeight ;
			}
			return Math.max(myTXT.y+myTXT.height,backMC.y+backMC.height,tagHeight);
		}
		
		protected function showPassNow(event:MouseEvent):void
		{
			nativeKeyBoard.showPass();
			stage.addEventListener(MouseEvent.MOUSE_UP,hidePass);
		}
		
		protected function hidePass(event:MouseEvent):void
		{
			nativeKeyBoard.hidePass();
			stage.removeEventListener(MouseEvent.MOUSE_UP,hidePass);
		}
		
		/**Set field editable or not*/
		override public function set enabled(value:Boolean):void
		{
			this.mouseChildren = value ;
			super.enabled = value ;
		}
		
		override public function get enabled():Boolean
		{
			return this.mouseChildren ;
		}

		

		
		
		/**Start editing me*/
		protected function editThisText(event:MouseEvent):void
		{
			if(!super.enabled)
				return;
			if(!myTXT.hitTestPoint(stage.mouseX,stage.mouseY) && (showPassMC==null || !showPassMC.hitTestPoint(stage.mouseX,stage.mouseY)))
			{
				activateKeyBoard();
			}
		}
		
		/**My input text is updated, so dispatch change event on my object*/
		protected function dispatchChangeForMeToo(event:Event):void
		{
			if(!isNaN(min) && !isNaN(Number(myTXT.text)))
			{
				myTXT.text = Math.max(min,Number(myTXT.text)).toString();
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**Open the device key board*/
		public function activateKeyBoard():void
		{
			if(!super.enabled)
				return;
				
			if(nativeKeyBoard && myTXT.mouseEnabled && !activeRadioMode)
			{
				nativeKeyBoard.focuseOnStageText();
			}
		}
		
		/**Returns true if radio butto changed*/
		public function switchRadioButton(e=null):Boolean
		{
			if(!super.enabled)
			{
				return false;
			}
			if(radioButtonArray == null || radioButtonArray.length ==0)
			{
				SaffronLogger.log("No radio button values receved");
				return false ;
			}
			else
			{
				var I:int = radioButtonArray.indexOf(myTXT.text);
				//SaffronLogger.log("radioButtonArray : "+radioButtonArray.indexOf(myTXT));
				if(I==-1)
				{
					SaffronLogger.log("Cannot find current value between enterd radio buttons : "+myTXT.text+' vs '+radioButtonArray);
					myTXT.text = radioButtonArray[0];
					myTXT.dispatchEvent(new Event(Event.CHANGE));
					this.dispatchEvent(new Event(Event.CHANGE));
					return false ;
				}
				else
				{
					I = (I+1)%radioButtonArray.length ;
					myTXT.text = radioButtonArray[I];
					myTXT.dispatchEvent(new Event(Event.CHANGE));
					this.dispatchEvent(new Event(Event.CHANGE));
					return true ;
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