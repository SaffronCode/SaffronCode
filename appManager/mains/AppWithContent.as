package appManager.mains
//appManager.mains.AppWithContent
{
//Uses
	//appManager.animatedPages.Intro
//appManager.animatedPages.MainAnim
	//appManager.animatedPages.pageManager.PageManager
	//appManager.animatedPages.pageManager.PageContainer

//To change pages
	//contents.displayElements.ContentNameDispatcher

	import appManager.animatedPages.pageManager.PageManager;
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	import appManager.event.PageControllEvent;
	
	import com.mteamapp.StringFunctions;
	import com.mteamapp.VersionController;
	
	import contents.Contents;
	import contents.ContentsEvent;
	import contents.History;
	import contents.PageData;
	import contents.alert.Alert;
	import contents.displayElements.DeveloperPage;
	import contents.robot.RankingSystem;
	
	import dataManager.GlobalStorage;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setTimeout;
	
	import permissionControlManifestDiscriptor.PermissionControl;
	
	import popForm.Hints;
	import popForm.PopButtonData;
	import popForm.PopMenu;
	import popForm.PopMenuContent;
	
	import sliderMenu.SliderManager;
	
	import stageManager.StageManager;
	import stageManager.StageManagerEvent;
	
	import wrokersJob.WorkerFunctions;
	
	public class AppWithContent extends App
	{
		/**This is the contentManager rectangle size. it will generate from the content w and h on the home xml tag*/
		private static var _contentRect:Rectangle = new Rectangle() ;
		
		private static var ME:AppWithContent ;
		
		/**Preventor variables*/
		private var preventorFunction:Function,
					preventorPage:DisplayObject,
					preventedEvent:AppEvent,
					prventedPageWasLastPage:Boolean;
					
					
		private var activeVersionControll:Boolean = false ;

		public var URISchemId:String;
		
		/**This is the contentManager rectangle size. it will generate from the content w and h on the home xml tag*/
		public static function get contentRect():Rectangle
		{
			trace("AppWithContent.contentRect() >> Expired and moved to Config class");
			
			var contentResizedRect:Rectangle = _contentRect.clone();
			contentResizedRect.height+=StageManager.stageDelta.height ;
			contentResizedRect.width+=StageManager.stageDelta.width ;
			trace("StageManager.stageDelta.height : "+StageManager.stageDelta.height);
			trace("_contentRect : "+_contentRect+" vs "+contentResizedRect);
			return contentResizedRect.clone();
		}
		
		/**AutoLanguageConvertion will enabled just when supportsMutilanguage was true,
		 * Pass 1 to activate effects<br>
		 * activateURLCaller makes application be able to open from an URI from out side applications. first time it will throw the required permission */
		public function AppWithContent(supportsMultiLanguage:Boolean=false,autoLanguageConvertEnabled:Boolean=true,animagePageContents:Boolean=false,autoChangeMusics:Boolean=false,skipAllAnimations:Boolean=false,manageStageManager:Boolean=false,loadConfig:Boolean=false,addVersionControll:Boolean=true
		,addTheDeveloperPage:Boolean=false,activateShineEffect:uint=1,PlaySounOnBackGroundTo:Boolean=false,activateRankSystem:Boolean=false,activateURLCaller:Boolean=false,
		activateWorkers:Boolean = true )
		{
			super(autoChangeMusics,skipAllAnimations,activateShineEffect,PlaySounOnBackGroundTo);
			
			if(activateWorkers)
			{
				//setTimeout(startWorker,1000);
				startWorker();
			}
			
			
			activeVersionControll = addVersionControll ;
			
			ME = this ;
			
			if(animagePageContents)
			{
				PageManager.activatePageAnimation();
			}
			
			stopIntro();
			//Multilanguage support added to current version.
			Contents.setUp(startApp,supportsMultiLanguage,autoLanguageConvertEnabled,this.stage,loadConfig);
			
			
			if(DevicePrefrence.isItPC)
				Hints.controlLanguages();
			
			if(manageStageManager)
			{
				trace("Contents.config.debugStageHeight : "+Contents.config.debugStageHeight);
				StageManager.setUp(stage,Contents.config.debugStageWidth,Contents.config.debugStageHeight);
				StageManager.eventDispatcher.addEventListener(StageManagerEvent.STAGE_RESIZED,updateConfigRects);
				updateConfigRects();
				trace("**** : "+StageManager.stageRect);
			}
			//Create the contentPage rectangle by contentW and contentH values on homePage data to use on scrolled pages
			var homePageData:PageData = Contents.homePage ;
			if(isNaN(homePageData.contentW))
			{
				homePageData.contentW = stage.stageWidth ;
			}
			if(isNaN(homePageData.contentH))
			{
				homePageData.contentH = stage.stageHeight ;
			}
			_contentRect = new Rectangle(0,0,homePageData.contentW,homePageData.contentH);
			trace("Content page rectangle is ( You can change this value by adding w and h attributes to the home.content value on data.xml : "+_contentRect);
			
			this.addEventListener(PageControllEvent.PREVENT_PAGE_CHANGING,preventPageChanging);
			this.addEventListener(PageControllEvent.LET_PAGE_CHANGE,letThePreventedAppEventRelease);
			
			if(skipAllAnimations || Contents.config.skipAnimations)
			{
				activeVersionControll = false ;
				skipIntro();
				skipAnimations = true ;
			}
			
			var errorThrower:String = '' ;
			var appDescriptorString:String = String(DevicePrefrence.appDescriptor) ;
				appDescriptorString = StringFunctions.clearSpacesAndTabs(appDescriptorString)
			
			PermissionControl.controlVideoProblem();
					
			if((loadConfig && Contents.config.activateURLCaller) || activateURLCaller)
			{
				URISchemId = DevicePrefrence.appID.substr(DevicePrefrence.appID.lastIndexOf('.')+1).toLowerCase();
				PermissionControl.controlURLShemePermission(URISchemId);
				
				NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, URICalled);
			}
			if(!DevicePrefrence.isAndroid() && appDescriptorString.indexOf("NSAllowsArbitraryLoads")==-1)
			{
				errorThrower += "Add xml below to \"<iPhone><InfoAdditions><![CDATA[... \" make iOS version able to connect the internet:\n\n<key>NSAppTransportSecurity</key>\n<dict>\n\t<key>NSAllowsArbitraryLoads</key><true/>\n</dict>\n\n"
			}
			if(DevicePrefrence.isItPC && appDescriptorString.indexOf("<requestedDisplayResolution>high</requestedDisplayResolution>")==-1)
			{
				errorThrower += "Add below code to the manifest xml in the <iPhone> tag to prevent bad resolution on iPhone:\n\t<requestedDisplayResolution>high</requestedDisplayResolution>\n\n";
			}
			
			if(addTheDeveloperPage)
			{
				try
				{
					new DeveloperPage();
				} 
				catch(error:Error) 
				{
					errorThrower+="You have to add DeveloperPage to your project. create a moveiClip based on contents.displayElements.DeveloperPage and set its interface as you like. "+error ;
				}
			}
			if(activateRankSystem)
			{
				if(PopMenu1.isExists())
				{
					this.addEventListener(AppEvent.APP_STARTS,RankingSystem.start);
				}
				else
				{
					throw "You have to add pop menus to activate auto rank system";
				}
			}
			
			if(loadConfig && PopMenu1.isExists())
			{
				PopMenu.backEnable(Contents.lang.t.back);
				PopMenu.staticCanselEnabled([Contents.lang.t.back]);
			}
			
			if(errorThrower!='')
			{
				throw errorThrower ;
			}
		}
		
		/**Start the worker with delay*/
		private function startWorker():void
		{
			WorkerFunctions.setUp();
		}		
		
		/**The application called with uri shcema*/
		protected function URICalled(event:InvokeEvent):void
		{
			trace("App is oppend from an other application : "+event.arguments);
		}
		
		private function updateConfigRects(e:*=null):void
		{
			Contents.config.stageOrgRect = StageManager.stageOldRect ;
			Contents.config.stageRect = StageManager.stageRect ;
		}		
		
		/**Permition from the pages released*/
		protected function letThePreventedAppEventRelease(event:PageControllEvent):void
		{
			
			preventorFunction = null ;
			preventorPage = null ;
			var preventedEventCash:AppEvent = preventedEvent ;
			preventedEvent = null ;
			if(prventedPageWasLastPage)
			{
				History.lastPage();
			}
			prventedPageWasLastPage = false ;
			
			if(preventedEventCash!=null)
			{
				trace("Prevented page event is released");
				managePages(preventedEventCash);
			}
			else
			{
				trace("No AppEvent was prevented to be release");
			}
		}
		
		/**Preventor set*/
		protected function preventPageChanging(event:PageControllEvent):void
		{
			
			trace("Permition sat");
			preventorFunction = event.permitionReceiver ;
			preventorPage = event.preventerPage ;
		}
		
		
		/**Returns true if App need permition to change its page*/
		private function haveToGetPermition(event:AppEvent):Boolean
		{
			preventedEvent = event ;
			if(permitionRequiredToChangePage())
			{
				trace("The page changing needs a permition");
				if(preventorFunction.length>0)
				{
					preventorFunction(preventedEvent);
				}
				else
				{
					preventorFunction();
				}
				return true ;
			}
			//trace("No permition needed : "+preventorFunction+' , '+preventorPage+' , '+preventorPage.stage)
			preventorFunction = null ;
			preventorPage = null ;
			preventedEvent = null ;
			prventedPageWasLastPage = false ;
			return false ;
		}
		
		/**Returns true if you have to get permition to change the page<br>
		 * PageControllEvent.PREVENT_PAGE_CHANGING can be cause of this */
		public static function permitionRequiredToChangePage():Boolean
		{
			return ME.preventorFunction!=null && ME.preventorPage!=null && ME.preventorPage.stage !=null ;
		}
		
		protected function activateStageManager(debugWidth:Number=0,debugHeight:Number=0,listenToStageRotation:Boolean=true):void
		{
			StageManager.setUp(stage,debugWidth,debugHeight,listenToStageRotation);
		}
		
		override protected function managePages(event:AppEvent):Boolean
		{
			if(haveToGetPermition(event))
			{
				prventedPageWasLastPage = History.undoLastPageHisotry();
				return false;
			}
			
			if(event.myID == AppEvent.developer_static_pageid)
			{
				DevicePrefrence.createDownloadLink();
				trace("Open the developer page");
				if(PopMenu.isAvailable())
				{
					var backButton:String = 'بازگشت';
					if(Contents.lang!=null && Contents.lang.t.back!=null)
					{
						backButton = Contents.lang.t.back ;
					}
					var popText:PopMenuContent = new PopMenuContent('',null,[new PopButtonData(backButton,0)],new DeveloperPage(),null,false,false);
					PopMenu1.popUp('',null,popText);
				}
				return false ;
			}
			SliderManager.hide();
			var duplicatePageController:Boolean = super.managePages(event);
			
			
			if(duplicatePageController && event is AppEventContent)
			{
				var event2:AppEventContent = event as AppEventContent ;
				if(!event2.SkipHistory)
				{
					trace("History changed");
					History.pushHistory((event as AppEventContent).linkData);
				}
			}
			
			return duplicatePageController ;
		}
		
		/**Contents are load now*/
		protected function startApp()
		{
			stage.dispatchEvent(new ContentsEvent());
			playIntro();
			if(!(skipAnimations || Contents.config.skipAnimations) && activeVersionControll)
			{
				var appName:String = DevicePrefrence.appID ;
				appName = appName.substring(appName.lastIndexOf('.')+1);
				var versionContrllURL:String = Contents.config.version_controll_url+''+appName+'.xml' ;
				trace("Version controll : "+versionContrllURL);
				VersionController.controllVersion(currentVersionIsOk,stopThisVersion,new URLRequest(versionContrllURL),DevicePrefrence.appVersion);
			}
		}
		
			/**The application version is ok*/
			private function currentVersionIsOk():void
			{
				trace("*** The versions are ok ***");
			}
		
			/**The application is expired*/
			private function stopThisVersion():void
			{
				if(isExpired(VersionController.hintText,VersionController.appStoreURL))
				{
					trace("Switch to the download url instantly");
					resetIntro();
					stage.addEventListener(MouseEvent.CLICK,openDownloadLink);
					openDownloadLink(null);
				}
			}
		
			/**Open thie update link*/
			protected function openDownloadLink(event:MouseEvent):void
			{
				navigateToURL(new URLRequest(VersionController.appStoreURL));
			}
			
			/**Returns true if there is no listener on this function, so the application have to redirect to the server*/
			protected function isExpired(hint:String,link:String):Boolean
			{
				Alert.show(hint);
				return true ;
			}
	}
}