package tableManager
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ThrottleEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import tableManager.data.Button;
	import tableManager.data.Pictrue;
	import tableManager.data.Type;
	import tableManager.graphic.Align;
	import tableManager.graphic.Cell;
	import tableManager.graphic.Direction;
	import tableManager.graphic.Location;
	import tableManager.graphic.Table;
	[Event(name="UPDATE_TABLE",type="tableManager.TableEvents")]	
	[Event(name="COMPELET_TABLE",type="tableManager.TableEvents")]
	public class TableManager extends MovieClip
	{

		private var _table:Table

		public function get table():Table
		{
			return _table
		}
		private var _list:Vector.<Cell> = new Vector.<Cell>();
		private var listCopye:Vector.<Cell> = new Vector.<Cell>();
		public function get list():Vector.<Cell>
		{
			return _list
		}
		private var _target:MovieClip
		public function get target():MovieClip
		{
			return _target
		}
		
		private var conter:int;
		private var conterRow:int

		private var currenDelay:int
		
		private var totalCell:int;
		private var oldTotalCell:int;
		private var rowSpanOk:Boolean;

		private var Xmax_array:Array;
		private var XmaxCell_array:Array;
		private var Ymax_array:Array;
		private var YmaxCell_array:Array;
		private var maxRowConter:int;
		private var scrolRangUpdate:Number = 150
		private var scrol2:ScrollMT;
		public function TableManager()
		{

		}
		public function setUp(Target_p:MovieClip,Table_p:Table,List_p:Vector.<Cell>):void
		{
			_target = new MovieClip()
			Target_p.addChild(_target)	
			_table = Table_p
			_list = List_p	
			setReverseList(_list)
			setValue()

			picKList()
		}
		private function graphicTable(Rectangle_p:Rectangle):void
		{ 	
			_target.graphics.clear()
			_target.graphics.lineStyle(table.GraphicTable.stroke,table.GraphicTable.lineColor,table.GraphicTable.lineAlpha)	
			_target.graphics.beginFill(table.GraphicTable.backGroundColor,table.GraphicTable.backGroundAlpha)
			_target.graphics.drawRect(Rectangle_p.x,Rectangle_p.y,Rectangle_p.width,Rectangle_p.height)	
			
				
		}
		public function upDate(List_p:Vector.<Cell>):void
		{
			
			if(table.ColumnSpan || table.RowSpan)
			{
				reset()
			}
			else
			{
				oldTotalCell = totalCell
				conter++	
			}
			setReverseList(List_p)
			
			picKList()
			_list = list.concat(List_p)
			
		}
		private function setReverseList(List_p):void
		{
			
			if(table.DirectionTable == Direction.LEFT_TO_RIGHT_BUTTOM_TO_TOP || table.DirectionTable == Direction.RIGHT_TO_LELFT_BUTTOM_TO_TOP)	
			{
				listCopye = listCopye.concat(List_p.reverse())
				
			}
			else
			{
				listCopye = listCopye.concat(List_p)
			}

		}
		private function picKList():void
		{
			if(splitRow(conter)==0 && conter!=0)
			{
				conterRow++		
			}
			
			if(conterRow<=Math.floor(listCopye.length-1/table.Column))
			{
				run_class()	
			}
			if(conter<listCopye.length-1)
			{			
				conter++
				picKList()
			}			
		}

		private function resetConterRow():void
		{
			conterRow = 0
		}
		private function splitRow(Conter_p:int):int
		{
			return Conter_p%table.Column
		}
		///////////////////////////////////////////////////////////////////////////////////////////

		
		private function run_class()
		{
			
			var tableCoordinateLocation:Location = tableCoordinate(conter)
			var privateCellLocatoin:Location = 	listCopye[conter].LoacationCell
			switch(String(listCopye[conter].TypeCell.getType()))
			{
				case "[object Button]":
					listCopye[conter].TypeCell.ButtonType.setUp(tableCoordinateLocation,table.ColumnSpan,table.RowSpan,Fix(conter),listCopye[conter],conter)
					listCopye[conter].TypeCell.ButtonType.addEventListener(TableEvents.BUTTONS_TABLE,compeletButtons)
				break	
	
				case "[object InputText]":
					set_value_cell(listCopye[conter].TypeCell.InputTextType.setup(),conter,false)
					
					break	

				case "[object Paragraph]":
							
					set_value_cell(listCopye[conter].TypeCell.ParagraphType.getTextField(tableCoordinateLocation,table.ColumnSpan,table.RowSpan,Fix(conter),listCopye[conter]),conter)
					break	
				
				case "[object Pictrue]":
					listCopye[conter].TypeCell.PictrueType.load(tableCoordinateLocation,privateCellLocatoin,table.ColumnSpan,table.RowSpan,Fix(conter),conter)	
					listCopye[conter].TypeCell.PictrueType.addEventListener(TableEvents.PICTRUE_TALBE,compeletPictrue)
					break	
				
				case "[object RadioButtons]":
					set_value_cell(listCopye[conter].TypeCell.RadioButtonTaype.setUp(listCopye),conter,true)
						
					break	

				case "[object NumberRangeTable]":
					set_value_cell(listCopye[conter].TypeCell.NumberRagneType.setUp(),conter,false)		
					break	
				
				case "[object ChekBox]":
					set_value_cell(listCopye[conter].TypeCell.ChekBoxType.setUp(),conter,true)		
					break
			}
		}
		
		protected function compeletPictrue(event:TableEvents):void
		{
			
			set_value_cell( event.pictrue.bitmap,event.pictrue.Id)
			listCopye[event.pictrue.Id].TypeCell.PictrueType.removeEventListener(TableEvents.PICTRUE_TALBE,compeletPictrue)

		}
		
		protected function compeletButtons(event:TableEvents):void
		{
			
			set_value_cell(event.buttons.buttonMovie,event.buttons.Id,true)
			listCopye[event.buttons.Id].TypeCell.ButtonType.removeEventListener(TableEvents.BUTTONS_TABLE,compeletButtons)

		}
		
		/////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
		
		//////////////////////////////////////////////////////////////////////////////////////
		private function set_value_cell(addChild_p:*,Id_p,ButtonMode_p:Boolean = false):void
		{
			
			listCopye[Id_p].Movie = new MovieClip()
				
			listCopye[Id_p].BackGround = new MovieClip()	
			listCopye[Id_p].Movie.addChild(listCopye[Id_p].BackGround)
				
			var addChild:* = bitmap(addChild_p,listCopye[Id_p])
			
			
			listCopye[Id_p].Child = new MovieClip();	
			listCopye[Id_p].Child.addChild(addChild)
			listCopye[Id_p].Movie.addChild(listCopye[Id_p].Child)		
			
			target.addChild(listCopye[Id_p].Movie)
			listCopye[Id_p].ChildOjbect = addChild	
			listCopye[Id_p].Movie.visible = false
			if(ButtonMode_p)	
			{
				listCopye[Id_p].Movie.addEventListener(MouseEvent.CLICK,listCopye[Id_p].TypeCell.getType().CLICK)
					
				listCopye[Id_p].Movie.addEventListener(MouseEvent.MOUSE_DOWN,listCopye[Id_p].TypeCell.getType().DOWN)
					
				listCopye[Id_p].Movie.addEventListener(MouseEvent.MOUSE_UP,listCopye[Id_p].TypeCell.getType().UP)
		
					
				listCopye[Id_p].Movie.addEventListener(MouseEvent.MOUSE_OVER,listCopye[Id_p].TypeCell.getType().OVER)
					
				listCopye[Id_p].Movie.addEventListener(MouseEvent.MOUSE_OUT,listCopye[Id_p].TypeCell.getType().OUT)
					
				listCopye[Id_p].Movie.addEventListener(MouseEvent.RELEASE_OUTSIDE,listCopye[Id_p].TypeCell.getType().RELEASE_OUTSIDE)

			}	
			totalCell++

			if(totalCell == listCopye.length)
			{
				trace("End Of Current Part Table")		
				
				browsList(oldTotalCell,listCopye.length)
				scrol()
			}
			
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function browsList(OldTotalCell_p:int,TotalSpan_p:int):void
		{

			for(var i:int=OldTotalCell_p;i<=TotalSpan_p-1;i++)
			{
				
				var location:Location = set_location(i)
				var MovieRectangle:Rectangle = location.rectangle
					
				listCopye[i].Movie.x = MovieRectangle.x
				listCopye[i].Movie.y = MovieRectangle.y
				
				if(location.index!=-1)
				{
					target.setChildIndex(listCopye[i].Movie,location.index)
				}

					
				graphic(listCopye[i],MovieRectangle)
					
				var ChildRectangle:Rectangle = align(MovieRectangle,listCopye[i])
					
				if(!Fix(i))
				{
					var scrol:ScrollMT = new ScrollMT(listCopye[i].Child,new Rectangle(0,0,MovieRectangle.width,MovieRectangle.height),new Rectangle(0,0,ChildRectangle.width,ChildRectangle.height))
				}
				
				listCopye[i].Child.x = ChildRectangle.x
				listCopye[i].Child.y = ChildRectangle.y	
					
				view(listCopye[i])
				
			}
			this.dispatchEvent(new TableEvents(TableEvents.COMPELET_TABLE))
		}
		

		private function bitmap(addChild_p:*,Cell_p:Cell):*
		{
			var bitmapData:BitmapData = new BitmapData(addChild_p.width,addChild_p.height,true,0)
			bitmapData.draw(addChild_p);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			bitmap.smoothing = true ;
			
			bitmap.width = addChild_p.width
			if(table.BitmapTable && Cell_p.BitmapCell == null && String(addChild_p)!="[object Bitmap]")
			{
				return bitmap
			}
			else if(Cell_p.BitmapCell && String(addChild_p)!="[object Bitmap]")
			{
				return bitmap
			}
			
			return addChild_p
		}
		private function graphic(Cell_p:Cell,MovieRectangle_p:Rectangle):void
		{
			if(Cell_p.GraphicCell!=null)
			{
				Cell_p.BackGround.graphics.lineStyle(Cell_p.GraphicCell.stroke,Cell_p.GraphicCell.lineColor,Cell_p.GraphicCell.lineAlpha)	
				Cell_p.BackGround.graphics.beginFill(Cell_p.GraphicCell.backGroundColor,Cell_p.GraphicCell.backGroundAlpha)
				Cell_p.BackGround.graphics.drawRect(0,0,MovieRectangle_p.width,MovieRectangle_p.height)
				Cell_p.BackGround.visible = Cell_p.GraphicCell.visible
				Cell_p.BackGround.mouseEnabled = Cell_p.GraphicCell.enabled	
				Cell_p.BackGround.mouseChildren = Cell_p.GraphicCell.enabled	
			}
			else if(table.GraphicCell!=null)			
			{
				Cell_p.BackGround.graphics.lineStyle(table.GraphicCell.stroke,table.GraphicCell.lineColor,table.GraphicCell.lineAlpha)	
				Cell_p.BackGround.graphics.beginFill(table.GraphicCell.backGroundColor,table.GraphicCell.backGroundAlpha)
				Cell_p.BackGround.graphics.drawRect(0,0,MovieRectangle_p.width,MovieRectangle_p.height)
				Cell_p.BackGround.visible = table.GraphicCell.visible
				Cell_p.BackGround.mouseEnabled = table.GraphicCell.enabled
				Cell_p.BackGround.mouseChildren = table.GraphicCell.enabled
			}				
		}
		private function view(Cell_p:Cell):void
		{
			Cell_p.Movie.visible = true
			if(Cell_p.ViewCell!=null)
			{
				Cell_p.Movie.alpha = Cell_p.ViewCell.alpha
				Cell_p.Child.alpha = Cell_p.ViewCell.alphaChild	
				Cell_p.Movie.visible = Cell_p.ViewCell.visible
				Cell_p.Movie.mouseEnabled = Cell_p.ViewCell.enabled
				Cell_p.Movie.mouseChildren = Cell_p.ViewCell.enabled	

			}
			else if(table.ViewCell!=null)
			{
				Cell_p.Movie.alpha = table.ViewCell.alpha
				Cell_p.Child.alpha = table.ViewCell.alphaChild	
				Cell_p.Movie.visible = table.ViewCell.visible
				Cell_p.Movie.mouseEnabled = table.ViewCell.enabled
				Cell_p.Movie.mouseChildren = table.ViewCell.enabled	

			}
				
		}
		private function align(CellRectangle_p:Rectangle,Cell_p:Cell):Rectangle
		{								
			var Xaling:Number;
			var Yaling:Number;
			var Aling:String = table.AlignCell
			if(Cell_p.AlingCell!="")
			{
				Aling = Cell_p.AlingCell
			}
			switch(Aling)
			{
				
				case Align.LEFT_TOP:
					Xaling = 0
					Yaling = 0
					break				
				case Align.LEFT_CENTER:
					Xaling = 0
					Yaling = (CellRectangle_p.height/2)-(Cell_p.Child.height/2)
					break					
				case Align.LEFT_BUTTOM:	
					Xaling = 0
					Yaling = CellRectangle_p.height-Cell_p.Child.height
					break		
				case Align.RIGHT_TOP:
					Xaling = CellRectangle_p.width - Cell_p.Child.width
					Yaling = 0
					
					break
				case Align.RIGHT_CENTER:
					Xaling = CellRectangle_p.width - Cell_p.Child.width
					Yaling = (CellRectangle_p.height/2)-(Cell_p.Child.height/2)
					break	
				case Align.RIGHT_BUTTOM:
					Xaling = CellRectangle_p.width - Cell_p.Child.width
					Yaling = CellRectangle_p.height-Cell_p.Child.height
					break	
				case Align.CENTER:
					Xaling = (CellRectangle_p.width/2)-(Cell_p.Child.width/2)
					Yaling = (CellRectangle_p.height/2)-(Cell_p.Child.height/2)
					break	

				case Align.CENTER_TOP:	
					Xaling = (CellRectangle_p.width/2)-(Cell_p.Child.width/2)
					Yaling = 0
					break
				case Align.CENTER_BUTTOM:
					Xaling = (CellRectangle_p.width/2)-(Cell_p.Child.width/2)
					Yaling = CellRectangle_p.height-Cell_p.Child.height
					break	
			}	
			return new Rectangle(Xaling,Yaling,Cell_p.Child.width,Cell_p.Child.height)
		}
		private function Fix(Id_p:int):Boolean
		{		
			if(listCopye[Id_p].Fix!=null)
			{
				return listCopye[Id_p].Fix
			}
			return table.Fix	
		}
		private function set_location(Id_p:int):Location
		{
			var rectangle:Rectangle =  tableCoordinateMaxHeightRow(Id_p,table.ColumnSpan,table.RowSpan).rectangle
				
			var x:Number = rectangle.x
			var y:Number = rectangle.y
			var width:Number = rectangle.width
			var height:Number = rectangle.height	
	
				
			if(listCopye[Id_p].LoacationCell!=null)
			{
				var recCell:Rectangle = listCopye[Id_p].LoacationCell.rectangle
				var absolutX:Number = 0
				var absolutY:Number = 0	
				var index:int=-1; 	
				if(!listCopye[Id_p].Absolute)
				{
					absolutX = rectangle.x
					absolutY = rectangle.y	
					
				}
					
				if(!isNaN(recCell.x))
				{
					x = absolutX+recCell.x
				}
				if(!isNaN(recCell.y))
				{
					y = absolutY+recCell.y
				}
				if(!isNaN(recCell.width))
				{
					width = recCell.width
				}
				if(!isNaN(recCell.height))
				{
					height = recCell.height
				}	
				if(listCopye[Id_p].LoacationCell.index!=-1)
				{
					index = listCopye[Id_p].LoacationCell.index
				}
			}
			return new Location(new Rectangle(x,y,width,height),index,undefined)			
		}

	
		private function tableCoordinateMaxHeightRow(Id_p:int,ColumeSpan_p:Boolean,RowSpan_p:Boolean):Location
		{
			var DefaultRectangle :Rectangle = tableCoordinate(Id_p).rectangle
			var ColumnRectangle:Rectangle;
			var RowRectangle:Rectangle;
			var x:Number
			if(ColumeSpan_p)
			{
				ColumnRectangle = maXcolumn(Id_p)
			}
			else
			{
				ColumnRectangle = DefaultRectangle
			}
			
			if(RowSpan_p)
			{
				RowRectangle = maXrow(Id_p)
			}
			else
			{
				RowRectangle = DefaultRectangle
			}
				var rectangel:Rectangle = new Rectangle(ColumnRectangle.x,RowRectangle.y,ColumnRectangle.width,RowRectangle.height)
		
			return new Location(rectangel)			
		}
		
		
		
		private var rowHeight:Vector.<Cell> = new Vector.<Cell>()

		private var timerScrol:Timer;

	
		
		private function maXrow(Id_p):Rectangle
		{
					
			if(Id_p==0)
			{
				YmaxCell_array[maxRowConter]= table.LocationTable.rectangle.y	
			}	
			if(splitRow(Id_p)==0)
			{
				var cont:int = Id_p
				while((splitRow(cont)!=0 || cont==Id_p) && cont<=listCopye.length-1)
				{				
					rowHeight.push(listCopye[cont])
					cont++	
				}			
				rowHeight.sort(compareFunctionHight)
				Ymax_array.push(rowHeight[rowHeight.length-1].Movie.height)
				rowHeight = new Vector.<Cell>()	
				maxRowConter++	
				YmaxCell_array[maxRowConter]=Ymax_array[maxRowConter-1]+table.RowSpace+YmaxCell_array[maxRowConter-1]
			}	
			return new Rectangle(0,YmaxCell_array[maxRowConter-1],0,Ymax_array[maxRowConter-1])
		}
		
		
		
		
		
		private function maXcolumn(Id_p):Rectangle
		{
			if(Id_p<=table.Column-1)
			{
				var columnWidth:Vector.<Cell> = columCell(Id_p)				
				columnWidth.sort(compareFunction)
				XmaxCell_array.push(columnWidth[columnWidth.length-1].Movie.width)
				var columnX:Number
				
				if(table.DirectionTable== Direction.LEFT_TO_RIGHT_TOP_TO_BUTTOM || table.DirectionTable==Direction.LEFT_TO_RIGHT_BUTTOM_TO_TOP)
				{
					columnX =table.LocationTable.rectangle.left
				}
				else
				{
					columnX = (table.LocationTable.rectangle.right)-columnWidth[columnWidth.length-1].Movie.width
				}
				
				if(Id_p>0)
				{
					if(table.DirectionTable== Direction.LEFT_TO_RIGHT_TOP_TO_BUTTOM || table.DirectionTable==Direction.LEFT_TO_RIGHT_BUTTOM_TO_TOP)
					{
						columnX = XmaxCell_array[Id_p-1] + table.ColumnSpace+Xmax_array[Id_p-1] 
					}
					else
					{	
						columnX = Xmax_array[Id_p-1] - columnWidth[columnWidth.length-1].Movie.width - table.ColumnSpace
					}
				}		
				Xmax_array.push(columnX)
				
			}
			
			var XindexMax:int = Id_p-(Math.floor(Id_p/table.Column)*table.Column)	
			return  new Rectangle(Xmax_array[XindexMax],0,XmaxCell_array[XindexMax],0)

		}
		
		
		
		
		
		private function tableCoordinate(Id_p:int):Location
		{
			var x:Number;
			
			var cellWidth:Number = (table.LocationTable.rectangle.width-(table.ColumnSpace*(table.Column-1)))/table.Column
			
			if(table.DirectionTable== Direction.LEFT_TO_RIGHT_TOP_TO_BUTTOM || table.DirectionTable==Direction.LEFT_TO_RIGHT_BUTTOM_TO_TOP)
			{
				
				x = table.LocationTable.rectangle.left + ((Id_p%table.Column)*table.ColumnSpace)+((Id_p%table.Column)*cellWidth)
			}
			else
			{
				
				x = (table.LocationTable.rectangle.right-cellWidth) - (((Id_p%table.Column)*table.ColumnSpace)+((Id_p%table.Column)*cellWidth))
			}
			
			var y:Number;
			
			
			var cellHeight:Number = (table.LocationTable.rectangle.height-(table.RowSpace*(table.Row-1)))/table.Row
			
			var rowLevel:int = Math.floor(Id_p/table.Column)
			
			
			y = table.LocationTable.rectangle.top + (rowLevel*table.RowSpace)+(rowLevel*cellHeight)
			
			
			var tableRectangle:Rectangle = new Rectangle(x,y,cellWidth,cellHeight)	
			
			return new Location(tableRectangle)
		}	

		
		
		
		
		private  function compareFunction(A:Cell,B:Cell):Number
		{
			
			if(A.Movie.width<B.Movie.width)
			{
				return -1
			}
			else if(A.Movie.width>B.Movie.width)
			{
				return 1
			}
			else
			{
				return  0
			}			
		}		
		private  function compareFunctionHight(A:Cell,B:Cell):Number
		{
			
			if(A.Movie.height<B.Movie.height)
			{
				return -1
			}
			else if(A.Movie.height>B.Movie.height)
			{
				return 1
			}
			else
			{
				return  0
			}			
		}		

		
		
		
		private function columCell(Id_p:int):Vector.<Cell>
		{
			var cont:int = 0
			var clumList:Vector.<Cell> = new Vector.<Cell>()	
				
			var totalCont:int;
			totalCont = conterRow
			var chekLength:int=0;
			while(cont<=totalCont)
			{	
				var columnId:int = (cont*table.Column)+Id_p
				if(columnId>listCopye.length-1)return clumList
				clumList.push(listCopye[columnId])
				cont++					
			}
			return clumList
		}
		///////////////////////////////////////////////////////////////////////////
		private function scrol():void
		{
			
			var scrolDirection:Number=0;
			var setAbsolutePose:Boolean = false
				
			var widthRangScrol:Number = _target.width;
			var heightRangScrol:Number = _target.height;
			if(_target.width<table.LocationTable.rectangle.width)
			{
				widthRangScrol = table.LocationTable.rectangle.width	
			}
			if(heightRangScrol<table.LocationTable.rectangle.height)
			{
				heightRangScrol = table.LocationTable.rectangle.height
			}
			if(table.DirectionTable == Direction.RIGHT_TO_LEFT_TOP_TO_BUTTOM || table.DirectionTable == Direction.RIGHT_TO_LELFT_BUTTOM_TO_TOP)
			{	
				if(_target.width>table.LocationTable.rectangle.width)
				{
					scrolDirection = table.LocationTable.rectangle.width - _target.width
				}
			}
			var targetRectangle:Rectangle;
			if(!table.ColumnSpan && !table.RowSpan)
			{
				targetRectangle = table.LocationTable.rectangle
			}
			else if(!table.ColumnSpan && table.RowSpan)
			{
				targetRectangle = new Rectangle(0,0,table.LocationTable.rectangle.width,heightRangScrol)
				
			}
			else if(table.ColumnSpan && !table.RowSpan)
			{
				targetRectangle = new Rectangle(scrolDirection,0,widthRangScrol,table.LocationTable.rectangle.height)
				setAbsolutePose = true	
			}
			else if(table.ColumnSpan && table.RowSpan)
			{
				// badan dorostesh mikonam
				targetRectangle = new Rectangle(scrolDirection,0,widthRangScrol,heightRangScrol)
				setAbsolutePose = true	
			}
			
			
			var y = target.y

			scrol2 = new ScrollMT(_target,table.LocationTable.rectangle,targetRectangle,true)

			if((table.DirectionTable == Direction.RIGHT_TO_LEFT_TOP_TO_BUTTOM || table.DirectionTable == Direction.RIGHT_TO_LELFT_BUTTOM_TO_TOP) && setAbsolutePose)
			{
				scrol2.setAbsolutePose(scrolDirection+x,y)
			}
			else
			{
				scrol2.setAbsolutePose(x,y)
			}
			timerScrol = new Timer(10)
			timerScrol.addEventListener(TimerEvent.TIMER,chekEndScrol)
			timerScrol.start()
			graphicTable(new Rectangle(target.x,target.y,widthRangScrol,heightRangScrol))	

		}
		
		public function lockScrol():void
		{
			scrol2.lock()
		}
		public function unLockScrol():void
		{
			scrol2.unLock()
		}
		public function resetScrol():void
		{
			scrol2.reset()
		}
		protected function chekEndScrol(event:TimerEvent):void
		{
			var heightDif:Number = 	table.LocationTable.rectangle.height-target.height
			if(_target.y<=heightDif-scrolRangUpdate)
			{
				stopScrolTimer()
				this.dispatchEvent(new TableEvents(TableEvents.UPDATE_TABLE))
			}
		}		
		
		private function stopScrolTimer():void
		{
			if(timerScrol!=null)
			{
				timerScrol.stop()
				timerScrol.removeEventListener(TimerEvent.TIMER,chekEndScrol)	
			}
		}
		////////////////////////////////////////////////////////////////
		public function unLoad():void
		{
			stopScrolTimer()
			deletItem()	
			_list = new Vector.<Cell>()
			listCopye = new Vector.<Cell>()
			_target.graphics.clear()	
		}
		public function reset():void
		{
			deletItem()
			setValue()
		}
		private function deletItem():void
		{
			for(var index:int=0;index<=listCopye.length-1;index++)
			{
				if(listCopye[index].Movie!=null)
				{
					target.removeChild(listCopye[index].Movie)
				}		
			}
		}
		private function setValue():void
		{
			conter = 0
			conterRow=0
			maxRowConter = 0
			totalCell = 0
			oldTotalCell = 0
			rowSpanOk = true
			Xmax_array = new Array()
			XmaxCell_array	= new Array()
			Ymax_array = new Array()
			YmaxCell_array = new Array()
		}
	}
	
}