package tableManager.graphic
{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import tableManager.data.Type;

	public class Cell
	{
		public var	Id:int,
					AlingCell:String="",
					Absolute:Boolean = false,
					LoacationCell:Location=null,
					BitmapCell:*=null,
					Fix:*=null,
					ViewCell:View=null,
					GraphicCell:Graphic=null,
					Movie:MovieClip,
					Child:MovieClip,
					BackGround:MovieClip,
					ChildOjbect:*,
					TypeCell:Type = new Type();							
		public function Cell()
		{
		}
	}
}