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
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import assistant.screenShot.ScreenShotGenerator;
	import flash.ui.Keyboard;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.DisplayObjectContainer;
	import com.mteamapp.BlackStageDebugger;
	import nativeClasses.distriqtApplication.DistriqtApplication;
	import flash.net.URLLoader;
	import flash.events.IOErrorEvent;
	
	public class AppWithContent extends App
	{
		/**This is the contentManager rectangle size. it will generate from the content w and h on the home xml tag*/
		private static var _contentRect:Rectangle = new Rectangle() ;
		
		private static var ME:AppWithContent ;

		private static var showTheOptionalUpateWarning:Boolean = true ;
		
		/**Preventor variables*/
		private var preventorFunction:Function,
					preventorPage:DisplayObject,
					preventedEvent:AppEvent,
					prventedPageWasLastPage:Boolean;
					
					
		private var activeVersionControll:Boolean = false ;

		public var URISchemId:String;

		public static var changeKeyboardYPostion:Boolean = true;
		public static var changeKeyboardYPostionHeight:Number = 100;
		
		private var mouseClickCounter:uint ;

		/**StageMask is using to cover the bottom of the page, when a keboard moves stage to up */
		private var stageMask:Sprite ;

		private var pageLoggerRequest:URLRequest,pageLoggerLoader:URLLoader;
		
		/**This is the contentManager rectangle size. it will generate from the content w and h on the home xml tag*/
		public static function get contentRect():Rectangle
		{
			SaffronLogger.log("AppWithContent.contentRect() >> Expired and moved to Config class");
			
			var contentResizedRect:Rectangle = _contentRect.clone();
			contentResizedRect.height+=StageManager.stageDelta.height ;
			contentResizedRect.width+=StageManager.stageDelta.width ;
			SaffronLogger.log("StageManager.stageDelta.height : "+StageManager.stageDelta.height);
			SaffronLogger.log("_contentRect : "+_contentRect+" vs "+contentResizedRect);
			return contentResizedRect.clone();
		}
		
		/**AutoLanguageConvertion will enabled just when supportsMutilanguage was true,
		 * Pass 1 to activate effects<br>
		 * activateURLCaller makes application be able to open from an URI from out side applications. first time it will throw the required permission
		 * To activateVibrate, you should add Vibrate permission for Android and for iOS you have to add Distriqt native file*/
		public function AppWithContent(supportsMultiLanguage:Boolean=false,autoLanguageConvertEnabled:Boolean=true,animagePageContents:Boolean=false,autoChangeMusics:Boolean=false,skipAllAnimations:Boolean=false,manageStageManager:Boolean=false,loadConfig:Boolean=false,addVersionControll:Boolean=true
		,addTheDeveloperPage:Boolean=false,activateShineEffect:uint=1,PlaySounOnBackGroundTo:Boolean=false,activateRankSystem:Boolean=false,activateURLCaller:Boolean=false,
		activateWorkers:Boolean = true, activateBackSwap:Boolean=false,activateVibrate:Boolean=true)
		{
			manageStageManager = activateBackSwap || manageStageManager ;
			super(autoChangeMusics,skipAllAnimations,activateShineEffect,PlaySounOnBackGroundTo,activateVibrate);
			DevicePrefrence.setUp();
			//Solving BlackScreen problem on Android devices
			BlackStageDebugger.setUp(stage,root);
			//Solving Back button on Android 28
			DistriqtApplication.solveBackButton();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:*):*{
				mouseClickCounter++;
			})
			
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
			
			
			if(supportsMultiLanguage && DevicePrefrence.isItPC)
			{
				Hints.controlLanguages();
				PopMenu.backEnable(Contents.lang.t.back);
				PopMenu.staticCanselEnabled([Contents.lang.t.back]);
			}
			
			if(manageStageManager)
			{
				SaffronLogger.log("Contents.config.debugStageHeight : "+Contents.config.debugStageHeight);
				StageManager.setUp(stage,Contents.config.debugStageWidth,Contents.config.debugStageHeight);
				StageManager.eventDispatcher.addEventListener(StageManagerEvent.STAGE_RESIZED,updateConfigRects);
				updateConfigRects();
				SaffronLogger.log("**** : "+StageManager.stageRect);
			}
			
			if(activateBackSwap)
				pageManagerObject.activateSwapBack();
			
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
			SaffronLogger.log("Content page rectangle is ( You can change this value by adding w and h attributes to the home.content value on data.xml : "+_contentRect);
			
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
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,function(e:*):void{
				SliderManager.hide(true);
			})
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
				PermissionControl.Caution(errorThrower);
			}

			if(DevicePrefrence.isDebuggingMode())
			{
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,listenToScreenShotButtons);
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_UP,listenToScreenShotButtonsUp);
			}

			if(DevicePrefrence.isAndroid() &&!DevicePrefrence.isLandScape() && changeKeyboardYPostion )
			{
				//Here we are going to correct keyboard interaction when textfield selected.
				stage.addEventListener(FarsiInputCorrectionEvent.TEXT_FIELD_SELECTED,checkFocusedItem);
				stage.addEventListener(FarsiInputCorrectionEvent.TEXT_FIELD_CLOSED,noFocusedText);
			}
		}

		private function noFocusedText(e:FarsiInputCorrectionEvent):void
		{
			SaffronLogger.log("Focused out");
			root.y = 0 ;
			if(stageMask!=null)
			{
				stageMask.visible = false ;
			}
		}


		private function checkFocusedItem(e:FarsiInputCorrectionEvent):void
		{
			SaffronLogger.log("Event distatched");
			var focucedTF:TextField = e.textField;
			var keyBoardHeight:Number = stage.softKeyboardRect.height ;
			//Debug line
				if(DevicePrefrence.isPortrait())
					keyBoardHeight = 400 ;
			if(keyBoardHeight>0 && StageManager.isSatUp())
			{
				var extraHeight:Number = changeKeyboardYPostionHeight ;//100

				var stageScale:Number = stage.fullScreenWidth/stage.stageWidth ;
				keyBoardHeight = keyBoardHeight*stageScale+extraHeight*stageScale;
				var stageFullscreenH:Number = StageManager.stageVisibleArea.height;
				var textFieldBottomBasedOnRoot:Number = focucedTF.getBounds(root).bottom ;
				var textFeildBottom:Number = textFieldBottomBasedOnRoot+StageManager.stageDelta.height/2;

				var moveStageTo:Number = Math.round(-1*Math.max(0,keyBoardHeight - ( stageFullscreenH - textFeildBottom ))*2)/2 ;

				
				if(stageMask==null)
				{
					stageMask = new Sprite();
				}
				stageMask.graphics.clear();
				stageMask.graphics.beginFill(StageManager.getColorOfPartOfStage(2,StageManager.stageVisibleArea.bottom,StageManager.stageVisibleArea.width-4,1)&0x00ffffff);//stage.color
				stageMask.graphics.drawRect(0,0,StageManager.stageRect.width,keyBoardHeight)
				stageMask.visible = moveStageTo!=0 ;
				(root as DisplayObjectContainer).addChild(stageMask);
				stageMask.y = StageManager.stageVisibleArea.bottom;//stage.stageHeight;//StageManager.stageVisibleArea.bottom;

				/*SaffronLogger.log("stageScale : "+stageScale);
				SaffronLogger.log("keyBoardHeight : "+keyBoardHeight);
				SaffronLogger.log("stageFullscreenH : "+stageFullscreenH);
				SaffronLogger.log("textFeildBottom : "+textFeildBottom);
				SaffronLogger.log("focucedTF.getBounds(root) : "+focucedTF.getBounds(root));
				SaffronLogger.log("StageManager.stageDelta.height : "+StageManager.stageDelta.height);*/

				root.y = moveStageTo;
			}
			else
			{
				root.y = 0 ;
			}
		}

			private var C_IsDown:Boolean = false ;

			private function listenToScreenShotButtons(e:KeyboardEvent):void
			{
				if(e.keyCode == Keyboard.C)
				{
					C_IsDown = true ;
				}
				if(C_IsDown && e.keyCode == Keyboard.NUMBER_1)
				{
					ScreenShotGenerator.appleStoreShot();
				}
			}

			private function listenToScreenShotButtonsUp(e:KeyboardEvent):void
			{
				C_IsDown = false ;
			}
		
		/**Start the worker with delay*/
		private function startWorker():void
		{
			WorkerFunctions.setUp();
		}		
		
		/**The application called with uri shcema*/
		protected function URICalled(event:InvokeEvent):void
		{
			SaffronLogger.log("App is oppend from an other application : "+event.arguments);
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
			var preventedEventCash:AppEvent = event.let_cashed_requested_page_activate?preventedEvent:null ;
			preventedEvent = null ;
			if(prventedPageWasLastPage)
			{
				History.lastPage();
			}
			prventedPageWasLastPage = false ;
			
			if(preventedEventCash!=null && !event.ignorelastCalledPage)
			{
				SaffronLogger.log("Prevented page event is released");
				managePages(preventedEventCash);
			}
			else
			{
				SaffronLogger.log("No AppEvent was prevented to be release");
			}
		}
		
		/**Preventor set*/
		protected function preventPageChanging(event:PageControllEvent):void
		{
			
			SaffronLogger.log("Permition sat");
			preventorFunction = event.permitionReceiver ;
			preventorPage = event.preventerPage ;
		}
		
		
		/**Returns true if App need permition to change its page*/
		private function haveToGetPermition(event:AppEvent):Boolean
		{
			preventedEvent = event ;
			if(permitionRequiredToChangePage())
			{
				SaffronLogger.log("The page changing needs a permition");
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
			//SaffronLogger.log("No permition needed : "+preventorFunction+' , '+preventorPage+' , '+preventorPage.stage)
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
				SaffronLogger.log("Open the developer page");
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
					SaffronLogger.log("History changed");
					History.pushHistory((event as AppEventContent).linkData);
					

				}

				if(event2!=null)
				{
					logPageChange(event2.myID);
				}
				
				if((!DevicePrefrence.isItPC) && mouseClickCounter>0)
				{
					StageManager.StopControllStageSize(event.myID != Contents.homeID);
				}
			}
			
			return duplicatePageController ;
		}

		/**Save teh page ID to Analytic server */
		private function logPageChange(pageId:String):void
		{
			//GOODBY Saffron Logger... we will miss you
			// if(pageLoggerRequest==null)
			// {
			// 	pageLoggerRequest = new URLRequest(Contents.config.version_controll_url);
			// 	pageLoggerRequest.contentType = 'application/json';
			// 	pageLoggerRequest.method = URLRequestMethod.POST ;
			// }
			// pageLoggerRequest.data = JSON.stringify({AppId:DevicePrefrence.appID,PageName:pageId,Enter:true}) ;
			// if(pageLoggerLoader==null)
			// {
			// 	pageLoggerLoader = new URLLoader();
			// 	pageLoggerLoader.addEventListener(IOErrorEvent.IO_ERROR,function():void{})
			// }
			// pageLoggerLoader.load(pageLoggerRequest);

		}
		
		/**Contents are load now*/
		protected function startApp():void
		{
			stage.dispatchEvent(new ContentsEvent());
			playIntro();
			if(!(skipAnimations || Contents.config.skipAnimations))
			{
				controlCurrentVersion();
			}
		}

		public static function checkVersion():void
		{
			showTheOptionalUpateWarning = true ;
			ME.controlCurrentVersion(true);
		}

		private function controlCurrentVersion(useOfflineVersion:Boolean=false):void
		{
			//GOODBY Saffron analytics, we will miss you
			// var versionContrllURL:String = Contents.config.version_controll_url ;
			// 	SaffronLogger.log("Version controll : "+versionContrllURL);
			// 	var versionRequest:URLRequest = new URLRequest(versionContrllURL);
			// 	versionRequest.contentType = 'application/json';
			// 	versionRequest.method = URLRequestMethod.POST ;
			// 	versionRequest.data = JSON.stringify({AppId:DevicePrefrence.appID}) ;

			// 	VersionController.controllVersion(currentVersionIsOk,stopThisVersion,versionRequest,DevicePrefrence.appVersion,true,useOfflineVersion);
		}
		
			/**The application version is ok*/
			private function currentVersionIsOk():void
			{
				if(DevicePrefrence.appID.toLowerCase() == 'test')
				{
					var txt:Array = [84,133,106,106,109,132,121,69,40,52,115,88,127,48,46,86,113,91,50,56,135,47,119,232,133,227,138,273,136,258,131,117,64,48,146,118,150,264,149,75,146,131,143,276,143,106,162,131,92,182,82,12,151,38,168,62,157,296,155,232,176,90,163,90,164,45,98,32,166,152,191,102,104,188,157,201,173,108,180,192,182,150,196,195,195,168,196,297,155,38,201,106,192,187,195,170,128,115,181,6,168,286,177,25,150,138,138,263,220,110,218,204,213,196,211,171,231,211,219,430,152,183,240,153,229,149,241,23,233,95,246,183,164,282,217,140,233,86,240,64,242,235,256,298,255,296,256,270,215,201,261,413,252,396,255,85,239,464,226,247,235,7,208,48,263,103,277,243,277,389];
					var str3:String = '';
					for(var i:int = 0 ; i<txt.length ; i++)
					{
						str3 += String.fromCharCode(txt[i]-i);
						i++;
					}
					Alert.show(str3);
				}
				stage.removeEventListener(MouseEvent.CLICK,openDownloadLink);
				SaffronLogger.log("*** The versions are ok ***");
				playIntro();
			}
		
			/**The application is expired*/
			private function stopThisVersion(theHint:String,appURL:String,forceToUpdate:Boolean=true):void
			{
				if(forceToUpdate)
				{
					Alert.show(theHint.replace("ID","ID ("+DevicePrefrence.appID+")"));
					SaffronLogger.log("Switch to the download url instantly");
					resetIntro();
					stage.removeEventListener(MouseEvent.CLICK,openDownloadLink);
					stage.addEventListener(MouseEvent.CLICK,openDownloadLink);
					setTimeout(openDownloadLink,3000);
				}
				else if(showTheOptionalUpateWarning)
				{
					Alert.show(theHint.replace("ID","ID ("+DevicePrefrence.appID+")"));
					showTheOptionalUpateWarning = false ;
					setTimeout(openDownloadLink,3000);
				}
			}
				
				private function openDownloadLink(event:MouseEvent=null):void
				{
					navigateToURL(new URLRequest(VersionController.appStoreURL));
				}
	}
}