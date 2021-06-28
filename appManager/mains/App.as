package appManager.mains
{
	import appManager.animatedPages.Intro;
	import appManager.animatedPages.MainAnim;
	import appManager.animatedPages.Shiner;
	import appManager.animatedPages.pageManager.MenuManager;
	import appManager.animatedPages.pageManager.PageManager;
	import appManager.animatedPages.pageManager.TitleManager;
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	import appManager.event.MenuEvent;
	import appManager.event.TitleEvent;
	
	import com.mteamapp.StringFunctions;
	
	import contents.LinkData;
	import contents.PageData;
	import contents.soundControll.ContentSoundManager;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	
	import myAsCSS.MyAsCSS;
	
	import soundPlayer.SoundPlayer;
	import contents.alert.Alert;
	import sliderMenu.SliderManager;
	import contents.History;
	import mteam.FuncManager;
	import flash.utils.setTimeout;
	import flash.events.UncaughtErrorEvent;
	
	/**Now its ready to call other pages*/
	[Event(name="MAIN_ANIM_IS_READY", type="appManager.event.AppEvent")]
	/**Intro is over and app is starting to open*/
	[Event(name="APP_STARTS", type="appManager.event.AppEvent")]
	/**Use this class for the applications without any content . it just manage page manager with PageEvents without need to use content types<br>
	 * add Intro and PageManger DisplayObject Classes to stage*/
	public class App extends MovieClip
	{
		private static var ME:App ;

		private static const homePageReadyFuncId:uint = 43248407;
		
		protected var pageManagerObject:PageManager ;
		
		protected var menuManagerObject:MenuManager ;
		
		/**Current menu in the menuManagerObject*/
		private static var _currentMenu:DisplayObject = null ;
		
		private static var shineAreaMC:Shiner ;

		private static var pageVibrate:Boolean =true;
		
		/**It will be true when APP_IS_READY event calls*/
		public function get appIsReady():Boolean
		{
			return _appIsReady;
		}

		public static function get currentMenu():DisplayObject
		{
			return _currentMenu;
		}

		public static function changePage(pageId:String,level:int=-1,dunamicData:Object=null,forceToRefreshPage:Boolean=false):void
		{
			var link:LinkData = new LinkData().createLinkFor(pageId,dunamicData,level);
			ME.dispatchEvent(new AppEventContent(link,false,forceToRefreshPage));
		}
		
		public static function changePageByLink(pageLink:LinkData,forceToReload:Boolean=false):void
		{
			ME.dispatchEvent(new AppEventContent(pageLink,false,forceToReload));
		}
		
		//replaced with TitleManager.ME
		//protected var titleManager:TitleManager ;
		
		protected var introMC:Intro ;
		
		protected var mainAnim:MainAnim ;
		public static var currentAppEvent:AppEvent;
		
		private static var is_in_home:Boolean = true ;
		
		/**This will maka all animated paged to open without animation*/
		public static var skipAnimations:Boolean,
							haveShiner:Boolean;
							
		/**This will makes player to play music on background to*/
		private var playSounOnBackGroundTo:Boolean ;
		
		
		private static var AutoPlayThePageMusics:Boolean ;
		
		private static var _appIsReady:Boolean = false ;

		public static var isArabic:Boolean =true;
		
		public static function get isInHome():Boolean
		{
			return is_in_home ;
		}
		
		public function App(autoPlayThePageMusics:Boolean=false,skipAllAnimations:Boolean = false,activateShineEffect:uint=0,PlaySounOnBackGroundTo:Boolean=false,activateVibrate:Boolean=true)
		{
			super();
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);


			History.reset();
			pageVibrate = activateVibrate ;
			
			playSounOnBackGroundTo = PlaySounOnBackGroundTo ;
			
			haveShiner = activateShineEffect!=0 ;
			if(haveShiner)
			{
				shineAreaMC = new Shiner();
				stage.addChild(shineAreaMC);
			}
			
			ME = this ;
			
			skipAnimations = skipAllAnimations ;
			
			AutoPlayThePageMusics = autoPlayThePageMusics ;
			
			pageManagerObject = Obj.findThisClass(PageManager,this,true) as PageManager;
			menuManagerObject = Obj.findThisClass(MenuManager,this,true) as MenuManager;
			//titleManager = Obj.findThisClass(TitleManager,this,true) as TitleManager;
			
			introMC = Obj.findThisClass(Intro,this,true) as Intro;
			mainAnim = Obj.findThisClass(MainAnim,this,true) ;
			
			if(mainAnim!=null)
			{
				mainAnim.addEventListener(AppEvent.MAIN_ANIM_IS_READY,changePage);
			}
			
			SaffronLogger.log('introMC : '+introMC);
			//manage intro ↓
			if(introMC != null)
			{
				introMC.addEventListener(Intro.EVENT_FINISHED,intoIsOver);
			}
			else
			{
				appIsStarts();	
			}
			
			this.addEventListener(AppEvent.PAGE_CHANGES,managePages);
			this.addEventListener(TitleEvent.CHANGE_TITLE,changeTheTitle);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,controllBackButton);
			SoundPlayer.preventExitHandler();
			
			//This will remind that first page of the application is HomePage
			is_in_home = true ;
			hopePageOppened(true);
			
			this.addEventListener(MenuEvent.MENU_READY,setTheCurrentMenu);
			this.addEventListener(MenuEvent.MENU_DELETED,removeCurrentMenu);
		}	

		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				SaffronLogger.log(error.message+'\n'+error.getStackTrace());
			}
		}
		
		protected function removeCurrentMenu(event:MenuEvent):void
		{
			
			_currentMenu = null ;
		}
		
		protected function setTheCurrentMenu(event:MenuEvent):void
		{
			
			SaffronLogger.log("New menu is ready");
			_currentMenu = event.menuTarget ;
		}
		
		protected function changeTheTitle(event:TitleEvent):void
		{
			
			if(TitleManager.ME.length>0)
			{
				var fakePageData:PageData = new PageData();
				fakePageData.title = event.title;
				var fakeAppEvent:AppEventContent = new AppEventContent(new LinkData(),true,true);
				fakeAppEvent.pageData = fakePageData ;
				for(var i:int = 0 ; i<TitleManager.ME.length ; i++)
				{
					TitleManager.ME[i].isArabic=isArabic;
					TitleManager.ME[i].setUp(fakeAppEvent,true);
				}
			}
		}
		
		/**Controll the back button on android*/
		protected function controllBackButton(ev:KeyboardEvent):void
		{
			if(ev.keyCode == Keyboard.BACK || ev.keyCode == Keyboard.PAGE_UP)
			{
				//SaffronLogger.log("back button selects : "+AppEventContent.backAvailable());
				if(SliderManager.isOpen())
				{
					ev.preventDefault();
					SliderManager.hide();
				}
				else if(AppEventContent.backAvailable())
				{
					ev.preventDefault();
					this.dispatchEvent(AppEventContent.lastPage());
				}
			}
		}
		
