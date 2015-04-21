package appManager.mains
{
	import appManager.animatedPages.Intro;
	import appManager.animatedPages.MainAnim;
	import appManager.animatedPages.pageManager.PageManager;
	import appManager.animatedPages.pageManager.TitleManager;
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import myAsCSS.MyAsCSS;
	
	/**Use this class for the applications without any content . it just manage page manager with PageEvents without need to use content types<br>
	 * add Intro and PageManger DisplayObject Classes to stage*/
	public class App extends MovieClip
	{
		protected var pageManagerObject:PageManager ;
		
		protected var titleManager:TitleManager ;
		
		protected var introMC:Intro ;
		
		protected var mainAnim:MainAnim ;
		private var currentAppEvent:AppEvent;
		
		public function App()
		{
			super();
			
			pageManagerObject = Obj.findThisClass(PageManager,this,true) as PageManager;
			titleManager = Obj.findThisClass(TitleManager,this,true) as TitleManager;
			
			introMC = Obj.findThisClass(Intro,this,true) as Intro;
			mainAnim = Obj.findThisClass(MainAnim,this,true) ;
			
			if(mainAnim!=null)
			{
				mainAnim.addEventListener(AppEvent.MAIN_ANIM_IS_READY,changePage);
			}
			
			trace('introMC : '+introMC);
			//manage intro ↓
			if(introMC != null)
			{
				introMC.addEventListener("imFinished",intoIsOver);
			}
			else
			{
				appIsStarts();	
			}
			
			this.addEventListener(AppEvent.PAGE_CHANGES,managePages);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,controllBackButton);
		}	
		
		/**Controll the back button on android*/
		protected function controllBackButton(ev:KeyboardEvent):void
		{
			if(ev.keyCode == Keyboard.BACK || ev.keyCode == Keyboard.PAGE_UP)
			{
				//trace("back button selects : "+AppEventContent.backAvailable());
				if(AppEventContent.backAvailable())
				{
					ev.preventDefault();
					this.dispatchEvent(AppEventContent.lastPage());
				}
			}
		}
		
/////////////////////////intro mangers ↓
		
		/**Stop the intro till you need*/
		public function stopIntro()
		{
			if(introMC!=null)
			{
				introMC.stop();
			}
		}
		
		/**Start to play intro*/
		public function playIntro()
		{
			if(introMC!=null)
			{
				introMC.play() ;
			}
			else
			{
				appIsStarts();
			}
		}
		
//////////////////////intro managers ↑
		
		
		/**this function will dispatches whenever intro is over*/
		protected function intoIsOver(e=null)
		{
			Obj.remove(introMC);
			introMC = null ;
			appIsStarts();
		}
		
		/**now the application is ready for client to use*/
		protected function appIsStarts()
		{
			this.dispatchEvent(new AppEvent(null,AppEvent.APP_STARTS));
			currentAppEvent = new AppEvent();
			backToHomePage();
		}
		
		/**Returnd true if the current page is not same as the last page*/
		protected function managePages(event:AppEvent):Boolean
		{
			trace('page changes to : '+event.myID);
			//currentAppEvent = event ;•↓
			//Why it dosen't currentAppEvent befor???????????????????????????
			//I had bug befot, I tried to get back to home page when the main anim is animating to external pages and it caused crash when I checked current Event with pageManager's event.
			if(/*pageManagerObject.toEvent*/currentAppEvent.myID == event.myID)
			{
				return false;
			}
			//Moved from top↑•
				currentAppEvent = event ;
			// TODO Auto-generated method stub
			if(mainAnim == null)
			{
				//do it if mainAnim doesent exists
				pageManagerObject.setUp(event);
				if(titleManager!=null)
				{
					titleManager.setUp(event);
				}
			}
			
			if(event.myType == AppEvent.home)
			{
				trace("show homw page")
				backToHomePage();
				
				//I forgot to write this line of code here ↓
				changePage(event);
				//It will close PageManger instantly
			}
			else
			{
				trace("close home page")
				showExternalPages();
			}
			return true ;
		}
		
		/**This function will call just when the mainAnim is exists*/
		protected function changePage(event:AppEvent):void
		{
			// TODO Auto-generated method stub
			trace("Main anim is ready");
			pageManagerObject.setUp(currentAppEvent);
			if(titleManager!=null)
			{
				titleManager.setUp(currentAppEvent);
			}
		}	
		
		
	//Main anim manager
		protected function backToHomePage():void
		{
			// TODO Auto Generated method stub
			if(mainAnim != null)
			{
				mainAnim.goHome();
			}
		}
		
		
		protected function showExternalPages():void
		{
			// TODO Auto Generated method stub
			if(mainAnim != null)
			{
				mainAnim.goInternalPage();
			}
		}
	}
}