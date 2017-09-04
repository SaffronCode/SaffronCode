package contents
	//contents.RollingList
{
	import appManager.displayContentElemets.TitleText;
	
	import contents.displayPages.LinkItem;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class RollingList extends MovieClip
	{
		//appManager.displayContentElemets.TitleText
		
		private var rollerItemClass:Class ;
		
		private var myPageDataLink:Vector.<LinkData>,
					totalPageLinks:uint;
		
		private var scorllI:Number ; 
		
		private var myHeight:Number,
					myLinkItemHeight:Number;
		
		private var createdLins:Vector.<TitleText> ;
		
		private var firstOfList:int,
					lastOfList:int;
					
		public function RollingList()
		{
			super();
			
			var rollerSample:TitleText = Obj.findThisClass(TitleText,this);
			myLinkItemHeight = rollerSample.height ;
			rollerItemClass = Obj.getObjectClass(rollerSample) ;
			Obj.remove(rollerSample);
			
			myHeight = this.height ;
			this.removeChildren();
			this.graphics.clear();
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}	
		
		/**Removed from stage*/
		protected function unLoad(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,anim);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		/**Set the page list*/
		public function setUp(pageData:PageData):void
		{
			myPageDataLink = pageData.links1 ;
			totalPageLinks = myPageDataLink.length ;
			scorllI = 0 ;
			
			for(var i:int = 0 ; createdLins!=null && i<createdLins.length ; i++)
			{
				Obj.remove(createdLins[i]);
			}
			
			firstOfList = 0 ;
			lastOfList = 0 ;
			
			createdLins = new Vector.<TitleText>();
			
			controllLinkGenerator();
			updateAllInterface();
			this.removeEventListener(Event.ENTER_FRAME,anim);
			this.addEventListener(Event.ENTER_FRAME,anim);
		}
		
		/**Controll link*/
		private function controllLinkGenerator():void
		{
			var newLinkAdded:Boolean = false ;
			if(firstOfList>=0 && firstOfList<totalPageLinks)
			{
				var requiredLinkY:Number = createLinkY(firstOfList) ; 
				if(requiredLinkY+myLinkItemHeight>0 && requiredLinkY<myHeight)
				{
					addLink(firstOfList,false);
					firstOfList++ ;
					newLinkAdded = true ;
				}
			}
			
			if(newLinkAdded)
			{
				controllLinkGenerator();
			}
		}
		
		/**Add this item to the list*/
		private function addLink(linkItemIndex:int,isFromFirst:Boolean):void
		{
			var item:TitleText = new rollerItemClass();
			this.addChild(item);
			item.setUp(myPageDataLink[linkItemIndex].name);
			createdLins.push(item);
		}
		
		/**Animate the scorller*/
		protected function anim(event:Event):void
		{
			scorllI--;
			controllLinkGenerator();
			updateAllInterface();
		}	
		
		/**Update all interface*/
		private function updateAllInterface():void
		{
			var listLenght:uint = createdLins.length ;
			for(var i:int = 0 ; i<listLenght ; i++)
			{
				createdLins[i].y = createLinkY(i) ;
			}			
		}
		
		/**Return the link Y for this index*/
		private function createLinkY(itemIndex:uint):Number
		{
			return itemIndex*20+scorllI ;
		}
	}
}