/////////////////////////intro mangers ↓
		
		/**Stop the intro till you need*/
		public function stopIntro():void
		{
			if(introMC!=null)
			{
				introMC.stop();
			}
		}
		
		/**Returns the intro animation to the stage and goto first frame*/
		public function resetIntro():void
		{
			if(introMC!=null)
			{
				if(introMC.parent==null)
				{
					introMC.alpha = 0 ;
				}
				this.addChild(introMC);
				AnimData.rewind(introMC);
				AnimData.fadeIn(introMC);
			}
		}

		private static var _introIsStoppedByOuterRequest:Boolean = false ;

		public static function stopTheIntro():void
		{
			_introIsStoppedByOuterRequest = true ;
			ME.stopIntro();
		}

		public static function playTheIntro():void
		{
			if(_introIsStoppedByOuterRequest)
			{
				_introIsStoppedByOuterRequest = false ;
				ME.playIntro();
			}
		}
		
		/**Start to play intro*/
		public function playIntro():void
		{
			if(introMC==null || !introMC.visible || _introIsStoppedByOuterRequest)
				return;
			if(introMC!=null)
			{
				introMC.play() ;
			}
			else
			{
				appIsStarts();
			}
		}
		
		/**This functin will make intro to skip to the end*/
		public function skipIntro():void
		{
			introMC.gotoAndPlay(introMC.totalFrames-1);
		}
		
