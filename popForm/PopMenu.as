package popForm
	//popForm.PopMenu
{
	import avmplus.getQualifiedClassName;
	
	import flash.desktop.NativeApplication;
	import flash.display.FocusDirection;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import sliderMenu.SliderManager;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import stageManager.StageManager;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import stageManager.StageManagerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	
	public class PopMenu extends MovieClip
	{
		private static const CANCEL_ELEMENT_NAME:String = "cancel_mc" ;
		
		/**main object of class*/
		private static var ME:PopMenu;
		
		public var popDispatcher:PopMenuDispatcher = new PopMenuDispatcher();
		
		private static var backButtonName:* ; 
		
		
		/**main textfield from pop menu
		private var mainTXT:TextField;*/
		
		//private var content:PopMenuContenDisplay;
		
		/***/
		private var //titleMC:MovieClip,
					titleBackMC:MovieClip,
					titleTXT:TextField,
					titleCont:MovieClip;
					
		protected var titleContainerMC:MovieClip;
		
		/*private var buttomMC:MovieClip,
					buttomTXT:TextField;*/
					
					
		private var backMC:MovieClip,
					backMinH:Number,
					backMaxH:Number=600;

		private var backBitmapData:BitmapData,
					backBitmap:Bitmap;
		private var frameCounter:uint = 0,
					lastPose:Point ;

		/**You can activate Blur Effect by setting this value to true. you should change it right befor super() call on your main project class */
		public static var activateBlurForBackground:Boolean = true ;
					
		private var Y0:Number ;
					
					
		private var menuIconMC:MovieClip;
		
		/**this variables tells if this menu is visible or not*/
		public var show:Boolean = false;
					
					
///////////////////////////////////////////////
		/**this class will generate conten input of main from this class*/
		public var myContent:PopMenuContenDisplay ;
		
		private static var closeTimer:Timer ;
		private var cashedContents:PopMenuContent;
		private var onButton:Function;
		private var onTimerClose:Function;
		private var _onClose:Function;
		
		private static var cancelNames:Array=[],
					cancelEvent:PopMenuEvent;
		
		private var cancelButton:MovieClip;
		
		/**Enter a String or an Array of Strings*/
		public static function backEnable(backString:*)
		{
			backButtonName = backString ;
		}
		
		/**Activate the static cansel button*/
		public static function staticCanselEnabled(CancelNames:Array):void
		{
			cancelNames = CancelNames.concat() ;
			for(var i = 0 ; i<cancelNames.length ; i++)
			{
				cancelNames[i] = String(cancelNames[i]);
			}
		}
		
		/**Returns the content width*/
		public function getContentWidth():Number
		{
			return myContent.contentWidth ;
		}
		
		/**Returns the content height*/
		public function getContentHeight():Number
		{
			return myContent.contentHeight ;
		}
		
		public static function get popDispatcher():PopMenuDispatcher
		{
			return ME.popDispatcher ;
		}
					
		public function PopMenu()
		{
			super();
			ME = this ;
			var cancelButtons:Array = Obj.getAllChilds(CANCEL_ELEMENT_NAME,this); 
			if(cancelButtons.length>0)
			{
				cancelButton = cancelButtons[0];
			}
			if(cancelButton)
			{
				trace("cancelButton is defined");
				cancelButton.addEventListener(MouseEvent.CLICK,cancelSelected);
				cancelButton.buttonMode = true ;
			}
			else
			{
				trace("No global cancel button here");
			}
			
			Y0 = this.y ;
			
			this.addEventListener(Event.ENTER_FRAME,anim);
			this.gotoAndStop(1);
			this.visible = false;
			
			titleCont = Obj.get('title_container',this);
			titleCont.mouseChildren = titleCont.mouseEnabled = false ;
			titleBackMC = Obj.get('title_cont',this);
			titleBackMC.mouseChildren = titleBackMC.mouseEnabled = false ;
			if(titleCont)
			{
				titleTXT = Obj.get('title_txt',titleCont);
				titleContainerMC = new MovieClip();
				titleTXT.parent.addChild(titleContainerMC);
				titleContainerMC.x = titleTXT.x ;
				titleContainerMC.y = titleTXT.y ;
				titleContainerMC.addChild(titleTXT);
				titleTXT.x = 0 ;
				titleTXT.y = 0 ;
				titleTXT.parent.mouseChildren = titleTXT.parent.mouseEnabled = false ;
			}
			//titleMC = Obj.get('title_mc',titleBackMC);
			
			//content = Obj.get('contents_mc',this);
			
			myContent = Obj.findThisClass(PopMenuContenDisplay,this,true);
			myContent.addEventListener(PopMenuEvent.POP_BUTTON_SELECTED,popMenuitemsAreSelected);
			
			var backContainer:MovieClip = Obj.get('backGround_mc',this) ;
			if(backContainer)
			{
				if(activateBlurForBackground)
				{
					backBitmap = new Bitmap();
					backContainer.addChildAt(backBitmap,0);
				}

				this.addEventListener(Event.ENTER_FRAME,updateBackgroundBitmapPosition,false,-190);
				StageManager.eventDispatcher.addEventListener(StageManagerEvent.STAGE_RESIZED,updateBackgroundBitmapPosition);

				updateBackgroundBitmapPosition();
				backMC = Obj.get('backGround_mc',backContainer);
			}
			var mainBackMC:MovieClip ;
			
			var backGroundchilds:Array = Obj.getAllChilds('main_back_mc',this);
			//trace("backGroundchilds : "+backGroundchilds);
			if(backGroundchilds.length > 0)
			{
				mainBackMC = backGroundchilds[0] ;
			}
			
			if( mainBackMC != null )
			{
				mainBackMC.addEventListener(MouseEvent.CLICK,backClicked);
			}
			else
			{
				trace('main_back_mc is not definds');
			}
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,checkBack);
			
			if(backMC)
			{
				backMinH = backMC.height ;
			}
			
			menuIconMC = Obj.get('icon_mc',this);
			if(menuIconMC)
			{
				menuIconMC.stop();
			}
		}
		
		/**Returns true if any pop menu available*/
		public static function isAvailable():Boolean
		{
			if(ME!=null)
			{
				return true ;
			}
			return false ;
		}
		
		
		/**back button on key board pressed*/
		private function checkBack(ev:KeyboardEvent):void
		{
			
			if(ev.keyCode == Keyboard.BACK || ev.keyCode == Keyboard.BACKSPACE || ev.keyCode == Keyboard.PAGE_UP )
			{
				if(show)
				{
					ev.preventDefault();
					ev.stopImmediatePropagation();
				}
				var controll:Boolean = backClicked(null);
				//trace("FocusDirection : "+FocusDirection);
				//trace("(stage as Stage).focus : "+(stage as Stage).focus);
			}
		}
		
		protected function backClicked(event:MouseEvent):Boolean
		{
			
			//trace("show : "+show);
			if(show)
			{
				trace("Back ground clicked");
				if(backButtonName==null)
				{
					trace( "back button dose not work" ) ;
				}
				for(var i = 0 ; i<cashedContents.buttonList.length ; i++)
				{
					var currentButtonName:String = cashedContents.buttonList[i] ;
					var currentButtonId:String = cashedContents.buttonList[i] ;
					if(cashedContents.buttonList[i] is PopButtonData)
					{
						currentButtonName = (cashedContents.buttonList[i] as PopButtonData).title ;
						currentButtonId = (cashedContents.buttonList[i] as PopButtonData).id ;
					}
					//trace("Control this button : "+currentButtonName);
					if(
						(
							backButtonName is String
							&&
							(
								currentButtonName == backButtonName 
								|| 
								currentButtonId == backButtonName
							)
						)
						||
						(
							backButtonName is Array
							&&
							(
								backButtonName.indexOf(currentButtonName)!=-1 
								|| 
								backButtonName.indexOf(currentButtonId)!=-1
							)
						)
					)
					{
						popMenuitemsAreSelected(new PopMenuEvent(PopMenuEvent.POP_BUTTON_SELECTED,currentButtonId,null,currentButtonName));
						trace('back button selected');
						return true;
					}
				}
				trace('no back button avaliable');
			}
			else
			{
				trace("Pop menu is lock");
			}
			return false ;
		}		
		
		
		/**pop menu icons are selected , now it is time to pass it to dispatcher*/
		private function popMenuitemsAreSelected(e:PopMenuEvent)
		{
			this.close();
			var buttonEvent:PopMenuEvent = new PopMenuEvent(e.type,e.buttonID,e.field,e.buttonTitle,false,e.buttonData) ;
			if(onButton!=null)
			{
				var cash:Function = onButton ;
				onButton = null ;
				cash(buttonEvent);
			}
			popDispatcher.dispatchEvent(buttonEvent);
		}
		
		
		/**pop the menu up*/
		public static function popUp(title:String='' , type:PopMenuTypes=null , content:PopMenuContent=null,closeOnTime:uint=0)
		{
			trace('POP MENU OPENED '+Math.random());
			ME.popUp2(title, type, content,closeOnTime);
		}
		
		/**close the menu*/
		public static function close()
		{
			ME.close();
		}
		
		/**Close*/
		public function close()
		{
			this.show = false ;
			if(this.currentFrame == 1)
			{
				this.gotoAndStop(2);
			}
			if(_onClose!=null)
			{
				_onClose();
			}
		}
		
		/**this will tell if the popMenuIsOpen*/
		public static function get isOpen():Boolean
		{
			return ME.show ;
		}
		
		public static function stopTimer():void
		{
			if(closeTimer!=null)
			{
				closeTimer.stop();
			}
		}
		
		/**pop the pop menu up*/
		public function popUp2(title:String='' , type:PopMenuTypes=null , content:PopMenuContent=null,closeOnTime=0,onButtonSelects:Function=null,onClosedByTimer:Function=null,onClose:Function=null)
		{	
			SliderManager.hide();
			cashedContents = content ;
			
			onButton = onButtonSelects ;
			
			onTimerClose = onClosedByTimer ;
			
			_onClose = onClose;
			
			if(closeTimer!=null)
			{
				closeTimer.stop();
			}
			if(closeOnTime != 0)
			{
				closeTimer = new Timer(closeOnTime,1);
				closeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,closeME);
				closeTimer.start();
			}
			if(type==null)
			{
				type = PopMenuTypes.DEFAULT ;
			}
			
			
			show = true ;
			this.visible = true ;
			
			if(titleTXT)
			{
				TextPutter.OnButton(titleTXT,title,true,true,false,false);
				if( titleTXT.height > 600 )
				{
					titleTXT.height = 600 ;
				}
			}
			if(menuIconMC)
			{
				menuIconMC.gotoAndStop(type.frame) ;
			}
			
			//SoundManager.sound_popMenu_ba(type.soundID);
			
			//SoundManager.sound_popMenu();
			
			//titleMC.transform.colorTransform = type.colorTransform ;
			
			/**do not change the form position*/
			//ME.y = Y0-(backMC.height-backMinH)/2;
			
			myContent.setUp(content,false/*,type.colorTransform*/);
			if(backMC)
			{
				backMC.height = Math.max(Math.min(myContent.height+50,backMaxH),backMinH) ;//backMinH+Math.floor(Math.random()*(backMaxH-backMinH));
			}
			//trace("myContent.height : "+myContent.height + ' vs backMaxH : '+backMaxH+' vs backMinH : '+backMinH+' > '+backMC.height);
			
			if(cancelButton)
			{
				cancelEvent = null ;
				cancelButton.visible = false ;
				for(var i = 0 ; i<content.buttonList.length ; i++)
				{
					var button:* = content.buttonList[i] ;
					//trace("button : "+button);
					//trace("button is : "+getQualifiedClassName(button));
					var buttonName:String ;
					var buttonId:String ;
					var buttonData:Object ;
					if(button is PopButtonData)
					{
						//trace("This is data button");
						buttonName = (button as PopButtonData).title ;
						buttonId = (button as PopButtonData).id ;
						buttonData = (button as PopButtonData).dynamicData ;
					}
					else
					{
						//trace("This is the string button");
						buttonName = buttonId = String(button) ;
					}
					//trace("cancelNames : "+cancelNames);
					//trace("buttonName : "+buttonName);
					//trace(" cancelNames.indexOf(buttonName) : "+ cancelNames.indexOf(buttonName));
					if( cancelNames.indexOf(buttonName)!=-1)
					{
						cancelButton.visible = true ;
						cancelEvent = new PopMenuEvent(PopMenuEvent.POP_BUTTON_SELECTED,buttonId,null,buttonName,false,buttonData) ;
					}
				}
			}
		}
		
		private function cancelSelected(e:MouseEvent):void
		{
			this.close();
			popMenuitemsAreSelected(cancelEvent);
		}
		
		
		/**this function will close pop menu after requested time on popUp function*/
		private function closeME(e:TimerEvent)
		{
			close();
			if(onTimerClose!=null)
			{
				if(onTimerClose.length==0)
				{
					onTimerClose();
				}
				else
				{
					onTimerClose(null);
				}
			}
		}
		
