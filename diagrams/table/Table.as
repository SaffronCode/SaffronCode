package diagrams.table
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	[Event(name="TABLE_SELECTED", type="diagrams.table.TableEvent")]
	public class Table extends Sprite
	{
		private var area:Rectangle ;
		
		private var myTitles:TableTitleValue,
					myContents:TableContent;
		
		private var RTL:Boolean ;
		
		private var tableBoxes:Vector.<TableBox> ;
		
		public function Table(myAreaRectangle:Rectangle,
							  titleValues:TableTitleValue,
							  contentValue:TableContent,
							  backGroundColor:uint = TableConstants.Color_backColor,
							  rtl:Boolean=true,
								transparent:Boolean=false)
		{
			super();
			
			RTL = rtl ;
			
			area = myAreaRectangle.clone() ;
			this.x = area.x;
			this.y = area.y;
			var backAlpha:Number = 1 ;
			if(transparent)
			{
				backAlpha = 0 ;
			}
			this.graphics.beginFill(backGroundColor,backAlpha);
			this.graphics.drawRect(0,0,area.width,area.height);
			
			myTitles = titleValues ;
			myContents = contentValue ;
			
			create();
		}
		
		private function create():void
		{
			// TODO Auto Generated method stub
			if(myTitles==null)
			{
				trace("No title added");
				return ;
			}
			
			tableBoxes = new Vector.<TableBox>();
			
			/**Htitle length*/
			var hl:uint = myTitles.HTitles.length ;
			/**Vtitle length*/
			var vl:uint = myTitles.VTitles.length ;
			if(vl == 0)
			{
				trace("No vertical title added");
				return ;
			}
			else if(hl == 0)
			{
				trace("No horizontal title added");
				return ;
			}
			var Wfix:Number ;
			var Hfix:Number ;
			
			var W:Number;
			var H:Number;
			
			var titleH:Number;
			var titleW:Number;
			
			if(TableConstants.fixH == 0 )
			{
				Hfix = (area.height)/(vl+1);
				titleH = Hfix ;
			}
			else
			{
				Hfix = (area.height-TableConstants.fixH)/(vl);
				titleH = TableConstants.fixH;
			}
			
			if(TableConstants.fixW == 0 )
			{
				Wfix = area.width/(hl+1);
				titleW = Wfix ;
			}
			else
			{
				Wfix = (area.width-TableConstants.fixW)/(hl);
				titleW = TableConstants.fixW;
			}
			
		
			
			
			var color:uint ;
			var isTitle:Boolean ;
			var text:String ;
			var vid:uint,hid:uint;
			
			for(var i = 0 ; i<hl+1 ; i++)
			{
				for(var j = 0 ; j<vl+1 ; j++)
				{
					isTitle = false ;
					vid = 0 ;
					hid = 0 ;
					
					W = Wfix;
					H = Hfix;
					
					if(i == 0 && j == 0)
					{
						continue ;
					}
					if(i == 0)
					{
						W = titleW;
						isTitle = true ;
						text = myTitles.VTitles[j-1].Title ;
						color = TableConstants.Color_VBackolor ;
					}
					else if(j==0)
					{
						H = titleH;
						isTitle = true ;
						text = myTitles.HTitles[i-1].Title ;
						color = TableConstants.Color_HBackColor ;
					}
					else
					{
						vid = myTitles.VTitles[j-1].ID;
						hid = myTitles.HTitles[i-1].ID;
						isTitle = false ;
						text = '' ;
						color = TableConstants.Color_backBoxColor ;
					}
					
					var newBox:TableBox = new TableBox(W,H,color,vid,hid,text,TableConstants.margin,isTitle);
					if(!isTitle)
					{
						tableBoxes.push(newBox);
					}
					this.addChild(newBox);
					if(RTL)
					{
						//newBox.x = (hl-i)*W;
						newBox.x = (area.width-titleW)+(-i)*W;
					}
					else
					{
						if(i>0)
						{
							newBox.x = titleW+(i-1)*W;
						}
					}
					//newBox.y = titleH;
					if(j>0)
					{
						newBox.y=titleH+(j-1)*H;
					}
					
				}
			}
			
			manageContents();
		}
		
		/**This function will update contents*/
		public function resetContent(tableContent:TableContent=null):void
		{
			if(tableContent == null)
			{
				myContents = new TableContent();
			}
			else
			{
				myContents = tableContent;
			}
			manageContents() ;
		}
		
		/**This will update content*/
		public function updateContent(tableContent:TableContent):void
		{
			//No need to controll duplicated data here, because no duplicated data can inseret in TableContent any more
			/*for(var i = 0 ; i <myContents.contentList.length ; i++)
			{
				for(var j = 0 ; j<tableContent.contentList.length ; j++)
				{
					if(myContents.contentList[i].hid == tableContent.contentList[j].hid &&
						myContents.contentList[i].vid == tableContent.contentList[j].vid)
					{
						trace("Old content droped");
						myContents.contentList.splice(i,1);
						i--;
					}
				}
			}*/
			
			//New Line instead of concating lists
				for(var i = 0 ; i<tableContent.contentList.length ; i++)
				{
					myContents.addData(tableContent.contentList[i].vid,tableContent.contentList[i].hid,tableContent.contentList[i].title,tableContent.contentList[i].color);
				}
			//myContents.contentList = myContents.contentList.concat(tableContent.contentList);
			manageContents();
		}
		
		private function manageContents():void
		{
			// TODO Auto Generated method stub
			if(myContents == null || tableBoxes==null)
			{
				trace("Cannot create contents");
				return ;
			}
			trace("manage contentes");
			var backUpdated:Boolean ;
			for(var j = 0 ; j<tableBoxes.length ; j++)
			{
				backUpdated = false ;
				for(var i = 0 ;i<myContents.contentList.length ; i++)
				{
					//trace("tableBoxes["+j+"]  vs  myContents.contentList["+i+"]")
					//trace(tableBoxes[j].vId+' vs '+myContents.contentList[i].vid);
					if(tableBoxes[j].vId == myContents.contentList[i].vid && tableBoxes[j].hId == myContents.contentList[i].hid)
					{
						backUpdated = true ;
						tableBoxes[j].text = myContents.contentList[i].title ;
						tableBoxes[j].color = myContents.contentList[i].color ;
						break ;
					}
				}
				if(!backUpdated)
				{
					tableBoxes[j].text = '' ;
					tableBoxes[j].color = TableConstants.Color_backBoxColor ;
				}
			}
		}
	}
}