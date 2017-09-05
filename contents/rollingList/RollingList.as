package contents.rollingList
	//contents.rollingList.RollingList
{
	import contents.LinkData;
	import contents.PageData;
	import contents.displayPages.LinkItem;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class RollingList extends MovieClip
	{
		//appManager.displayContentElemets.TitleText
		
		private var rollerItemClass:Class ;
		
		private var myPageDataLink:Vector.<LinkData>,
					totalPageLinks:uint;
		
		
		private var myHeight:Number,
					myWidth:Number,
					myLinkItemHeight:Number;
		
		private var createdLins:Vector.<RollingItem> ;
		
		private var bottomOfList:int,
					topOfList:int;
					
		private var rollingItemsMask:Sprite ,
					rollingItemsContainer:Sprite ;
					
					
		//Animation variables
		private var scorllI:Number ;
		private var isDragging:Boolean = false ;
		private var currentMouseY:Number ;
		private var V:Number,
					Vlist:Vector.<Number>,
					vQueLength:uint = 20 ,
					mu:Number = 0.9,
					mu2:Number=0.4,
					fu:Number = 5 ;
					
		//Debug variables
					private var direction:Number = -1 ;
					
		public function RollingList()
		{
			super();
			
			scorllI = 0 ;
			V = 0 ;
			
			var rollerSample:RollingItem = Obj.findThisClass(RollingItem,this);
			myLinkItemHeight = rollerSample.height ;
			rollerItemClass = Obj.getObjectClass(rollerSample) ;
			Obj.remove(rollerSample);
			
			myHeight = this.height ;
			myWidth = this.width ;
			this.removeChildren();
			this.graphics.clear();
			
			rollingItemsMask = new Sprite();
			rollingItemsMask.graphics.beginFill(0x000000,0.1);
			rollingItemsMask.graphics.drawRect(0,0,myWidth,myHeight);
			
			rollingItemsContainer = new Sprite();
			
			this.addChild(rollingItemsContainer);
			this.addChild(rollingItemsMask);
			
			rollingItemsContainer.mask = rollingItemsMask ;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mousePressed);
		}	
		
		/**Mouse down*/
		protected function mousePressed(event:MouseEvent):void
		{
			isDragging = true ;
			V = 0 ;
			Vlist = new Vector.<Number>();
			stage.addEventListener(MouseEvent.MOUSE_UP,stopDraging);
			currentMouseY = this.mouseY ;
		}
		
		/**Mouse up*/
		protected function stopDraging(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopDraging);
			isDragging = false ;
		}
		
		/**Animate the scorller*/
		protected function anim(event:Event):void
		{
			if(isDragging)
			{
				scorllI += (this.mouseY-currentMouseY);
				Vlist.push(this.mouseY-currentMouseY);
				currentMouseY = this.mouseY ;
				if(Vlist.length>vQueLength)
				{
					Vlist.shift();
				}
			}
			else
			{
				if(Vlist!=null)
				{
					V = 0 ;
					for(var i:int = 0 ; i<Vlist.length ; i++)
					{
						V += Vlist[i] ;
					}
					V = V/Vlist.length ;
					Vlist = null ;
				}
				if(createLinkY(0)>0)
				{
					V += (0-createLinkY(0))/fu ;
					V = V*mu2 ;
				}
				else if(createLinkY(totalPageLinks-1)+myLinkItemHeight<myHeight)
				{
					V += (myHeight-(createLinkY(totalPageLinks-1)+myLinkItemHeight))/fu ;
					V = V*mu2 ;
				}
				scorllI += V ;
				V = V*mu ;
			}
			controllLinkGenerator();
			updateAllInterface();
		}	
		
		/**Removed from stage*/
		protected function unLoad(event:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopDraging);
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
			
			bottomOfList = 1 ;
			topOfList = 0 ;
			
			createdLins = new Vector.<RollingItem>();
			
			controllLinkGenerator();
			updateAllInterface();
			this.removeEventListener(Event.ENTER_FRAME,anim);
			this.addEventListener(Event.ENTER_FRAME,anim);
		}
		
		/**Controll link*/
		private function controllLinkGenerator():void
		{
			var newLinkAdded:Boolean = false ;
			var requiredLinkY:Number ;
			if(bottomOfList>=0)
			{
				if(bottomOfList<totalPageLinks)
				{
					requiredLinkY = createLinkY(bottomOfList); 
					if(requiredLinkY+myLinkItemHeight>0 && requiredLinkY<myHeight)
					{
						addLink(bottomOfList,true);
						bottomOfList++ ;
						newLinkAdded = true ;
					}
				}
				if(bottomOfList>0 && createLinkY(bottomOfList-1)>myHeight)
				{
					removeLint(true);
					bottomOfList--;
				}
			}
			if(topOfList>=0)
			{
				requiredLinkY = createLinkY(topOfList);
				if(requiredLinkY+myLinkItemHeight>0 && requiredLinkY<myHeight)
				{
					addLink(topOfList,false);
					topOfList--;
					newLinkAdded = true ;
				}
			}
			if(topOfList+1<totalPageLinks && createLinkY(topOfList+1)+myLinkItemHeight<0)
			{
				removeLint(false);
				topOfList++;
			}
			
			if(newLinkAdded)
			{
				controllLinkGenerator();
			}
		}
		
		/**Add this item to the list*/
		private function addLink(linkItemIndex:int,isFromBottom:Boolean):void
		{
			var item:RollingItem = new rollerItemClass();
			rollingItemsContainer.addChild(item);
			item.setUp(myPageDataLink[linkItemIndex].name,true,false,1);
			item.setIndex(linkItemIndex);
			if(isFromBottom)
			{
				createdLins.push(item) ;
			}
			else
			{
				createdLins.unshift(item) ;
			}
		}
		
		/**Remove the link item from the list*/
		private function removeLint(isFromBottom:Boolean)
		{
			if(isFromBottom)
			{
				Obj.remove(createdLins.pop());
			}
			else
			{
				Obj.remove(createdLins.shift());
			}
		}
		
		/**Update all interface*/
		private function updateAllInterface():void
		{
			var listLenght:uint = createdLins.length ;
			for(var i:int = 0 ; i<listLenght ; i++)
			{
				createdLins[i].y = createLinkY(createdLins[i].myIndex) ;
			}			
		}
		
		/**Return the link Y for this index*/
		private function createLinkY(itemIndex:uint):Number
		{
			return itemIndex*20+scorllI ;
		}
	}
}