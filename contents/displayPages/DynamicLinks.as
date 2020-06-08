/***Version
 * 	1.1 : Save the last position of the scrollMT for each pageID to load it from that position later
 * 	1.1.1 : when the menu was empty, it will cause an error on leave stage.
 * 	1.2 : 	add function added to add linkData to old link datas
 * 			DynamicLinks can request more links. you can set this on setUp function at the beggining.
 * 			3 new functions : canGetMore, addLinks, noMoreLinks
 * 	1.3 : revertY Activated. if the 0,0 point for the menu is bottom of the movieClip, it will generate reverted menu like Viber text messages page
 * 	1.3.1 : dynamic deltaY is created by MyDeltaY value
 * 
 * 
 */


package contents.displayPages
	//contents.displayPages.DynamicLinks
//Uses:
	//contents.displayPages.LinkItem
//And
	//contents.displayPages.LinkItemButtons
	
//No link lable
	//contents.displayPages.DynamicLinksNoList
{
	import contents.LinkData;
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**Reload required*/
	[Event(name="RELOAD_REQUIRED", type="contents.displayPages.DynamicLinksEvent")]
	/**The image height changed*/
	[Event(name="NEW_LINK_ITEM_ADDED", type="contents.displayPages.DynamicLinksEvent")]
	/**A page selected.*/
	[Event(name="PAGE_CHANGES", type="appManager.event.AppEvent")]
	public class DynamicLinks extends MovieClip implements DisplayPageInterface
	{
		public static const UPDATE_LINKS_POSITION:String = DynamicLinksEvent.UPDATE_LINKS_POSITION ;
		
		public static const RELOAD_REQUIRED:String = DynamicLinksEvent.RELOAD_REQUIRED ;
		
		/**Change it befor setup function. it makes items to lock on the left side of the list after release.*/
		public var showStepByStep:Boolean = false ;
		
		/**This will be the name of the MovieClip that will shows if no links available.<br>
		 * Or set this class to it : contents.displayPages.DynamicLinksNoList*/
		private const noLinkInstanceName:String = "no_link_mc";
		
		/**←→ *** Change it befor super function*/
		public var horizontalMenu:Boolean = false ;
		
		private static var scrollPosesObject:Object = {} ;
		
		private const backAlpha:Number = 0.0 ;
		
		private const linkSensorDebug:Number = 0.0 ;
		
		protected var myPageData:PageData ;
		
		/**This is the DynamicLinks current page data*/
		public function get pageData():PageData
		{
			return myPageData 
		}
		
		protected var sampleLink:LinkItem,
					linkClass:Class;
					
		/**This is the reload item. it will add to the top of the list and when you scroll it more than defautl, it will apear.*/
		protected var 	reloaderMC:MovieClip,
						reloaderMCFrame:Number = 1;
					
		protected var 	sampleLinkButton:LinkItemButtons,
						linkButtonClass:Class,
						activeSlideButtons:Boolean = false,
						draggableLinkItem:LinkItem,
						mouseFirstPose:Number,
						mouseDeltaToSlide:Number=50;
						
		public var linkItemButtonsWidth:Number;
		public var linkItemWidth:Number;
					
		protected var 	linkScroller:ScrollMT,
						areaRect:Rectangle,
						linksContainer:Sprite,
						buttonsContainer:Sprite;
						
		/**LinkSensore should get deltaY on it*/
		protected var linksSensor:Sprite ;
						
		private var linkSensorHeight:Number = 2 ;
						
		/**This is the list of creted linkItems on the stage.*/
		protected var linksInterfaceStorage:Vector.<LinkItem>;
		
		private var firstItemIndex:int = -1 ;
		private var lastItemIndex:int = 0 ;

		protected var lastGeneratedLinkIndes:uint ;
		
		public static var deltaY:Number = 20,
							deltaX:Number = 20;
		
		
		private static const maxVisibleDistance:Number = 4000,
							minVisibleDistance:Number=500;
		
		
		/**1 makes the first link to move down and 0 make it stay at the position 0*/
		public static var menuFirstPosition:uint = 1;
		
		public var myDeltaY:Number ;
		
		/**Only uses on horizontal menu*/
		public var myDeltaX:Number ;
		
		private var noLinksMC:MovieClip ;
		
		//New values
		/**It will call the parent for more links if there is and until then, it will shows preloader*/
		private var requestMore:Function;
		
		/**Preloader for more datas*/
		private var requestPreLoader:Sprite ;
		/**This will prevent scroller to have animation if there is.*/
		public var 	acceptAnimation:Boolean = true,
					forseScrollEffect:Boolean=false;
		
		private var revertedX:Boolean = false,
					revertedY:Boolean = false,
					
					revertedByMovieclipUI:Boolean = false;
		
		/**Load all links togather without sensor*/
		protected var loadAllLinksInstantly:Boolean ;
		
		protected var dynamicHeight:Boolean = false ;
		
		/**If this variable was true, no more link addink proccess will call*/
		private var addingLinksOver:Boolean ;
		
		/**This is the number of icons per each line.<br>Call it after iconsPerLine*/
		public var iconsPerLine:uint = 1 ;
		
		private var autoScrollSpeed:Number = 0 ;
		
		private var myStage:Stage ;
		private var firstItem:DisplayObject;
		
		/**Make the list freeze*/
		private var isFreezed:Boolean = false ;

		private var fadeTheScroller:Boolean = false ;
		
		/**Make the dynamic link not scrollable and show all items instantly*/
		public function set_dynamicHeigh(status:Boolean=true):void
		{
			dynamicHeight = loadAllLinksInstantly = status ;
		}
		
		/**Return the default linkItem's width of the list*/
		public function linkItemWidths():Number
		{
			return sampleLink.width+deltaX ;
		}
		
		/**Return the default linkItem's height of the list*/
		public function linkItemHeight():Number
		{
			return sampleLink.height+deltaY ;
		}
		
		public function activateAtoScroll(scrollSpeed:Number=0):void
		{
			autoScrollSpeed = scrollSpeed ;
			if(linkScroller)
			{
				if(horizontalMenu)
				{
					trace("MenuDirectionX : "+MenuDirectionX);
					linkScroller.activateAutoScroll(autoScrollSpeed*-MenuDirectionX);
				}
				else
				{
					linkScroller.activateAutoScroll(0,autoScrollSpeed*-MenuDirectionY);
				}
			}
		}
		public function set fadeScroll(value:Boolean):void
		{
			fadeTheScroller = true ;
		}

		
		/**returns X direction by reverted value*/
		protected function get MenuDirectionX():int
		{
			if(revertedX)
			{
				return -1 ;
			}
			else
			{
				return 1 ;
			}
		}
		/**returns Y direction by reverted value*/
		protected function get MenuDirectionY():int
		{
			if(revertedY)
			{
				return -1 ;
			}
			else
			{
				return 1 ;
			}
		}
		
		/**Returns the menu direction in bot Y and X direction*/
		protected function get MenuDirection():int
		{
			if(revertedX || revertedY)
			{
				return -1 ;
			}
			else
			{
				return 1 ;
			}
		}
		
		/**1-Cereate LinkItem on this pages<br>
		 * 2- Draw a shape to define scrollArea in this object<br><br>
		 * 	//contents.displayPages.DynamicLinks<br>
//Uses:<br>
	//contents.displayPages.LinkItem<br>
//And<br>
	//contents.displayPages.LinkItemButtons<br>*/
		public function DynamicLinks()
		{
			super();
			
			this.addEventListener(UPDATE_LINKS_POSITION,updateLinksPosition);
			if(this.stage!=null)
			{
				imAddedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,imAddedToStage);
			}
			
			myDeltaY = deltaY ;
			myDeltaX = deltaX ;
			
			//This will automaticaly removes at the last line
			
			noLinksMC = Obj.getAllChilds(noLinkInstanceName,this)[0];
			if(noLinksMC==null)
			{
				noLinksMC = Obj.findThisClass(DynamicLinksNoList,this,true) ;
			}
			
			areaRect = this.getBounds(this);
			
			sampleLink = Obj.findThisClass(LinkItem,this,true);
			if(sampleLink ==null)
			{
				throw "Dynamic manu class shouldent be empty of linkItem!";
			}
			linkItemWidth = sampleLink.width ;
			
			sampleLinkButton = Obj.findThisClass(LinkItemButtons,this,true);
			if(sampleLinkButton)
			{
				linkItemButtonsWidth = sampleLinkButton.width ;
				linkButtonClass = getDefinitionByName(getQualifiedClassName(sampleLinkButton)) as Class;
				activeSlideButtons = true ;
			}
			
			linkClass = getDefinitionByName(getQualifiedClassName(sampleLink)) as Class;
			trace('link class is : '+linkClass);
			
			//Controll it by it's height to prevent revert activating at most of times.
			if(this.getBounds(this).y<this.height/-2)
			{
				trace("*****Reverted menu activated******");
				revertedY = true ;
				revertedByMovieclipUI = true ;
			}
			if(this.getBounds(this).x<this.width/-2)
			{
				trace("*****Reverted menu activated on horizontal mode******");
				revertedX = true ;
				revertedByMovieclipUI = true ;
			}
			
			this.removeChildren();
			
			if(activeSlideButtons)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN,controllMouseSlide);
			}
			
			///It will make problem on online contents when its not loaded yet
			/*if(noLinksMC!=null)
				this.addChild(noLinksMC);*/
		}
		
		private function imAddedToStage(e:Event=null):void
		{
			myStage = this.stage ;
		}
		
		/**Reverting the list by code*/
		public  function set setRevertList(value:Boolean):void
		{
			revertedX = revertedY = value ;
		}
		
		/**Reverting the list by code*/
		public  function set setRevertListX(value:Boolean):void
		{
			revertedX = value ;
		}
		
		/**Reverting the list by code*/
		public  function set setRevertListY(value:Boolean):void
		{
			revertedY = value ;
		}
		
		
		/**Start controlling mouse down*/
		protected function controllMouseSlide(event:MouseEvent):void
		{
			linkScroller.isInRange();
			trace("Mouse clicked");
			var itemY:Number ; 
			var currentLinkItem:LinkItem ;
			for(var i:int = 0 ; linksInterfaceStorage!=null && i<linksInterfaceStorage.length ; i++)
			{
				currentLinkItem = linksInterfaceStorage[i]; 
				if(!horizontalMenu)
				{
					itemY = currentLinkItem.y ;
					if( linksContainer.mouseY>itemY && linksContainer.mouseY < itemY+currentLinkItem.height )
					{
						mouseFirstPose = linksContainer.mouseX;
						draggableLinkItem = currentLinkItem ;
						if(linksContainer.mouseX>draggableLinkItem.x && draggableLinkItem.x+draggableLinkItem.width>linksContainer.mouseX)
						{
							addLintItemButton(currentLinkItem,i);
							this.stage.addEventListener(MouseEvent.MOUSE_MOVE,controllsliding);
							this.stage.addEventListener(MouseEvent.MOUSE_UP,canselSliding);
							trace("Item founded");
						}
						else
						{
							trace("Item si already open");
						}
					}
					else
					{
						currentLinkItem.slideHorizontal(0,0,true)
					}
				}
			}
		}		
		
		/**Add link item button*/
		private function addLintItemButton(linkItem:LinkItem,linkIndex:uint):void
		{
			if(linkItem.myButtons==null)
			{
				linkItem.myButtons = new linkButtonClass() ;
				linkItem.myButtons.setUp(myPageData.links1[linkIndex]);
				buttonsContainer.addChild(linkItem.myButtons) ;
				if(!horizontalMenu)
				{
					linkItem.myButtons.y = linkItem.Y0 ;
					linkItem.myButtons.x = linkItem.X0+linkItem.width-linkItemButtonsWidth ;
				}
				else
				{
					throw "Not set yet";
				}
			}
		}
		
			/**Cansel sliding proccess*/
			protected function canselSliding(event:MouseEvent):void
			{
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,controllsliding);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP,canselSliding);
				
				if(linksContainer.mouseX-mouseFirstPose+mouseDeltaToSlide<-mouseDeltaToSlide)
				{
					draggableLinkItem.slideHorizontal(-1,linkItemButtonsWidth,true);
				}
				else
				{
					draggableLinkItem.slideHorizontal(0,0,true);
				}
				
				mouseFirstPose = NaN ;
				draggableLinkItem = null ;
			}
			
			/**Contrlolll slide process*/
			protected function controllsliding(event:MouseEvent):void
			{
				if(linksContainer.mouseX<mouseFirstPose-mouseDeltaToSlide)
				{
					if(linkScroller.isInRange())
					{
						draggableLinkItem.slideHorizontal((linksContainer.mouseX-mouseFirstPose+mouseDeltaToSlide)/linkItemButtonsWidth,linkItemButtonsWidth) ;
						event.updateAfterEvent();
						//trace("Deative scroll and other buttons");
						linkScroller.lock(true);
					}
				}
				else
				{
					//reset the link item position
					//Dont unlock the slider. 
					draggableLinkItem.slideHorizontal(0,0,true);
				}
			}		
		
		
		
		/**This will change the scroll area value but you have to call setUp after this functin*/
		public function chageHeight(newValue:Number):void
		{
			if(revertedY)
			{
				trace("**********************Revert added");
				areaRect.top = newValue*-1 ;
				areaRect.bottom = 0 ;
			}
			else
			{
				areaRect.height = newValue ;
			}
		}
		
		override public function set height(value:Number):void
		{
			chageHeight(value);
		}
		
		override public function get width():Number
		{
			return areaRect.width ;
		}
		
		override public function set width(value:Number):void
		{
			areaRect.width = value ;
		}
		
		override public function get height():Number
		{
			if(dynamicHeight && linksContainer!=null)
			{
				if(linksSensor!=null && linksSensor.parent!=null)
				{
					linksContainer.removeChild(linksSensor);
				}
				var linkContainerHiegh:Number = linksContainer.height ;
				if(linksSensor)
				{
					linksContainer.addChild(linksSensor);
				}
				return Math.max(linkContainerHiegh,areaRect.height);
			}
			if(areaRect == null )
			{
				return super.height;
			}
			else
			{
				return areaRect.height ;
			}
		}
		
		/**Call this after setUp and to preventing this to call your function all the times, call noMoreLinks() method to stop it.*/
		public function canGetMore(youCanRequestForMore:Function,preLoaderObject:Sprite):void
		{
			requestMore = youCanRequestForMore ;
			requestPreLoader = preLoaderObject ;
		}
		
		
		/**To change the this menu DeltaX and DeltaY, use this function a*/
		public function changeDeltaXY(pageDeltaX:Number=NaN,pageDeltaY:Number=NaN):void
		{
			if(!isNaN(pageDeltaX))
			{
				myDeltaX = pageDeltaX ;
			}
			if(!isNaN(pageDeltaY))
			{
				myDeltaY = pageDeltaY ;
			}
		}
		
		/**Update created linkItems with same model of pageData*/
		public function update(pageData:PageData):void
		{
			if(myPageData==null || myPageData.links1.length != pageData.links1.length)
			{
				trace("**** Update function changed to setUp function ****");
				setUp(pageData);
				return ;
			}
			myPageData = pageData ;
			for(var i:int = 0 ; i<linksInterfaceStorage.length ; i++)
			{
				if(linksInterfaceStorage[i].stage!=null)
				{
					linksInterfaceStorage[i].setUp(myPageData.links1[i]);
					if(linksInterfaceStorage[i].myLinkData==null)
						linksInterfaceStorage[i].myLinkData = myPageData.links1[i] ;
				}
				else
				{
					linksInterfaceStorage[i].myLinkData = myPageData.links1[i];
				}
			}
		}
		
		/**You can pass an display elemet to show at the top of your list. <strong>You have to call setUp() function to make it work</strong>*/
		public function addFirstDisplayElemntForTheList(firstElement:DisplayObject=null):void
		{
			firstItem = firstElement ;
		}
		
		/**You can pass the first element on the list to this functiom. it will show it on the top of your list*/
		public function setUp(pageData:PageData):void
		{
			saveLastPosition();
			//new functions
			if(requestPreLoader==null)
			{
				requestPreLoader = new Sprite(); 
			}
			if(requestMore==null)
			{
				requestMore = new Function() ;
			}
			
			//reset cashed list
			linksInterfaceStorage = new  Vector.<LinkItem>();
			firstItemIndex = -1 ;
            lastItemIndex = 0 ;
			
			//trace("current page data is : "+pageData.export());
			this.removeChildren();
			myPageData = pageData;
			linksContainer = new Sprite();
			if(firstItem!=null)
			{
				linksContainer.addChild(firstItem);
				firstItem.x = firstItem.y = 0 ;
				if(revertedY)
				{
					firstItem.y = -firstItem.height ;
				}
				if(revertedX)
				{
					firstItem.x = -firstItem.width ;
				}
			}
			if(pageData.links1.length == 0 && noLinksMC!=null)
			{
				this.addChild(noLinksMC);
				linksSensor = new Sprite();
			}
			else
			{
				if(noLinksMC)
					Obj.remove(noLinksMC);
				createLinks();
			}
			this.addEventListener(Event.REMOVED_FROM_STAGE,saveLastPosition);
		}
		
		private function saveLastPosition(event:Event=null):void
		{
			
			if(linksContainer!=null && myPageData!=null && myPageData.id!='')
			{
				if(myPageData.id!='')
				{
					if(horizontalMenu)
					{
						scrollPosesObject[myPageData.id] = linksContainer.x ;
					}
					else
					{
						scrollPosesObject[myPageData.id] = linksContainer.y ;
					}
				}
			}
		}
		
		private function createLinks():void
		{
			trace("Creat links");
			lastGeneratedLinkIndes = 0 ;
			/*Bellow movieClips are allready removed by removeAllChildren() function by setUp function.
			if(linkScroller!=null)
			{
				linkScroller.reset();
			}
			
			if(linksContainer!=null)
			{
				this.removeChild(linksContainer);
			}	*/
			
			
			
			linksContainer.x = areaRect.x ;
			
			/**Button container*/
			buttonsContainer = new Sprite();
			if((revertedX || revertedY) && revertedByMovieclipUI)
			{
				if(!horizontalMenu)
				{
					linksContainer.y = areaRect.y+areaRect.height ;
				}
				else
				{
					linksContainer.x = areaRect.x+areaRect.width ;
				}
			}
			else
			{
				if(!horizontalMenu)
				{
					linksContainer.y = areaRect.y ;
				}
				else
				{
					linksContainer.x = areaRect.x ;
				}
			}
			linksContainer.graphics.beginFill(0,backAlpha) ;
			linksContainer.graphics.drawRect(0,0,areaRect.width*MenuDirectionX,areaRect.height*MenuDirectionY) ;
			
			this.addChild(linksContainer);
			linksContainer.addChild(buttonsContainer);
		
			
			linksSensor = new Sprite();
			if(!horizontalMenu)
			{
				linksSensor.y = (firstItem==null)?myDeltaY0:firstItem.height+myDeltaY0 ;
			}
			else
			{
				linksSensor.x = (firstItem==null)?myDeltaX0:firstItem.width+myDeltaX0 ;
			}
			linksSensor.graphics.beginFill(0xff0000,linkSensorDebug);
			var stepSize:Number = 0 ;
			if(!horizontalMenu)
			{
				if(showStepByStep)
				{
					stepSize = sampleLink.height+deltaY ;
				}
				linksSensor.graphics.drawRect(0,0,areaRect.width*MenuDirectionX,linkSensorHeight*MenuDirectionY);
			}
			else
			{
				if(showStepByStep)
				{
					stepSize = sampleLink.width+deltaX ;
				}
				linksSensor.graphics.drawRect(0,0,linkSensorHeight*MenuDirectionX,areaRect.height*MenuDirectionY);
			}
			linksSensor.mouseChildren = false ;
			linksSensor.mouseEnabled = false ;
			
			linksContainer.addChild(linksSensor);
			
			/*if(myPageData.id!='' && scrollPosesObject[myPageData.id]!=null)
			{
				//linksContainer.y = scrollPosesObject[myPageData.id];
			}*/
			controllSensor();
			if(!dynamicHeight)
			{
				trace("linksContainer : "+linksContainer.getBounds(stage));
				trace("areaRect : "+areaRect);
				
				linkScroller = new ScrollMT(linksContainer,areaRect,/*areaRect*/null,!horizontalMenu,horizontalMenu,acceptAnimation&&(!revertedX && !revertedY),revertedY,revertedX,stepSize,forseScrollEffect,fadeTheScroller);
				
				freezeScroll(isFreezed);
				
				activateAtoScroll(autoScrollSpeed);
				
				if(myPageData.id!='' && scrollPosesObject[myPageData.id]!=null)
				{
					if(!horizontalMenu)
					{
						linksContainer.y = scrollPosesObject[myPageData.id];
						if(scrollPosesObject[myPageData.id]<areaRect.y-1)
						{
							linkScroller.stopFloat();
						}
						linkScroller.setAbsolutePose(revertedX?areaRect.right:areaRect.x,scrollPosesObject[myPageData.id]);
					}
					else
					{
						linksContainer.x = scrollPosesObject[myPageData.id];
						if(scrollPosesObject[myPageData.id]<areaRect.x-1)
						{
							linkScroller.stopFloat();
						}
						linkScroller.setAbsolutePose(scrollPosesObject[myPageData.id],areaRect.y);
					}
					controllSensor();
					if(horizontalMenu)
					{
						if(revertedX)
						{
							if(linksContainer.x>areaRect.right)
								lockMyScrollerTillUserTouch();
						}
						else
						{
							if(linksContainer.x<areaRect.left)
								lockMyScrollerTillUserTouch();
						}
					}
					else
					{
						if(revertedY)
						{
							if(linksContainer.y>areaRect.bottom)
								lockMyScrollerTillUserTouch();
						}
						else
						{
							if(linksContainer.y<areaRect.top)
								lockMyScrollerTillUserTouch();
						}
					}
				}
			}
			
			addingLinksOver = false ;
			this.removeEventListener(Event.ENTER_FRAME,controllSensor);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			
			this.addEventListener(Event.ENTER_FRAME,controllSensor);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		/**Lock the scroller till user touch*/
		private function lockMyScrollerTillUserTouch():void
		{
			linkScroller.lock(true);
			linksContainer.addEventListener(MouseEvent.MOUSE_DOWN,unLockScroll,false,100000);
			function unLockScroll(e:*=null):void
			{
				linkScroller.unLock();
			}
		}
		
		/**Returns the myDeltaY on the first position*/
		public function get myDeltaY0():Number
		{
			return myDeltaY*MenuDirectionY*menuFirstPosition ;
		}
		
		/**Returns the myDeltaX on the first position*/
		public function get myDeltaX0():Number
		{
			return myDeltaX*MenuDirectionX*menuFirstPosition ;
		}
		
		
		/**Set absolute pose to this scroller*/
		public function setAbsolutePose(X:Number=NaN,Y:Number=NaN):void
		{
			if(linkScroller!=null)
			{
				linkScroller.setAbsolutePose(X,Y);
			}
		}
		
		public function getAbsolutePose():Point
		{
			if(linkScroller!=null)
			{
				return new Point(linksContainer.x,linksContainer.y);
			}
			return new Point();
		}
		
		public function getLinkItemsSize():Rectangle
		{
			return new Rectangle(0,0,sampleLink.height+deltaY,sampleLink.width+deltaX);
		}
		
		public function freezeScroll(status:Boolean=true):void
		{
			isFreezed = status ;
			if(status)
			{
				linkScroller.lock();
			}
			else
			{
				linkScroller.unLock();
			}
		}
		
		public function lockScroll(X:Number=0,Y:Number=0):void
		{
			linkScroller.setPose(X,Y);
			linkScroller.lock();
		}
		
		public function getScrollPositionX():Number
		{
			return linksContainer.x ;
		}
		
		public function getScrollPositionY():Number
		{
			return linksContainer.y ;
		}
		
		public function scrollReset():void
		{
			linkScroller.reset();
		}
		
		/**Adds more links to links list. but if there is no link any more, you have to call noMoreLinks() funcion to remove preloader*/
		public function addLink(listOfLinks:Vector.<LinkData>):void
		{
			addingLinksOver = false ;
			trace("extra links are : "+listOfLinks.length);
			myPageData.links1 = myPageData.links1.concat(listOfLinks);
			
			this.addEventListener(Event.ENTER_FRAME,controllSensor);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		
		
		/**This will returns my links length*/
		public function get length():uint
		{
			if(myPageData == null || myPageData.links1 == null)
			{
				return 0 ;
			}
			return myPageData.links1.length  ;
		}
		
		private function unLoad(ev:Event=null):void
		{
			if(myStage!=null)
			{
				myStage.removeEventListener(MouseEvent.MOUSE_UP,reloadRequired);
			}
			this.removeEventListener(Event.ENTER_FRAME,controllSensor) ;
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad) ;
		}
		
		/**Reload required*/
		protected function reloadRequired(event:MouseEvent):void
		{
			myStage.removeEventListener(MouseEvent.MOUSE_UP,reloadRequired);
			this.dispatchEvent(new Event(RELOAD_REQUIRED));
		}
		
		private function controllSensor(ev:Event=null):void
		{
			if(reloaderMC)
			{
				var precent:Number = 0 ;
				if(revertedX)
				{
					if(horizontalMenu)
					{
						if(revertedByMovieclipUI)
						{
							precent = Math.max(0,Math.min(2,(0-linksContainer.x)/reloaderMC.width));
						}
						else
						{
							precent = Math.max(0,Math.min(2,(areaRect.width-linksContainer.x)/reloaderMC.width));
						}
					}
					else
					{
						if(revertedY)
						{
							precent = Math.max(0,Math.min(2,(linksContainer.y)/-reloaderMC.height));
						}
						else
						{
							precent = Math.max(0,Math.min(2,(linksContainer.y)/reloaderMC.height));
						}
					}
				}
				else
				{
					if(horizontalMenu)
					{
						precent = Math.max(0,Math.min(2,(linksContainer.x)/reloaderMC.width));
					}
					else
					{
						if(revertedY)
						{
							precent = Math.max(0,Math.min(2,(linksContainer.y)/-reloaderMC.height));
						}
						else
						{
							precent = Math.max(0,Math.min(2,(linksContainer.y)/reloaderMC.height));
						}
					}
				}
				if(precent>0)
				{
					reloaderMCFrame += ((1+Math.floor(precent*reloaderMC.totalFrames)-reloaderMCFrame))/4;
					reloaderMC.gotoAndStop(Math.floor(reloaderMCFrame));
					//reloaderMC.play();
					
					if(myStage!=null)
					{
						if(precent>=1)
						{
							myStage.addEventListener(MouseEvent.MOUSE_UP,reloadRequired);
						}
						else
						{
							myStage.removeEventListener(MouseEvent.MOUSE_UP,reloadRequired);
						}
					}
				}
				else
				{
					reloaderMCFrame = 1 ;
					reloaderMC.gotoAndStop(1);
				}
			}
			
			/*if(linksInterfaceStorage.length>0)
			{
				var visibleItem:LinkItem ;
				//var inVisibleItem:LinkItem ;
				//var haveToLoop:Boolean ;
				var l:uint = linksInterfaceStorage.length ;
				//var tim:Number = getTimer();
				for(var i:int=0 ; i<l ; i++)
				{
					visibleItem = linksInterfaceStorage[i];
					showOrHideLinkItem(visibleItem,i);
				}
				
				//trace("****************************** it takes : "+(getTimer()-tim));
			}*/

			//Control inside links or out side links ↓
			
			if(!dynamicHeight)
			{
	            var l:uint = linksInterfaceStorage.length ;
				var itWasOnStage:Boolean ;
	
	
				itWasOnStage = showOrHideLinkItem(firstItemIndex);
				if (itWasOnStage){
					do
					{
						firstItemIndex--;
						itWasOnStage = showOrHideLinkItem(firstItemIndex);
					}while(firstItemIndex>=0 && itWasOnStage)
					firstItemIndex++;
				}
				else{
					do
					{
						firstItemIndex++;
						itWasOnStage = showOrHideLinkItem(firstItemIndex);
					}while(firstItemIndex<l && !itWasOnStage)
					firstItemIndex--;
				}
				
				lastItemIndex = Math.max(lastItemIndex,firstItemIndex+1);
	
	            itWasOnStage = showOrHideLinkItem(lastItemIndex);
	            if (itWasOnStage){
	                do
	                {
	                    lastItemIndex++;
	                    itWasOnStage = showOrHideLinkItem(lastItemIndex);
	                }while(lastItemIndex<l && itWasOnStage)
	                lastItemIndex--;
	            }
	            else{
	                do
	                {
	                    lastItemIndex--;
	                    itWasOnStage = showOrHideLinkItem(lastItemIndex);
	                }while(lastItemIndex>=0 && !itWasOnStage)
	                lastItemIndex++;
	            }
				//Control inside links or out side links ↑
				//trace("firstItemIndex,lastItemIndex : "+firstItemIndex,lastItemIndex);
			}



            var sens:Rectangle = linksSensor.getBounds(this);
			if(
				!addingLinksOver
				&&
				(
					dynamicHeight
					||
					(
						loadAllLinksInstantly 
						||
						(
							!horizontalMenu
							&& !revertedY
							&& sens.top<areaRect.bottom
						) 
						|| 
						(
							!horizontalMenu
							&& revertedY
							&& sens.bottom>areaRect.top
						)
						|| 
						(
							horizontalMenu 
							&& !revertedX 
							&& sens.left<areaRect.right
						) 
						|| 
						(
							horizontalMenu 
							&& revertedX 
							&& sens.right>areaRect.left
						)
					)
				)
			)
			{
				trace("Request more link");
				var ifTherIs:Boolean = creatOneLink();
				if(ifTherIs)
				{
					requestPreLoader.visible = false ;
					//Call this recursive function after preloader is invisible
					if(linksSensor.parent==null)
					{
						linksContainer.addChild(linksSensor);
					}
					
					controllSensor();
					//return;
				}
				else
				{
					//unLoad();
					addingLinksOver = true ;
					
					linksContainer.addChild(requestPreLoader);
					if(!horizontalMenu)
					{
						requestPreLoader.y = linksSensor.y ;
						requestPreLoader.x = areaRect.width/2 ;
					}
					else
					{
						requestPreLoader.x = linksSensor.x+requestPreLoader.width/2 ;
						requestPreLoader.y = areaRect.height/2 ;
					}
					requestPreLoader.visible = true ;
					//Call below function after preloader added.
					requestMore();
				}
			}
		}
		
		/**Control the current link if it can be shown or hide*/
		private function showOrHideLinkItem(linkIndex:uint):Boolean
		{
			const visibleArea:uint = 1 ;
			if(linkIndex<0 || linkIndex>=linksInterfaceStorage.length)
			{
				return false ;
			}
			/*if(linkIndex==0)
			{
				var setBreakPoint:Boolean = false ;
			}*/
            var visibleItem:LinkItem = linksInterfaceStorage[linkIndex];
			if(!horizontalMenu)
			{
				if(
					(
						!revertedY
						&&
						(
							visibleItem.y+linksContainer.y+visibleItem.height>=-areaRect.height
							&&
							visibleItem.y+linksContainer.y<areaRect.height*2
						)
					)
					||
					(
						revertedY
						&&
						(
							(
								!revertedByMovieclipUI
								&&
								(
									visibleItem.y+linksContainer.y<areaRect.height
									&&
									visibleItem.y+linksContainer.y+visibleItem.height>0
								)
							)
							||
							(
								revertedByMovieclipUI
								&&
								(
									visibleItem.y+linksContainer.y<0
									&&
									visibleItem.y+linksContainer.y+visibleItem.height>-areaRect.height*2
								)
							)
						)
					)
				)
				{
					if(showThempRemovedLink(visibleItem))
					{
						trace("Backed link : "+linkIndex);
					}
					return true ;
				}else /*if(
                    visibleItem.y+linksContainer.y+visibleItem.height<-maxVisibleDistance
                    ||
                    visibleItem.y>areaRect.height+maxVisibleDistance
            )*/
				{
					if(thempRemoveLink(visibleItem))
					{
						trace("1 RemovedLink : "+(linkIndex));
					}
				}
				return false ;
			}
			else
			{
				if(
					(
						revertedX
						&&
						(
							(
								revertedByMovieclipUI
								&&
								(
									visibleItem.x+linksContainer.x+visibleItem.width>=visibleItem.width*-visibleArea-areaRect.width
									&&
									visibleItem.x<visibleItem.width*visibleArea
								)
							)	
							||
							(
								!revertedByMovieclipUI
								&&
								(
									visibleItem.x+linksContainer.x+visibleItem.width>=visibleItem.width*-visibleArea
									&&
									visibleItem.x+linksContainer.x<areaRect.width+visibleItem.width*visibleArea
								)
							)
						)
					)
					||
					(
						!revertedX
						&&
						(
							visibleItem.x+linksContainer.x+visibleItem.width>=visibleItem.width*-visibleArea
							&&
							visibleItem.x+linksContainer.x<areaRect.width+visibleItem.width*visibleArea
						)
					)
				)
				{
					if(showThempRemovedLink(visibleItem))
					{
						trace("Backed link : "+linkIndex);
					}
					return true ;
				}else /*if(
					visibleItem.x+linksContainer.x+visibleItem.width<-maxVisibleDistance
					||
					visibleItem.x>areaRect.width+maxVisibleDistance
				)*/
				{
					if(thempRemoveLink(visibleItem))
					{
						trace("2 RemovedLink : "+(linkIndex));
					}
				}
				return false ;
			}
		}
		
		/**Returns true if the linkItem was visible*/
		private function thempRemoveLink(realLinkItem:LinkItem):Boolean
		{
			if(realLinkItem.visible)
			{
				realLinkItem.visible = false ;
				if(realLinkItem.myButtons)
				{
					Obj.remove(realLinkItem.myButtons);
				}
				Obj.remove(realLinkItem);
				return true ;
			}
			return false ;
		}
		
		
		/**Returns true if the linkItem was not in the stage**/
		public function showThempRemovedLink(removedLinkItem:LinkItem):Boolean
		{
			if(!removedLinkItem.visible)
			{
				removedLinkItem.visible = true;
				
				var removedLinkIndex:uint = linksInterfaceStorage.indexOf(removedLinkItem);
				
				
				var newLink:LinkItem = new linkClass() ;
				linksContainer.addChild(newLink) ;
				newLink.setSize(areaRect.width,areaRect.height);
				newLink.setIndex(removedLinkItem.myIndex);
				newLink.x = removedLinkItem.x;
				newLink.y = removedLinkItem.y;
				newLink.setUp(removedLinkItem.myLinkData) ;
				if(newLink.myLinkData==null)
					newLink.myLinkData = removedLinkItem.myLinkData ;
				
				this.dispatchEvent(new DynamicLinksEvent(DynamicLinksEvent.UPDATE_LINKS_POSITION));
				
				linksInterfaceStorage.splice(removedLinkIndex,1,newLink);

				if(removedLinkItem.height!=newLink.height)
				{
					updateLinksPosition();
				}
				
				removedLinkItem = null ;
				
				this.dispatchEvent(new DynamicLinksEvent(DynamicLinksEvent.NEW_LINK_ITEM_ADDED));
				return true ;
			}
			return false ;
		}
		
		/**This will just remove preloader from list*/
		public function noMoreLinks():void
		{
			//linksContainer.removeChild(requestPreLoader);
			if(requestPreLoader)
				requestPreLoader.visible = false ;
			
			//New lines to prevent any more requests till canGetMore functin calls again.
			requestMore = new Function() ;
			requestPreLoader = new Sprite() ;
			
		}
		
		/**Returns true if the selected linkIndex can stand on the stage*/
		private function showOrHideLinkItemByCalculation(linkIndex:uint):Boolean
		{
			if(dynamicHeight)
			{
				return true ;
			}
			if(horizontalMenu)
			{
				if(revertedX)
				{
					trace("!!!!!!!!!!!!!!! Control Reverted horizontal menus two");
				}
				else
				{
					trace("!!!!!!!!!!!!!!! Control horizontal menus two");
				}
				return true ;
			}
			else
			{
				var linkY:Number ;
				var linkBottom:Number;
				if(revertedY)
				{
					trace("!!!!!!!!!!!!!!! Control vertical reverted menu");
					return true ;
				}
				else
				{
					linkY = linksInterfaceStorage.length>linkIndex?linksInterfaceStorage[linkIndex].y:linksContainer.y+Math.floor(linkIndex/iconsPerLine)*linkItemHeight();
					linkBottom = linkY+linkItemHeight();
					trace("* linkY : "+linkY);
					trace("* linkBottom : "+linkBottom);
					trace("* areaRect : "+areaRect);
					trace("* linksContainer.y : "+linksContainer.y);
					if(linkY<areaRect.bottom+areaRect.height*2 && linkBottom>areaRect.top-areaRect.height*2)
					{
						return true ;
					}
					else
					{
						return false ;
					}
				}
			}
			return true ;
		}
		
		private function creatOneLink():Boolean
		{
			
			if(lastGeneratedLinkIndes<myPageData.links1.length)
			{
				trace(":::::howManyLinksGenerates : "+howManyLinksGenerates);
				for(var i:int = 0 ; i<howManyLinksGenerates && lastGeneratedLinkIndes<myPageData.links1.length ; i++)
				{
					var newLink:LinkItem ;
					newLink = new linkClass();
					linksInterfaceStorage.push(newLink);
					newLink.setIndex(lastGeneratedLinkIndes);
					if(showOrHideLinkItemByCalculation(lastGeneratedLinkIndes))
					{
						linksContainer.addChild(newLink) ;
						newLink.setSize(areaRect.width,areaRect.height);
						newLink.setUp(myPageData.links1[lastGeneratedLinkIndes]) ;
						if(newLink.myLinkData==null)
							newLink.myLinkData = myPageData.links1[lastGeneratedLinkIndes] ;
					}
					else
					{
						newLink.visible = false ;
					}
					newLink.myLinkData = myPageData.links1[lastGeneratedLinkIndes];
					
					createLinkOn(newLink,linksSensor,lastGeneratedLinkIndes,howManyLinksGenerates);
					updateDynamicLinsBackGround();
					
					lastGeneratedLinkIndes++ ;
				}
				this.dispatchEvent(new DynamicLinksEvent(DynamicLinksEvent.NEW_LINK_ITEM_ADDED));
				return true ;
			}
			else
			{
				return false ;
			}
		}
		
		
		/**This will update links position from 0*/
		public function updateLinksPosition(e:Event=null):void
		{
			if(e!=null)
			{
				e.stopImmediatePropagation();
			}
			var l:uint = linksInterfaceStorage.length ;
			//var Y:Number = myDeltaY*Ydirection ;
			var i:int = 1;
			if(horizontalMenu)
			{
				if(MenuDirectionX<0 && l>0)
				{
					linksInterfaceStorage[0].x = linksInterfaceStorage[0].width*-1+myDeltaX0;
				}
			}
			else
			{
				if(MenuDirectionY<0 && l>0)
				{
					linksInterfaceStorage[0].y = linksInterfaceStorage[0].height*-1+myDeltaY0;
				}
			}
			for(i = 1 ; i<l ; i++)
			{
				if(horizontalMenu)
				{
					if(MenuDirectionX>0)
					{
						linksInterfaceStorage[i].x = linksInterfaceStorage[i-1].x+(linksInterfaceStorage[i-1].width+myDeltaX);
					}
					else
					{
						linksInterfaceStorage[i].x = linksInterfaceStorage[i-1].x-(linksInterfaceStorage[i].width+myDeltaX);
					}
				}
				else
				{
					if(MenuDirectionY>0)
					{
						if(i%iconsPerLine==0)
						{
							linksInterfaceStorage[i].y = linksInterfaceStorage[i-1].y+(linksInterfaceStorage[i-1].height+myDeltaY);
						}
						else
						{
							linksInterfaceStorage[i].y = linksInterfaceStorage[Math.floor(i/iconsPerLine)*iconsPerLine].y ;
						}
					}
					else
					{
						linksInterfaceStorage[i].y = linksInterfaceStorage[i-1].y-(linksInterfaceStorage[i].height+myDeltaY);
					}
				}
			}
			var index:int = i-1;
			if(l<1)
			{
				index = 0 ;
			}
			
			if(index>0)
			{
				if(horizontalMenu)
				{
					if(MenuDirectionX>0)
					{
						linksSensor.x = linksInterfaceStorage[index].x+linksInterfaceStorage[index].width+myDeltaX;
					}
					else
					{
						linksSensor.x = linksInterfaceStorage[index].x-myDeltaX;
					}
				}
				else
				{
					if(MenuDirectionY>0)
					{
						linksSensor.y = linksInterfaceStorage[index].y+linksInterfaceStorage[index].height+myDeltaY;
					}
					else
					{
						//trace("************************** >>>>>>>>>>>>>>> "+index);
						linksSensor.y = linksInterfaceStorage[index].y-myDeltaY;
					}
				}
			}
			//trace("linksSensor : "+linksSensor.y+' MenuDirectionY : '+MenuDirectionY);
			updateDynamicLinsBackGround();
		}
		
		protected function updateDynamicLinsBackGround():void
		{
			
			linksContainer.graphics.clear();
			linksContainer.graphics.beginFill(0,backAlpha) ;
			
			var totalLinks:uint = myPageData.links1.length ;
			
			if(reloaderMC!=null)
			{
				totalLinks = Math.max(totalLinks,1+Math.ceil(areaRect.height/(sampleLink.height+deltaY)));
			}
			if(!horizontalMenu)
			{
				linksContainer.graphics.drawRect(0,0,areaRect.width*MenuDirectionX,linksSensor.y+(totalLinks-lastGeneratedLinkIndes-1)*(sampleLink.height+deltaY)*MenuDirectionY) ;
			}
			else
			{
				linksContainer.graphics.drawRect(0,0,linksSensor.x+(totalLinks-lastGeneratedLinkIndes-1)*(sampleLink.width+deltaX)*MenuDirectionX,areaRect.height) ;
			}
		}		
		
		/**Return the number of generated links for each lik generation*/
		protected function get howManyLinksGenerates():uint
		{
			return iconsPerLine ;
		}
		
		/**use currentLinksSensor to move it down and use its position and to know menuWidth from currentLinksSensor.width<br>
		 * DONT FORGET TO MOVE currentLinksSensor DOWN WHEN YOU USE IT<br>
		 *  newLink.x = (areaRect.width-newLink.width)/2 ;<br>
			newLink.y = linksSensor.y ;<br>
			linksSensor.y += newLink.height+deltaY ;<br>*/
		protected function createLinkOn(newLink:LinkItem,currentLinksSensor:Sprite,linkIndex:uint,linkPerLine:uint):void
		{
			var linkIndexPerLine:uint = linkIndex%linkPerLine ;
			if(newLink == null)
			{
				newLink = sampleLink;
			}
			if(!horizontalMenu)
			{
				newLink.x = ((areaRect.width-newLink.width*linkPerLine)/(linkPerLine+1))*(1+linkIndexPerLine)+newLink.width*linkIndexPerLine ;
				if(revertedX)
				{
					newLink.x = newLink.x*-1-newLink.width;
				}
				if(revertedY)
				{
					newLink.y = linksSensor.y-newLink.height ;
				}
				else
				{
					newLink.y = linksSensor.y ;
				}
				if((linkIndex+1)%linkPerLine==0)
				{
					if(revertedY)
					{
						linksSensor.y = newLink.y-myDeltaY ;
					}
					else
					{
						linksSensor.y = newLink.y+(newLink.height+myDeltaY) ;
					}
				}
				//trace(" linksSensor.y : "+linksSensor.y) ;
			}
			else
			{
				newLink.y = ((areaRect.height-newLink.height*linkPerLine)/(linkPerLine+1))*(1+linkIndexPerLine)+newLink.height*linkIndexPerLine ;
				if(revertedX)
				{
					newLink.x = linksSensor.x-newLink.width ;
				}
				else
				{
					newLink.x = linksSensor.x ;
				}
				if((linkIndex+1)%linkPerLine==0)
				{
					linksSensor.x += (newLink.width+myDeltaX)*MenuDirectionX ;
				}
			}
		}
		
	///////////////////////////
		
		/**This will make the drag reload event activationg. you have to pass an animated MovieCllip to use it as reloader*/
		public function addReloadFeature(reloadMC:MovieClip):void
		{
			linksContainer.addChild(reloadMC);
			reloadMC.stop();
			if(horizontalMenu)
			{
				reloadMC.y = areaRect.height/2;
				if(revertedX)
				{
					reloadMC.x = reloadMC.width/2;
				}
				else
				{
					reloadMC.x = reloadMC.width/-2;
				}
			}
			else
			{
				reloadMC.x = areaRect.width/2;
				if(revertedY)
				{
					reloadMC.y = reloadMC.height/2;
				}
				else
				{
					reloadMC.y = reloadMC.height/-2;
				}
			}
			reloaderMC = reloadMC ;
			updateDynamicLinsBackGround();
		}
	}
}