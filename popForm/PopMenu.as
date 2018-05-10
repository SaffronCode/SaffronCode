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
	
	public class PopMenu extends MovieClip
	{
		private static const CANCEL_ELEMENT_NAME:String = "cancel_mc" ;
		
		/**main object of class*/
		private static var ME:PopMenu;
		
		public var popDispatcher:PopMenuDispatcher = new PopMenuDispatcher();
		
		private static var backButtonName:String ; 
		
		
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
					
		private var Y0:Number ;
					
					
		private var menuIconMC:MovieClip;
		
		/**this variables tells if this menu is visible or not*/
		public var show:Boolean = false;
					
					
///////////////////////////////////////////////
		/**this class will generate conten input of main from this class*/
		public var myContent:PopMenuContenDisplay ;
		
		private var closeTimer:Timer ;
		private var cashedContents:PopMenuContent;
		private var onButton:Function;
		private var onTimerClose:Function;
		private var _onClose:Function;
		
		private static var cancelNames:Array=[],
					cancelEvent:PopMenuEvent;
		
		private var cancelButton:MovieClip;
		
		
		public static function backEnable(backString:String)
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
					if(currentButtonName == backButtonName || currentButtonId == backButtonName)
					{
						popMenuitemsAreSelected(new PopMenuEvent(PopMenuEvent.POP_BUTTON_SELECTED,currentButtonId,null,backButtonName));
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
				onButton(buttonEvent);
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
		
		
		
		/**pop the pop menu up*/
		public function popUp2(title:String='' , type:PopMenuTypes=null , content:PopMenuContent=null,closeOnTime=0,onButtonSelects:Function=null,onClosedByTimer:Function=null,onClose:Function=null)
		{	
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
	}
}