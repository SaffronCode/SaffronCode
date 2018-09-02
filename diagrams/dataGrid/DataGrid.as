package diagrams.dataGrid
	//diagrams.dataGrid.DataGrid
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class DataGrid extends Sprite
	{
		internal var Wparts:uint,Hparts:uint ;
		
		internal var Width:Number,Height:Number;
		

		private var Dw:Number,Dh:Number;
		
		
		public function DataGrid(Wparts:uint,Hparts:uint,Width:Number,Height:Number,backgroundColor:int=-1,lineColor:int=-1,body:DisplayObject=null)
		{
			super();
			
			if(backgroundColor==-1)
				this.graphics.beginFill(backgroundColor,0);
			else
				this.graphics.beginFill(backgroundColor);
			
			if(lineColor!=-1)
			{
				this.graphics.lineStyle(0,lineColor);
			}
			
			this.graphics.drawRect(0,0,Width,Height);
			
			this.Width = Width ;
			this.Height = Height ;
			
			this.Wparts = Wparts ;
			this.Hparts = Hparts ;
			
			this.Dw = Width/Wparts ;
			this.Dh = Height/Hparts ;
			
			if(body!=null)
			{
				addContent(body)
			}
		}
		
		public function addContent(body:DisplayObject, X:int=0, Y:int=0, Wp:int=0, Hp:int=0):void
		{
			this.addChild(body);
			if(body is DataGrid)
			{
				Wp = (body as DataGrid).Wparts ;
				Hp = (body as DataGrid).Hparts ;
			}
			if(Wp==0)
				Wp = this.Wparts ;
			if(Hp==0)
				Hp = this.Hparts ;
			
			body.x = X*Dw;
			body.y = Y*Dh;
			body.width = Wp*Dw ;
			body.height = Hp*Dh ;
		}
	}
}