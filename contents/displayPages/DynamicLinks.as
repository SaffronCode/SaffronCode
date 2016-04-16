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
{
	import contents.LinkData;
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class DynamicLinks extends MovieClip implements DisplayPageInterface
	{
		public static const UPDATE_LINKS_POSITION:String = "UPDATE_LINKS_POSITION" ;
		
		/**Change it befor setup function. it makes items to lock on the left side of the list after release.*/
		public var showStepByStep:Boolean = false ;
		
		/**This will be the name of the MovieClip that will shows if no links available*/
		private const noLinkInstanceName:String = "no_link_mc";
		
		/**←→ *** Change it befor super function*/
		public var horizontalMenu:Boolean = false ;
		
		private static var scrollPosesObject:Object = {} ;
		
		private const backAlpha:Number = 0 ;
		
		private const linkSensorDebug:Number = 0.0 ;
		
		protected var myPageData:PageData ;
		
		protected var sampleLink:LinkItem,
					linkClass:Class;
					
		protected var sampleLinkButton:LinkItemButtons,
					linkButtonClass,
					activeSlideButtons:Boolean = false,
					draggableLinkItem:LinkItem,
					mouseFirstPose:Number,
					mouseDeltaToSlide:Number=50,
					linkItemButtonsWidth:Number;
					
		protected var 	linkScroller:ScrollMT,
						areaRect:Rectangle,
						linksContainer:Sprite,
						buttonsContainer:Sprite,
						linksSensor:Sprite ;
						
		/**This is the list of creted linkItems on the stage.*/
		private var linksInterfaceStorage:Vector.<LinkItem> ;
		
		private var lastVisibleItem:uint = 0 ;
					
		protected var lastGeneratedLinkIndes:uint ;
		
		public static var deltaY:Number = 20,
							deltaX:Number = 20;
		
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
		public var acceptAnimation:Boolean = true;
		
		private var reverted:Boolean = false ;
		
		/**Load all links togather without sensor*/
		protected var loadAllLinksInstantly:Boolean ;
		
		protected var dynamicHeight:Boolean = false ;
		
		/**Make the dynamic link not scrollable and show all items instantly*/
		public function set_dynamicHeigh(status:Boolean=true):void
		{
			dynamicHeight = loadAllLinksInstantly = status ;
		}

		
		/**returns Y direction by reverted value*/
		protected function get MenuDirection():int
		{
			if(reverted)
			{
				return -1 ;
			}
			else
			{
				return 1 ;
			}
		}
		
		/**1-Cereate LinkItem on this pages<br>
		 * 2- Draw a shape to define scrollArea in this object*/
		public function DynamicLinks()
		{
			super();
			
			this.addEventListener(UPDATE_LINKS_POSITION,updateLinksPosition);
			
			myDeltaY = deltaY ;
			myDeltaX = deltaX ;
			
			//This will automaticaly removes at the last line
			
			noLinksMC = Obj.get(noLinkInstanceName,this);
			
			areaRect = this.getBounds(this);
			
			sampleLink = Obj.findThisClass(LinkItem,this,true);
			if(sampleLink ==null)
			{
				throw "Dynamic manu class shouldent be empty of linkItem!";
			}
			
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
			if(!horizontalMenu)
			{
				if(this.getBounds(this).y<this.height/-2)
				{
					trace("*****Reverted menu activated******");
					reverted = true ;
				}
			}
			else
			{
				if(this.getBounds(this).x<this.width/-2)
				{
					trace("*****Reverted menu activated on horizontal mode******");
					reverted = true ;
				}
			}
			
			this.removeChildren();
			
			if(activeSlideButtons)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN,controllMouseSlide);
			}
		}
		
		
		
		
		
		/**Start controlling mouse down*/
		protected function controllMouseSlide(event:MouseEvent):void
		{
			trace("Mouse clicked");
			var itemY:Number ; 
			var currentLinkItem:LinkItem ;
			for(var i = 0 ; linksInterfaceStorage!=null && i<linksInterfaceStorage.length ; i++)
			{
				currentLinkItem = linksInterfaceStorage[i]; 
				if(!horizontalMenu)
				{
					itemY = currentLinkItem.y ;
					if( linksContainer.mouseY>itemY && linksContainer.mouseY < itemY+currentLinkItem.height )
					{
						mouseFirstPose = linksContainer.mouseX;
						draggableLinkItem = currentLinkItem ;
						addLintItemButton(currentLinkItem);
						this.stage.addEventListener(MouseEvent.MOUSE_MOVE,controllsliding);
						this.stage.addEventListener(MouseEvent.MOUSE_UP,canselSliding);
						trace("Item founded");
					}
					else
					{
						currentLinkItem.slideHorizontal(0,0,true)
					}
				}
			}
		}		
		
		/**Add link item button*/
		private function addLintItemButton(linkItem:LinkItem):void
		{
			if(linkItem.myButtons==null)
			{
				linkItem.myButtons = new linkButtonClass() ;
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
				mouseFirstPose = NaN ;
				draggableLinkItem = null ;
				trace("Controll the button pose and cansel animation");
			}
			
			/**Contrlolll slide process*/
			protected function controllsliding(event:MouseEvent):void
			{
				if(linksContainer.mouseX<mouseFirstPose-mouseDeltaToSlide)
				{
					draggableLinkItem.slideHorizontal((linksContainer.mouseX-mouseFirstPose+mouseDeltaToSlide)/linkItemButtonsWidth,linkItemButtonsWidth) ;
					event.updateAfterEvent();
					trace("Deative scroll and other buttons");
					linkScroller.lock(true);
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
			if(reverted)
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
		
		/**Call this after setUp*/
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
			lastVisibleItem= 0 ;
			
			//trace("current page data is : "+pageData.export());
			this.removeChildren();
			myPageData = pageData;
			if(pageData.links1.length == 0 && noLinksMC!=null)
			{
				this.addChild(noLinksMC);
			}
			else
			{
				createLinks();
			}
			this.addEventListener(Event.REMOVED_FROM_STAGE,saveLastPosition);
			this.addEventListener(Event.REMOVED_FROM_STAGE,saveLastPosition);
		}
		
		private function saveLastPosition(event:Event=null):void
		{
			// TODO Auto-generated method stub
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
		
		private function createLinks()
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
			
			
			linksContainer = new Sprite();
			linksContainer.x = areaRect.x ;
			
			/**Button container*/
			buttonsContainer = new Sprite();
			if(reverted)
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
			linksContainer.graphics.drawRect(0,0,areaRect.width*MenuDirection,areaRect.height*MenuDirection) ;
			
			this.addChild(linksContainer);
			linksContainer.addChild(buttonsContainer);
		
			
			linksSensor = new Sprite();
			if(!horizontalMenu)
			{
				linksSensor.y = myDeltaY*MenuDirection ;
			}
			else
			{
				linksSensor.x = myDeltaX*MenuDirection ;
			}
			linksSensor.graphics.beginFill(0xff0000,linkSensorDebug);
			var stepSize:Number = 0 ;
			if(!horizontalMenu)
			{
				if(showStepByStep)
				{
					stepSize = sampleLink.height+deltaY ;
				}
				linksSensor.graphics.drawRect(0,0,areaRect.width,areaRect.height/2*MenuDirection);
			}
			else
			{
				if(showStepByStep)
				{
					stepSize = sampleLink.width+deltaX ;
				}
				linksSensor.graphics.drawRect(0,0,areaRect.width/2*MenuDirection,areaRect.height);
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
				linkScroller = new ScrollMT(linksContainer,areaRect,/*areaRect*/null,!horizontalMenu,horizontalMenu,acceptAnimation&&!reverted,reverted,false,stepSize);
				if(myPageData.id!='' && scrollPosesObject[myPageData.id]!=null)
				{
					if(!horizontalMenu)
					{
						linksContainer.y = scrollPosesObject[myPageData.id];
						if(scrollPosesObject[myPageData.id]<areaRect.y-1)
						{
							linkScroller.stopFloat();
						}
						linkScroller.setAbsolutePose(areaRect.x,scrollPosesObject[myPageData.id]);
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
					linkScroller.lock(true);
					linkScroller.unLock();
				}
			}
			
			this.addEventListener(Event.ENTER_FRAME,controllSensor);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		public function lockScroll(X:Number=0,Y:Number=0):void
		{
			linkScroller.setPose(X,Y);
			linkScroller.lock();
		}
		
		public function scrollReset():void
		{
			linkScroller.reset();
		}
		
		/**Adds more links to links list. but if there is no link any more, you have to call noMoreLinks() funcion to remove preloader*/
		public function addLink(listOfLinks:Vector.<LinkData>):void
		{
			trace("controll again");
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
		
		private function unLoad(ev:Event=null)
		{
			this.removeEventListener(Event.ENTER_FRAME,controllSensor) ;
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad) ;
		}
		
		private function controllSensor(ev:Event=null)
		{
			var sens:Rectangle = linksSensor.getBounds(this);
			
			if(false && linksInterfaceStorage.length>0)
			{
				var visibleItem:LinkItem = linksInterfaceStorage[lastVisibleItem] ;
				var inVisibleItem:LinkItem = linksInterfaceStorage[Math.max(0,lastVisibleItem-1)] ;
				do
				{
					if(!horizontalMenu)
					{
						if(!reverted)
						{
							if(visibleItem.y+linksContainer.y+visibleItem.height<0)
							{
								if(visibleItem.visible)
								{
									visibleItem.visible=false;
									lastVisibleItem = Math.min(linksInterfaceStorage.length-1,lastVisibleItem+1);
									continue;
								}
							}
							if(lastVisibleItem>0 && inVisibleItem.y+inVisibleItem.y+inVisibleItem.height>=0)
							{
								if(!inVisibleItem.visible)
								{
									inVisibleItem.visible=true;
									lastVisibleItem = Math.max(0,lastVisibleItem-1);
									continue;
								}
							}
						}
						else
						{
							trace("?");
						}
					}
					else
					{
						if(!reverted)
						{
							trace("?");
						}
						else
						{
							trace("?");
						}
					}
					break;
				}while(true);
			}
			
			if(loadAllLinksInstantly ||
				(!horizontalMenu && !reverted && sens.top<areaRect.bottom) || (!horizontalMenu && reverted && sens.bottom>areaRect.top)
				|| (horizontalMenu && !reverted && sens.left<areaRect.right) || (horizontalMenu && reverted && sens.right>areaRect.left))
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
				}
				else
				{
					unLoad();
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
					if(linksSensor.parent!=null)
					{
						linksContainer.removeChild(linksSensor);
					}
					//Call below function after preloader added.
					requestMore();
				}
			}
		}
		
		/**This will just remove preloader from list*/
		public function noMoreLinks():void
		{
			//linksContainer.removeChild(requestPreLoader);
			requestPreLoader.visible = false ;
			
			//New lines to prevent any more requests till canGetMore functin calls again.
			requestMore = new Function() ;
			requestPreLoader = new Sprite() ;
			
		}
		
		private function creatOneLink():Boolean
		{
			// TODO Auto Generated method stub
			if(lastGeneratedLinkIndes<myPageData.links1.length)
			{
				for(var i = 0 ; i<howManyLinksGenerates && lastGeneratedLinkIndes<myPageData.links1.length ; i++)
				{
					var newLink:LinkItem = new linkClass() ;
					linksContainer.addChild(newLink) ;
					newLink.setSize(areaRect.width,areaRect.height);
					newLink.setUp(myPageData.links1[lastGeneratedLinkIndes]) ;
					
					createLinkOn(newLink,linksSensor);
					
					linksInterfaceStorage.push(newLink);
					
					updateDynamicLinsBackGround();
					
					lastGeneratedLinkIndes++ ;
				}
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
			if(MenuDirection<0 && l>0)
			{
				linksInterfaceStorage[0].y = linksInterfaceStorage[0].height*-1;
			}
			for(i = 1 ; i<l ; i++)
			{
				if(MenuDirection>0)
				{
					linksInterfaceStorage[i].y = linksInterfaceStorage[i-1].y+(linksInterfaceStorage[i-1].height+myDeltaY);
				}
				else
				{
					linksInterfaceStorage[i].y = linksInterfaceStorage[i-1].y-(linksInterfaceStorage[i].height+myDeltaY);
				}
			}
			var index:int = i-2;
			if(l<2)
			{
				index = 0 ;
			}
			
			
			if(MenuDirection>0)
			{
				linksSensor.y = linksInterfaceStorage[index].y+linksInterfaceStorage[index].height+myDeltaY;
			}
			else
			{
				linksSensor.y = linksInterfaceStorage[index].y-myDeltaY;
			}
			trace("linksSensor : "+linksSensor.y);
			updateDynamicLinsBackGround();
		}
		
		private function updateDynamicLinsBackGround():void
		{
			// TODO Auto Generated method stub
			linksContainer.graphics.clear();
			linksContainer.graphics.beginFill(0,backAlpha) ;
			if(!horizontalMenu)
			{
				linksContainer.graphics.drawRect(0,0,areaRect.width,linksSensor.y) ;
			}
			else
			{
				linksContainer.graphics.drawRect(0,0,linksSensor.x,areaRect.height) ;
			}
		}		
		
		/**Return the number of generated links for each lik generation*/
		protected function get howManyLinksGenerates():uint
		{
			return 1 ;
		}
		
		/**use currentLinksSensor to move it down and use its position and to know menuWidth from currentLinksSensor.width<br>
		 * DONT FORGET TO MOVE currentLinksSensor DOWN WHEN YOU USE IT<br>
		 *  newLink.x = (areaRect.width-newLink.width)/2 ;<br>
			newLink.y = linksSensor.y ;<br>
			linksSensor.y += newLink.height+deltaY ;<br>*/
		protected function createLinkOn(newLink:LinkItem,currentLinksSensor:Sprite):void
		{
			if(!horizontalMenu)
			{
				newLink.x = (areaRect.width-newLink.width)/2 ;
				if(reverted)
				{
					newLink.y = linksSensor.y-newLink.height ;
				}
				else
				{
					newLink.y = linksSensor.y ;
				}
				linksSensor.y += (newLink.height+myDeltaY)*MenuDirection ;
				//trace(" linksSensor.y : "+linksSensor.y) ;
			}
			else
			{
				newLink.y = (areaRect.height-newLink.height)/2 ;
				if(reverted)
				{
					newLink.x = linksSensor.x-newLink.width ;
				}
				else
				{
					newLink.x = linksSensor.x ;
				}
				linksSensor.x += (newLink.width+myDeltaX)*MenuDirection ;
			}
		}
	}
}