///////////////////////////////////////////pop menu manager
		
		/**pop menu magaer*/
		private function anim(e:Event)
		{
			if(show)
			{
				if(this.currentFrame==this.totalFrames-1)
				{
					popDispatcher.dispatchEvent(new PopMenuEvent(PopMenuEvent.POP_SHOWS));
				}
				this.nextFrame();
			}
			else
			{
				for(var i = 0 ; i<3 ; i++)
				{
					if(this.currentFrame==2)
					{
						this.visible =false;
						popDispatcher.dispatchEvent(new PopMenuEvent(PopMenuEvent.POP_CLOSED));
						myContent.setUp();
					}
					this.prevFrame();
				}
			}
		}

		private var lastRect:Rectangle ;

		private function updateBackgroundBitmapPosition(e:*=null):void
		{
			if(this.visible==false || backBitmap==null)
			{
				//There is no need to update background position;
				return;
			}

			var resizeImage:Number = 0.1 ;
			var area:Rectangle = StageManager.stageVisibleArea;
			var reposeArea:Rectangle = StageManager.stageDelta ;




			
			//var scl:Number = Obj.getScale(this);
			var backContainer:DisplayObjectContainer = backBitmap.parent ;
			if(backContainer==null)
			{
				return;
			}


			var newPosition:Point = backContainer.globalToLocal(new Point(area.x,area.y));
			if(frameCounter%5==0 || !newPosition.equals(lastPose))
			{
				if(lastRect==null || area.width != lastRect.width || lastRect.height == area.height)
				{
					var imageW:Number = area.width*resizeImage ;
					var imageH:Number = area.height*resizeImage ;
					if(backBitmapData)
					{
						backBitmapData.dispose();
					}
					backBitmapData = new BitmapData(Math.max(1,imageW),Math.max(1,imageH),false,0xffffff);
					backBitmap.bitmapData = backBitmapData ;
				}
				this.visible = false ;
				var backCaptureMatrix:Matrix = new Matrix(resizeImage,0,0,resizeImage,reposeArea.width/2*resizeImage,reposeArea.height/2*resizeImage);
				backBitmapData.lock();
				backBitmapData.draw(backContainer.stage,backCaptureMatrix,null,null,null,true);
				this.visible = true ;
				backBitmapData.applyFilter(backBitmapData,backBitmapData.rect,new Point(),new BlurFilter(5,5,2))
				backBitmapData.unlock();
			}
			lastPose = newPosition.clone();
			frameCounter++;

			backBitmap.x = newPosition.x ;
			backBitmap.y = newPosition.y ;

			backBitmap.scaleX = (1.01/Obj.getScale(backContainer,true))/resizeImage;
			backBitmap.scaleY = (1/Obj.getScale(backContainer,false))/resizeImage;
		}
	}
}