//////////////////////intro managers ↑
		
		
		/**this function will dispatches whenever intro is over*/
		protected function intoIsOver(e=null):void
		{
			introMC.removeEventListener(Intro.EVENT_FINISHED,intoIsOver);
			Obj.remove(introMC);
			//introMC = null ;
			appIsStarts();
		}
		
		/**now the application is ready for client to use*/
		protected function appIsStarts():void
		{
			ContentSoundManager.setUp(stage,playSounOnBackGroundTo);
			this.dispatchEvent(new AppEvent(null,AppEvent.APP_STARTS));
			currentAppEvent = new AppEvent();
			if(mainAnim==null)
			{
				throw "You shoud add a MovieClip base on appManager.animatedPages.MainAnim to your project on the stage."
			}
			if(!mainAnim.isOpened())
			{
				backToHomePage();
			}				
			this.dispatchEvent(new AppEvent(null,AppEvent.HOME_IS_READY));
		}
		
		/**Refresh te current page */
		public static function refresh():void
		{
			ME.dispatchEvent(AppEvent.refreshEvent());
		}
		
		/**Show shine effect on the stage*/
		public static function showShineEffect(element:Sprite):void
		{
			if(haveShiner)
			{
				shineAreaMC.add(element);
			}
			else
			{
				SaffronLogger.log("Shiner is not activated on project");
			}
		}
		
		/**Returnd true if the current page is not same as the last page*/
		protected function managePages(event:AppEvent):Boolean
		{
			if(pageVibrate)
				Alert.vibratePuls();
			if(event.target!=null && event.target is Sprite)
			{
				showShineEffect(event.target as Sprite);
			}
			SaffronLogger.log('page changes to : '+event.myID);
			//currentAppEvent = event ;•↓
			//Why it dosen't currentAppEvent befor???????????????????????????
			//I had bug befot, I tried to get back to home page when the main anim is animating to external pages and it caused crash when I checked current Event with pageManager's event.
			//I added currentAppEvent != null to prevent error when you requested to open page when it is not reached to main page.
			if(StringFunctions.isURL(event.myID))
			{
				navigateToURL(new URLRequest(event.myID));
				return false;
			}
			if(currentAppEvent!=null && /*pageManagerObject.toEvent*/currentAppEvent.myID == event.myID && AppEvent.home != event.myID && currentAppEvent.myType!=AppEvent.refresh && event.reload==false)
			{
				SaffronLogger.log("Duplicated page id : "+currentAppEvent.myID);
				return false;
			}
			//Moved from top↑•
			SaffronLogger.log("currentAppEvent : "+currentAppEvent);
			SaffronLogger.log("event : "+event);
			if(event.myType == AppEvent.refresh && (currentAppEvent == null || currentAppEvent.myType == AppEvent.home))
			{
				SaffronLogger.log("refresh is not works on home page");
				return false ;
			}
				currentAppEvent = event ;
				
				if(AutoPlayThePageMusics && event is AppEventContent/* && (event as AppEventContent).pageData.musicURL!=''*/)
				{
					ContentSoundManager.changeMainMusic((event as AppEventContent).pageData.musicURL,(event as AppEventContent).pageData.musicVolume);
				}
				
			
			if(mainAnim == null)
			{
				//do it if mainAnim doesent exists
				SaffronLogger.log("*************** page change 1");
				manageAllAnimatedPaged(event);
			}
			
			if(event.myType == AppEvent.home)
			{
				SaffronLogger.log("show homw page")
				backToHomePage();
				
				is_in_home = true ;//This value moved up
				//I forgot to write this line of code here ↓
				this.changePage(event);
				//It will close PageManger instantly
				//This function calls with true when the home page oppened:
				hopePageOppened(true);
			}
			else
			{
				SaffronLogger.log("close home page")
				showExternalPages();
				//This function calls when external pages oppened:
				is_in_home = false ;
				hopePageOppened(false);
			}
			
			if(currentAppEvent is AppEventContent)
			{
				setPageId(currentAppEvent.myID);
			}
			
			return true ;
		}
		
		
		
		/**You can use pageID by this class*/
		public function setPageId(pageId:String):void
		{
			
		}
		
		/**This function will tell you if this is the home page or not*/
		protected function hopePageOppened(status:Boolean):void
		{
			//This is home page or not
		}
		
		/**This function will call just when the mainAnim is exists*/
		protected function changePage(s:AppEvent):void
		{
			
			SaffronLogger.log("Main anim is ready!!"+currentAppEvent.myID);
			var wasReady:Boolean = _appIsReady ;
			_appIsReady = true ;
			manageAllAnimatedPaged(currentAppEvent);
			if(!wasReady)
			{
				setTimeout(FuncManager.callFuncList,0,homePageReadyFuncId);
			}
		}

		public static function onReady(onReadyToCallPaged:Function):void
		{
			if(_appIsReady)
				onReadyToCallPaged();
			else
				FuncManager.addFuncToList(onReadyToCallPaged,homePageReadyFuncId);
		}	
		
		private function manageAllAnimatedPaged(selectedEvent:AppEvent):void
		{
			/*pageManagerObject.setUp(selectedEvent);
			if(menuManagerObject)
			{
				menuManagerObject.setUp(selectedEvent as AppEventContent);
			}
			if(titleManager!=null)
			{
				titleManager.setUp(selectedEvent);
			}*/
			
		//////////////////////////////////////////////
			if(pageManagerObject==null)
			{
				throw "You forgot to add appManager.animatedPages.pageManager.PageManager to your project.\n\n";
			}
			pageManagerObject.setUp(selectedEvent);
			if(menuManagerObject && !AppEvent.isRefereshEvent(selectedEvent))
			{
				menuManagerObject.setUp(selectedEvent as AppEventContent);
			}
			if(TitleManager.ME.length>0 && !AppEvent.isRefereshEvent(selectedEvent))
			{
				for(var i:int = 0 ; i<TitleManager.ME.length ; i++)
				{
					TitleManager.ME[i].setUp(selectedEvent);
				}
			}
		}
		
		
	//Main anim manager
		protected function backToHomePage():void
		{
			
			if(mainAnim != null)
			{
				mainAnim.goHome();
			}
		}
		
		
		protected function showExternalPages():void
		{
			
			if(mainAnim != null)
			{
				mainAnim.goInternalPage();
			}
		}
	}
}