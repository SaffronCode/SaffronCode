package tableManager.graphic
{
	import flash.geom.Rectangle;

	public class Table
	{
		/**get specifications table*/
		public var	Id:int,
					Column:int,
					ColumnSpace:int,
					Row:int,
					RowSpace:int,
					RowSpan:Boolean=false,
					ColumnSpan:Boolean = false,	
					LocationTable:Location=null,
					AlignCell:String="",
					DirectionTable:String,
					Fix:Boolean=false,
					BitmapTable:Boolean = false,
					ViewCell:View=null,
					GraphicCell:Graphic=null,
					GraphicTable:Graphic= new Graphic(0,0,0,0,0)
		public function Table()
		{
		}
	}
}