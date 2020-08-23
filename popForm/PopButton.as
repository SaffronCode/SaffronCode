package popForm
	//popForm.PopButton
{
	import appManager.displayContentElemets.LightImage;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import contents.LinkData;
	import appManager.event.AppEventContent;
	import stageManager.StageManager;
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;
	
	
	public class PopButton extends MovieClip
	{
		private static const debug_windowSpace:Boolean = true;
		
		/**List of titles that will listening to the back event from key board to act*/
		private static var backList:Array = [] ;
		
		
		private var txtTF:TextField ;
		
		private var backMC:MovieClip ;
		
		/**it can be an uint or string*/
		public var ID:* ;
		
		/**This is the buttonData*/
		public var buttonData:Object ;
		
		public var title:String ;
		
		private var me:PopButton ;
		
		
		private var soundMC:MovieClip ;
		
		/**This value will use on title*/
		public var myTitle:String,
					buttonImageURL:String;

		private var myLightImage:LightImage;
		
		/**You can change the button type with entering its frame index.<br>
		 * You can set full button data with ability to change selectable or button id by using PopButtonData object on completeButtonObject*/
		public function PopButton(str:String=''/*,colorTrans:ColorTransform=null*/,buttonID:*=0,type:uint = 1,completeButtonObject:* = null )
		{
			super();
			this.stop();
			me = this ;
			this.buttonMode = true ;
			this.mouseChildren = false ;
			
			soundMC = Obj.get("sound_mc",this);
			
			//Bellow lines will used on setUp function ↓
			/*if(completeButtonObject != null && completeButtonObject is PopButtonData)
			{
				type = completeButtonObject.buttonFrame ;
				buttonID = completeButtonObject.id ;
				str = completeButtonObject.title ;
				this.mouseChildren = this.mouseEnabled = completeButtonObject.selectable;
			}
			
			this.gotoAndStop(type);*/
			
			
			
			//this.mouseChildren = false;
			//txtTF = Obj.get('txt_txt',Obj.get('txt_txt',this));
			//txtTF.dispatchEvent(new Event(Event.ADDED,true));
			//backMC = Obj.get('back_mc',this);
			
			/*if(!DevicePrefrence.isTablet)
			{
				backMC.height += 20 ;
				//backMC.width += 20;
				//backMC.x+=10;
				backMC.y+=5;
				//txtTF.width+=20;
				txtTF.height+=10;
				var tf:TextFormat = txtTF.getTextFormat();
				tf.size = tf.size+10;
				txtTF.defaultTextFormat = tf ;
			}*/
			
			checkStage();
			
			if(str=='' && buttonID==0 && type==1 && completeButtonObject==null)
			{
				SaffronLogger.log("It should be the default values for the button");
			}
			else
			{
				setUp(str,buttonID,type,completeButtonObject);
			}
		}

		public function select():void
		{
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		public function moveUpByKeyboard(MaxMove:Number=0):void
		{
			allPositions = new Dictionary();
			maxMoveUp = MaxMove ;
			this.addEventListener(Event.ENTER_FRAME,checkKeyboard);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad2);
		}

			private const extraHeight:Number = 100 ;
			/**Will be create dynamicly */
			private var keyBoardHeight:Number = 0 ;

			private var allPositions:Dictionary ;

			private var maxMoveUp:Number ;

			private function checkKeyboard(e:Event):void
			{
				if(this.parent!=null && this.stage.softKeyboardRect.height>0)//stage.mouseX>100
				{
					trace("stage.fullScreenWidth : "+stage.fullScreenWidth);
					trace("stage.stageWidth : "+stage.stageWidth);
					if(keyBoardHeight==0)//
					{
						var stageScale:Number = stage.fullScreenWidth/stage.stageWidth ;
						trace("stageScale : "+stageScale);
						trace("this.stage.softKeyboardRect : "+this.stage.softKeyboardRect)
						keyBoardHeight = (Math.sqrt(Math.pow(this.stage.softKeyboardRect.width,2)/2))/stageScale+extraHeight;//stage.mouseX-100;
					}
					var stageFullscreenH:Number = StageManager.stageVisibleArea.height;
					trace("stageFullscreenH : "+stageFullscreenH);
					var textFieldBottomBasedOnRoot:Number = this.parent.localToGlobal(new Point(0,this.y+this.height/2)).y ;
					trace("textFieldBottomBasedOnRoot : "+textFieldBottomBasedOnRoot);
					var textFeildFromBottom:Number = stageFullscreenH-(textFieldBottomBasedOnRoot+StageManager.stageDelta.height/2);
					var moveUpTo:Number = Math.max(0,keyBoardHeight-textFeildFromBottom) ;
					if(maxMoveUp>0)
					{
						moveUpTo = Math.min(maxMoveUp,moveUpTo);
					}
					trace("keyBoardHeight : "+keyBoardHeight);
					trace("textFeildFromBottom : "+textFeildFromBottom);
					trace("Move it up to : "+moveUpTo);
					for(var i:int = 0 ; i<this.numChildren ; i++)
					{
						var currentItem:DisplayObject = this.getChildAt(i) ;
						var Y:Number = allPositions[currentItem] ;
						if(isNaN(Y))
						{
							Y = allPositions[currentItem] = currentItem.y ;
						}
						currentItem.y += ((Y-moveUpTo)-currentItem.y)/5 ;
					}
				}
				else if(keyBoardHeight!=0)
				{
					for(var j:int = 0 ; j<this.numChildren ; j++)
					{
						var currentItem2:DisplayObject = this.getChildAt(j) ;
						var Y2:Number = allPositions[currentItem2] ;
						if(!isNaN(Y2))
						{
							currentItem2.y = Y2 ;
						}
					}
					keyBoardHeight = 0 ;//To prevent items move
				}
			}

			private function unLoad2(e:Event):void
			{
				this.removeEventListener(Event.ENTER_FRAME,checkKeyboard);
			}
		
		
		/**add titles that will triggerring the back button*/
		public static function addBackTitleTrigger(backTitle:String)
		{
			backList.push(backTitle);
		}
		
		/**Check the stage*/
		private function checkStage(e:Event=null):void
		{
			
			this.removeEventListener(Event.ADDED_TO_STAGE,checkStage);
			if(this.stage == null)
			{
				this.addEventListener(Event.ADDED_TO_STAGE,checkStage);
			}
			else
			{
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,checkBack);
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			}
		}
		
		protected function unLoad(event:Event):void
		{
			
			this.removeEventListener(Event.ENTER_FRAME,controllPosition2);
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN,checkBack);
		}
		
		private function checkBack(e:KeyboardEvent)
		{
			if(!Obj.getVisible(me) || !Obj.getImOnStage(me))
			{
				return ;
			}
			if(backList.indexOf(title)!=-1)
			{
				//		debug button
				if((debug_windowSpace && e.keyCode == Keyboard.SPACE) || e.keyCode == Keyboard.BACK)
				{
					me.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));
					me.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true));
					me.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,true));
					e.preventDefault();
				}
			}
		}

		public function onClick(func:Function):void
		{
			Obj.setButton(this,func);
		}

		public function setUpByLink(linkData:LinkData):void
		{
			setUp(linkData.name);
			var ME:PopButton = this ;
			onClick(function():void{
				ME.dispatchEvent(new AppEventContent(linkData));
			});
		}

		
		/**From now , buttonID can be both string or uint<br>
		 * You can set the button image if it has LighiImage on its frame*/
		public function setUp(str:String/*,colorTrans:ColorTransform=null*/,buttonID:*=0,type:uint = 1,completeButtonObject:* = null,buttonImage:String=null):PopButton
		{
			if(completeButtonObject != null && completeButtonObject is PopButtonData)
			{
				type = completeButtonObject.buttonFrame ;
				buttonID = completeButtonObject.id ;
				str = completeButtonObject.title ;
				buttonData = (completeButtonObject as PopButtonData).dynamicData ;
				this.mouseEnabled = completeButtonObject.selectable;
			}
			
			buttonImageURL = buttonImage ;
			
			this.gotoAndStop(type);
			
			var controllStage:Boolean = false ;
			
			if(buttonImage!=null)
			{
				SaffronLogger.log("♠ the button image is not null : "+buttonImage);
				myLightImage = Obj.findAllClass(LightImage,this)[0];
				controllStage = true ;
			}
			
			var txtContainer:MovieClip = Obj.get('txt_txt',this) ;
			if(txtContainer!=null)
			{
				txtTF = Obj.get('txt_txt',Obj.get('txt_txt',this));
				if(txtTF)
				{
					txtTF.dispatchEvent(new Event(Event.ADDED,true));
				}
			}
			backMC = Obj.get('back_mc',this);
			
			ID = buttonID ;
			//SaffronLogger.log("Button title is : "+title);
			title = str ;
			
			//SaffronLogger.log('SAVE AND EXIT BUTTON : '+str);
			
			if(txtTF)
			{
				txtTF.text = '' ;
			
				if(str!='')
				{
					myTitle = str ;
					controllStage = true;
				}
			}
			/*if(colorTrans!=null)
			{
				backMC.transform.colorTransform = colorTrans ;
			}*/
			
			if(controllStage)
			{
				controllTextOnStage();
			}
			
			if(soundMC)
			{
				this.addEventListener(MouseEvent.CLICK,playAsound);
			}
			return this;
		}
		
			/**Check when the button added to stage*/
			private function controllTextOnStage():void
			{
				this.removeEventListener(Event.ADDED_TO_STAGE,controllPosition);
				if(this.stage!=null)
				{
					controllPosition();
				}
				else
				{
					this.addEventListener(Event.ADDED_TO_STAGE,controllPosition);
				}
			}
			
				/**Contrll the button position*/
				protected function controllPosition(event:Event=null):void
				{
					if(this.localToGlobal(new Point()).y<1800)
					{
						createElements();
					}
					else
					{
						this.addEventListener(Event.ENTER_FRAME,controllPosition2);
						this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
					}
				}
				
					/**Controll the button y after enter frame*/
					protected function controllPosition2(event:Event):void
					{
						if(this.localToGlobal(new Point()).y<1800)
						{
							this.removeEventListener(Event.ENTER_FRAME,controllPosition2);
							createElements();
						}
					}
				
						/**Create the interface now*/
						private function createElements():void
						{
							//SaffronLogger.log("Create the elemets");
							if(myLightImage!=null)
							{
								myLightImage.setUp(buttonImageURL,true);
							}
							
							if(txtTF)
							{
								if(txtTF.multiline)
								{
									TextPutter.onTextArea(txtTF,myTitle,true,true,false);
								}
								else
								{
									TextPutter.OnButton(txtTF,myTitle,true,true,false);
								}
							}
						}
		
		protected function playAsound(event:MouseEvent):void
		{
			
			soundMC.play();
		}
	}
}