package diagrams.dataGrid
	//diagrams.dataGrid.DataGrid
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import contents.alert.Alert;
	
	public class DataGrid extends Sprite
	{
		internal var Wparts:uint,Hparts:uint ;
		
		internal var Width:Number,Height:Number;
		

		private var Dw:Number,Dh:Number;
		
		private var matrix:Vector.<Boolean> ;
		
		private var	backGroundTexture:BitmapData ;
		private var backGroundBitmap:Bitmap ;
		private var temp:Array = new Array();
		
		public function DataGrid(Wparts:uint,Hparts:uint,Width:Number=10,Height:Number=10,backgroundColor:int=-1,lineColor:int=-1,body:DisplayObject=null)
		{
			super();
			
			backGroundTexture = new BitmapData(Width,Height,backgroundColor==-1,backgroundColor==-1?0x00000000:backgroundColor);
			backGroundBitmap = new Bitmap(backGroundTexture);
			this.addChild(backGroundBitmap);
			
			matrix = new Vector.<Boolean>(Wparts*Hparts);
			
			if(backgroundColor==-1)
				this.graphics.beginFill(backgroundColor,0);
			else
				this.graphics.beginFill(backgroundColor);
			
			if(lineColor!=-1)
			{
				this.graphics.lineStyle(0,lineColor);
			}
			
			this.graphics.drawRect(0,0,Width,Height);
			
			backGroundTexture.lock();
			backGroundTexture.draw(this);
			backGroundTexture.unlock();
			this.graphics.clear();
			
			this.Width = Width ;
			this.Height = Height ;
			
			this.Wparts = Wparts ;
			this.Hparts = Hparts ;
			
			this.Dw = Width/Wparts ;
			this.Dh = Height/Hparts ;
			
			temp = [];
			if(body!=null)
			{
				addContent(body)
			}
			
		}

		public function reverseLevelDataGrid():void
		{
			for(var j:int = temp.length-1;j>=0;j--)
			{
				this.addChild(temp[j]);
			}
		}
		
		public function addContent(body:DisplayObject, X:int=0, Y:int=0, Wp:int=0, Hp:int=0,borderColor:int=-1,backgroundColor:int=-1,borderThickness:uint=0):void
		{
			if(body is DataGrid)
			{
				Wp = (body as DataGrid).Wparts ;
				Hp = (body as DataGrid).Hparts ;
			}
			if(Wp==0)
				Wp = this.Wparts ;
			if(Hp==0)
				Hp = this.Hparts ;
			
			while(!isPartEmpty(X,Y,Wp,Hp))
			{
				if(X+Wp<Wparts)
				{
					X++;
				}
				else
				{
					X = 0 ;
					if(Y+Hp<Hparts)
					{
						Y++;
					}
					else
					{
						trace("Cannot add this item to the stage");
						return ;
						break;
					}
				}
			}
			
			makeItFull(X,Y,Wp,Hp);
			
			if(body)
			{
				body.x = X*Dw;
				body.y = Y*Dh;
				body.width = Wp*Dw ;
				body.height = Hp*Dh ;
				temp.push(body);
				this.addChild(body);
			}
			
			
			if(backgroundColor!=-1)
				this.graphics.beginFill(backgroundColor);
			
			if(borderColor!=-1)
				this.graphics.lineStyle(borderThickness,borderColor);
			
			if(backgroundColor!=-1 || borderColor!=-1)
				this.graphics.drawRect(X*Dw,Y*Dh,Wp*Dw,Hp*Dh);
			
			backGroundTexture.lock();
			var visibleCash:Vector.<Boolean> = new Vector.<Boolean>();
			for(var i:int = 0 ; i<this.numChildren ; i++)
			{
				visibleCash.push(this.getChildAt(i).visible);
				this.getChildAt(i).visible = false ;
			}
			backGroundTexture.draw(this);
			for(i = 0 ; i<this.numChildren ; i++)
			{
				this.getChildAt(i).visible = visibleCash[i] ;
			}
			backGroundTexture.unlock();
			this.graphics.clear();
		}
		
//////////////////////////////////////////////////////////////////////
		/**Returns true if this part was empty*/
		private function isPartEmpty(X:uint,Y:uint,W:uint,H:uint):Boolean
		{
			for(var i:int = 0 ; i<W ; i++)
			{
				for(var j:int = 0 ; j<H ; j++)
				{
					if(!isEmpry(X+i,Y+j))
					{
						return false ;
					}
				}
			}
			return true ;
		}
		
		/**Returns true if this point was empry*/
		private function isEmpry(X:uint,Y:uint):Boolean
		{
			if(X>=Wparts)
			{
				return false ;
			}
			if(Y>=Hparts)
			{
				return false ;
			}
			return !matrix[Y*Wparts+X] ;
		}
		
		private function fullThisPart(X:uint,Y:uint):void
		{
			matrix[Y*Wparts+X] = true ;
		}
		
		private function makeItFull(X:uint,Y:uint,W:uint,H:uint):void
		{
			for(var i:int = 0 ; i<W ; i++)
			{
				for(var j:int = 0 ; j<H ; j++)
				{
					fullThisPart(X+i,Y+j);
				}
			}
		}
	}
}