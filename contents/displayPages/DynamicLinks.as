/***Version
 * 	1.1 : Save the last position of the scrollMT for each pageID to load it from that position later
 * 	1.1.1 : when the menu was empty, it will cause an error on leave stage.
 * 	1.2 : 	add function added to add linkData to old link datas
 * 			DynamicLinks can request more links. you can set this on setUp function at the beggining.
 * 			3 new functions : canGetMore, addLinks, noMoreLinks
 * 
 * 
 * 
 */


package contents.displayPages
	//contents.displayPages.DynamicLinks
{
	import contents.LinkData;
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class DynamicLinks extends MovieClip implements DisplayPageInterface
	{
		private static var scrollPosesObject:Object = {} ;
		
		protected var myPageData:PageData ;
		
		protected var sampleLink:LinkItem,
					linkClass:Class;
					
		protected var linkScroller:ScrollMT,
					areaRect:Rectangle,
					linksContainer:Sprite,
					linksSensor:Sprite ;
					
		protected var lastGeneratedLinkIndes:uint ;
		
		public static var deltaY:Number = 20 ;
		
		private var noLinksMC:MovieClip ;
		
		//New values
		/**It will call the parent for more links if there is and until then, it will shows preloader*/
		private var requestMore:Function;
		
		/**Preloader for more datas*/
		private var requestPreLoader:Sprite ;
		
		/**1-Cereate LinkItem on this pages<br>
		 * 2- Draw a shape to define scrollArea in this object*/
		public function DynamicLinks()
		{
			super();
			
			//This will automaticaly removes at the last line
			noLinksMC = Obj.get("no_link_mc",this);
			
			areaRect = this.getBounds(this);
			
			sampleLink = Obj.findThisClass(LinkItem,this,true);
			if(sampleLink ==null)
			{
				throw "Dynamic manu class shouldent be empty of linkItem!";
			}
			
			linkClass = getDefinitionByName(getQualifiedClassName(sampleLink)) as Class;
			trace('link class is : '+linkClass);
			
			this.removeChildren();
		}
		
		/**Call this after setUp*/
		public function canGetMore(youCanRequestForMore:Function,preLoaderObject:Sprite):void
		{
			requestMore = youCanRequestForMore ;
			requestPreLoader = preLoaderObject ;
		}
		
		public function setUp(pageData:PageData):void
		{
			//new functions
			if(requestPreLoader==null)
			{
				requestPreLoader = new Sprite(); 
			}
			if(requestMore==null)
			{
				requestMore = new Function() ;
			}
			
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
			this.addEventListener(Event.REMOVED_FROM_STAGE,saveLastY);
		}
		
		private function saveLastY(event:Event):void
		{
			// TODO Auto-generated method stub
			if(linksContainer!=null)
			{
				trace("*.Last Y : "+linksContainer.y);
				scrollPosesObject[myPageData.id] = linksContainer.y ;
			}
		}
		
		private function createLinks()
		{
			trace("Creat links");
			lastGeneratedLinkIndes = 0 ;
			
			linksContainer = new Sprite();
			linksContainer.x = areaRect.x ;
			linksContainer.y = areaRect.y ;
			linksContainer.graphics.beginFill(0,0) ;
			linksContainer.graphics.drawRect(0,0,areaRect.width,areaRect.height) ;
			
			this.addChild(linksContainer);
		
			
			linksSensor = new Sprite();
			linksSensor.y = deltaY ;
			linksSensor.graphics.beginFill(0,0);
			linksSensor.graphics.drawRect(0,0,areaRect.width,areaRect.height/2);
			
			linksContainer.addChild(linksSensor);
			
			if(scrollPosesObject[myPageData.id]!=null)
			{
				linksContainer.y = scrollPosesObject[myPageData.id];
				controllSensor();
			}
			
			linkScroller = new ScrollMT(linksContainer,areaRect,areaRect,true,false,true);
			if(scrollPosesObject[myPageData.id]!=null)
			{
				if(scrollPosesObject[myPageData.id]<areaRect.y-1)
				{
					linkScroller.stopFloat();
				}
				linkScroller.setPose(areaRect.x,scrollPosesObject[myPageData.id]);
				controllSensor();
			}
			
			this.addEventListener(Event.ENTER_FRAME,controllSensor);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		/**Adds more links to links list. but if there is no link any more, you have to call noMoreLinks() funcion to remove preloader*/
		public function addLink(listOfLinks:Vector.<LinkData>):void
		{
			trace("controll again");
			myPageData.links1 = myPageData.links1.concat(listOfLinks);
			
			this.addEventListener(Event.ENTER_FRAME,controllSensor);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		private function unLoad(ev:Event=null)
		{
			this.removeEventListener(Event.ENTER_FRAME,controllSensor) ;
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad) ;
		}
		
		private function controllSensor(ev:Event=null)
		{
			var sens:Rectangle = linksSensor.getBounds(this);
			if(sens.top<areaRect.bottom)
			{
				var ifTherIs:Boolean = creatOneLink();
				if(ifTherIs)
				{
					requestPreLoader.visible = false ;
					//Call this recursive function after preloader is invisible
					controllSensor();
				}
				else
				{
					unLoad();
					linksContainer.addChild(requestPreLoader);
					requestPreLoader.y = linksSensor.y ;
					requestPreLoader.x = areaRect.width/2 ;
					requestPreLoader.visible = true ;
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
					newLink.setUp(myPageData.links1[lastGeneratedLinkIndes]) ;
					
					createLinkOn(newLink,linksSensor);
					
					linksContainer.graphics.clear();
					linksContainer.graphics.beginFill(0,0) ;
					linksContainer.graphics.drawRect(0,0,areaRect.width,linksSensor.y) ;
					
					lastGeneratedLinkIndes++ ;
				}
				return true ;
			}
			else
			{
				return false ;
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
			newLink.x = (areaRect.width-newLink.width)/2 ;
			newLink.y = linksSensor.y ;
			linksSensor.y += newLink.height+deltaY ;
		}
	}
}