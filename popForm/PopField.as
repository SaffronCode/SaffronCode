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
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**Text field is changed*/
	[Event(name="change", type="flash.events.Event")]
	/**Text field is changing*/
	[Event(name="render", type="flash.events.Event")]
	public class PopField extends PopFieldInterface
	{
		private var myTXTs:Array ;
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
		
		private var nativeKeyBoards:Vector.<FarsiInputCorrection> ;
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
				if(myTXTs.length>1)
				{
					return data;
				}
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
				if(myTXTs.length>1)
				{
					update(value);
					return;
				}
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
				var newtext:String = String(data);
				if(myTXTs.length>1)
				{
					for(var i:int = 0 ; i<myTXTs.length ; i++)
					{
						(myTXTs[i] as TextField).text = newtext.length>i?newtext.charAt(i):'' ;
						(myTXTs[i] as TextField).dispatchEvent(new Event(Event.CHANGE));
					}
				}
				else
				{
					myTXT.text = newtext ;
					myTXT.dispatchEvent(new Event(Event.CHANGE));
				}
			}
		}
		
		override public function get data():*
		{
			if(myTXTs.length>1)
			{
				lastTXT = '' ;
				for(var i:int = 0 ; i<myTXTs.length ; i++)
				{
					lastTXT += (myTXTs[i] as TextField).text ;
				}
			}
			else
			{
				lastTXT = myTXT.text;
			}
			if(phoneControl)
			{
				var cash:String = PhoneNumberEditor.clearPhoneNumber(lastTXT);
				if(cash == 'false')
				{
					SaffronLogger.log("This phone number is incorrect");
					return lastTXT ;
				}
				else
				{
					return cash ;
				}
			}
			return lastTXT ;
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
			if(nativeKeyBoard!=null || nativeKeyBoards!=null)
			{
				if(myTXTs.length>1)
				{
					(nativeKeyBoards[nativeKeyBoards.length-1] as FarsiInputCorrection).onEnterPressed(func);
				}
				else
				{
					nativeKeyBoard.onEnterPressed(func);
				}
			}
		}

		private function nextField(currentTextField:TextField):void
		{
			var currentTextFieldIndex:int = myTXTs.indexOf(currentTextField);
			trace("Next field to "+currentTextFieldIndex+" is editing>"+(nativeKeyBoards!=null && currentTextFieldIndex!=-1?nativeKeyBoards[currentTextFieldIndex].editing:''));
			if(nativeKeyBoards!=null && currentTextFieldIndex!=-1 && nativeKeyBoards[currentTextFieldIndex].editing)
			{
				nativeKeyBoards[currentTextFieldIndex].closeKeyBoard(false);
				trace("\t"+currentTextFieldIndex+" vs "+(nativeKeyBoards.length-2));
				if(currentTextFieldIndex+1<nativeKeyBoards.length)
				{
					trace("Activate keyboard : "+nativeKeyBoards[currentTextFieldIndex+1]);
					nativeKeyBoards[currentTextFieldIndex+1].activateKeyboard();
				}
				else// if(currentTextFieldIndex<=nativeKeyBoards.length)
				{
					nativeKeyBoards[currentTextFieldIndex].callDone();
				}
			}
		}

		private function prevField(currentTextField:TextField,andRemoveAcharFrom:Boolean=false):void
		{
			if(myTXTs.length<=1)
				return;
			var currentTextFieldIndex:int = myTXTs.indexOf(currentTextField);
			trace("Next field to "+currentTextFieldIndex+" is editing>"+nativeKeyBoards[currentTextFieldIndex].editing);
			if(currentTextFieldIndex!=-1 && nativeKeyBoards[currentTextFieldIndex].editing)
			{
				nativeKeyBoards[currentTextFieldIndex].closeKeyBoard(false);
				if(currentTextFieldIndex>0)
				{
					trace("Activate keyboard : "+nativeKeyBoards[currentTextFieldIndex-1]);
					if(andRemoveAcharFrom)
					{
						var lastTF:TextField = myTXTs[currentTextFieldIndex-1] as TextField ;
						lastTF.text = lastTF.text.substr(0,lastTF.text.length-1);
					}
					nativeKeyBoards[currentTextFieldIndex-1].activateKeyboard();
				}
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
			myTXTs = Obj.getAllChilds('txt_txt',this,false) 
			if(myTXTs.length>1)
			{
				myTXTs = myTXTs.sort(sortFields);
				function sortFields(a:TextField,b:TextField):int
				{
					if(a.x<b.x)
						return -1;
					return 1;
				}
			}
			myTXT = myTXTs[0];
			//Do these all to myTXTs
			for(var i:int = 0 ; i<myTXTs.length ; i++)
			{
				makeThisTextReady(myTXTs[i]);
			}
			function makeThisTextReady(txt:TextField):void
			{
				txt.addEventListener(Event.CLOSE, dispatchChangeForMeToo);
				txt.addEventListener(Event.CHANGE, dispatchRenderEventForMe);
				txt.addEventListener(KeyboardEvent.KEY_DOWN, checkBackRole);
				txt.maxChars = maxChar ;
				txt.borderColor = borderColor;
				txt.displayAsPassword = isPass ;
				txt.mouseEnabled = txt.selectable = editable ;
			}
			

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
				for(i = 0 ; i<numLines-1 ; i++)
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
			if(myTXTs.length>1)
			{
				for(i=0 ; i<myTXTs.length ; i++)
				{
					(myTXTs[i] as TextField).text = lastTXT.length<i?lastTXT.charAt(i):'';
				}
			}
			else
			{
				myTXT.text = lastTXT;
			}
			
			
			//FarsiInputText.steKeyBord(myTXT,false);
			if(editable)
			{
				if(myTXTs.length>1)
				{
					nativeKeyBoards = new Vector.<FarsiInputCorrection>();
					for(i = 0 ; i<myTXTs.length ; i++)
					{
						(myTXTs[i] as TextField).maxChars = 1 ;
						nativeKeyBoards.push(FarsiInputCorrection.setUp(myTXTs[i],KeyBordType,true,true,deleteDefautlText,justShowNativeText && !activeRadioMode,true,true,returnKey,i==myTXTs.length-1?onTypedFunction:nextField,null,selectAllCharchter));
					}
				}
				else
				{
					nativeKeyBoard = FarsiInputCorrection.setUp(myTXT,KeyBordType,true,true,deleteDefautlText,justShowNativeText && !activeRadioMode,true,true,returnKey,onTypedFunction,null,selectAllCharchter);
				}

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
				
				if(textContainerMC==null && myTXTs.length==1)
				{
					textContainerMC = new MovieClip();
					myTXT.parent.addChild(textContainerMC);
					textContainerMC.addChild(myTXT);
					textContainerMC.x = myTXT.x;
					textContainerMC.y = myTXT.y;
					myTXT.x = myTXT.y = 0 ;
				}
				
				if(isAraic && myTXTs.length==1)
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
				else if(myTXTs.length==1)
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
			var currentTXT:TextField = e.currentTarget as TextField ;
			if(clearMC)
				clearMC.visible = currentTXT.text.length>0 ; 
				
			trace("* Changed > "+currentTXT.maxChars);
			if(currentTXT.maxChars<=currentTXT.text.length)
			{
				trace("Show the nextField");
				setTimeout(nextField,0,currentTXT);
			}
			this.dispatchEvent(new Event(Event.RENDER));
		}

		private function checkBackRole(e:KeyboardEvent):void
		{
			if(e.keyCode == 8)//Keyboard.BACKSPACE
			{
				var currentTXT:TextField = e.currentTarget as TextField ;
				trace("Back space");
				if(currentTXT.text=='')
				{
					setTimeout(prevField,0,currentTXT,true);
				}
			}
			else
			{
				
			}
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
			event.stopImmediatePropagation();
			if(myTXTs.length>1)
			{
				for(var i:int = 0 ; i<myTXTs.length ; i++)
				{
					nativeKeyBoards[i].showPass();
				}
			}
			else
			{
				nativeKeyBoard.showPass();
			}
			stage.addEventListener(MouseEvent.MOUSE_UP,hidePass);
		}
		
		protected function hidePass(event:MouseEvent):void
		{
			if(myTXTs.length>1)
			{
				for(var i:int = 0 ; i<myTXTs.length ; i++)
				{
					nativeKeyBoards[i].hidePass();
				}
			}
			else
			{
				nativeKeyBoard.hidePass();
			}
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
			var selectedItem:TextField = event.target as TextField ;
			if(selectedItem!=null && myTXTs.indexOf(selectedItem)==-1)
			{
				activateKeyBoard();
			}
			//if(!myTXT.hitTestPoint(stage.mouseX,stage.mouseY) && (showPassMC==null || !showPassMC.hitTestPoint(stage.mouseX,stage.mouseY)))
			//{
			//}
		}
		
		/**My input text is updated, so dispatch change event on my object*/
		protected function dispatchChangeForMeToo(event:Event):void
		{
			var currentTXT:TextField = event.currentTarget as TextField ;
			if(!isNaN(min) && !isNaN(Number(currentTXT.text)))
			{
				currentTXT.text = Math.max(min,Number(currentTXT.text)).toString();
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**Open the device key board*/
		public function activateKeyBoard():void
		{
			if(!super.enabled)
				return;
				
			if((nativeKeyBoard!=null || nativeKeyBoards!=null) && myTXT.mouseEnabled && !activeRadioMode)
			{
				if(myTXTs.length==1)
					nativeKeyBoard.focuseOnStageText();
				else
				{
					for(var i:int = 0 ; i<myTXTs.length ; i++)
					{
						if((myTXTs[i] as TextField).text=='')
						{
							nativeKeyBoards[i].focuseOnStageText();
							return;
						}
					}
					nativeKeyBoards[myTXTs.length-1].focuseOnStageText();
				}
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