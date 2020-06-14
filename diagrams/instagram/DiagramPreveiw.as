package diagrams.instagram
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class DiagramPreveiw extends MovieClip
	{
		protected var Width:Number ;
		
		protected var Height:Number ;
		
		/**Minimom and maximom values of vertical datas*/
		protected var titleDetail:InstagramTitles ;
		
		protected var Ys:Array ;
		
		protected var color:uint;
		
		protected var myDiagramVals:InstagramData ;
		
		protected var mytitleData:InstagramTitles ;

		protected var minVNumber:Number;

		protected var maxVNumber:Number;

		protected var hTitles:uint;
		
		
		private var cilcles:Vector.<DiagramValueInterface> ;
		
		public function DiagramPreveiw(diagramValues:InstagramData,W:Number,H:Number,titleData:InstagramTitles)
		{
			super();
			mytitleData = titleData ;
			myDiagramVals = diagramValues ;
			
			Width = W ;
			Height = H ;
			
			titleDetail = titleData ;
			
			/*this.graphics.beginFill(diagramValues.color);
			this.graphics.drawRect(0,0,W,H);*/
			
			minVNumber = titleData.vTitle[0].value ;
			maxVNumber = titleData.vTitle[titleData.vTitle.length-1].value ;
			
			hTitles = titleData.hTitle.length ;
			
			setUp();
		}
		
		public function setUp()
		{
			color = myDiagramVals.color ;
			
			this.graphics.lineStyle(InstagramConstants.Diagram_line_thickness,color);
			
			cilcles = new Vector.<DiagramValueInterface>();
			Ys = [] ;
			
			for(var i = 0 ; i<myDiagramVals.values.length ; i++)
			{
				var currentVal:InstaDataValue = myDiagramVals.values[i] ;
				var circleMC:DiagramValueInterface = new DiagramValueInterface(color);
				cilcles.push(circleMC);
				this.addChild(circleMC);
				for(var j = 0 ; j<hTitles && currentVal.Hval>mytitleData.hTitle[j].value ; j++){}
				circleMC.x = (j/(hTitles-1))*Width ;
				//Ys[i] = Height-(precent(currentVal.Vval,minVNumber,maxVNumber)*Height);
				circleMC.y = Height ;
				
				/*if(i == 0)
				{
				this.graphics.moveTo(circleMC.x,circleMC.y);
				}
				else
				{
				this.graphics.lineTo(circleMC.x,circleMC.y);
				}*/
			}
			this.graphics.endFill();
			
			changeYs()
			
			anim();
			
			this.addEventListener(Event.ENTER_FRAME,anim);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		public function changeYs()
		{
			for(var i = 0 ; i<myDiagramVals.values.length ; i++)
			{
				var currentVal:InstaDataValue = myDiagramVals.values[i] ;
				Ys[i] = Height-(precent(currentVal.Vval,minVNumber,maxVNumber)*Height);
				
				cilcles[i].setTitle(myDiagramVals.values[i].name.toString());
			}
		}
		
		public function get id():uint
		{
			return myDiagramVals.id ;
		}
		
		public function changeVals(newValues:InstagramData)
		{
			myDiagramVals = newValues ;
			SaffronLogger.log("Change the diagram interface");
			changeYs();
		}
		
		protected function anim(event:Event=null):void
		{
			
			this.graphics.clear();
			if(cilcles.length == 0)
			{
				return ;
			}
			
			this.graphics.lineStyle(InstagramConstants.Diagram_line_thickness,color);
			for(var i = 0 ; i<cilcles.length ; i++)
			{
				cilcles[i].y += (Ys[i]-cilcles[i].y)/InstagramConstants.Diagram_speed ;
				
				if(i == 0)
				{
					this.graphics.moveTo(cilcles[i].x,cilcles[i].y);
				}
				else
				{
					this.graphics.lineTo(cilcles[i].x,cilcles[i].y);
				}
			}
			this.graphics.endFill();
			/*i--;
			//Do not delete enter_frame to animate diagram on its data changed.
			if( Math.abs( cilcles[i].y - Ys[i] ) < 1 )
			{
				for(i = 0 ; i<cilcles.length ; i++)
				{
					cilcles[i].y = Ys[i] ;
				}
				unLoad(null);
			}*/
		}
		
		protected function unLoad(event:Event):void
		{
			
			this.removeEventListener(Event.ENTER_FRAME,anim);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		private function precent(val:Number,min:Number,max:Number)
		{
			return Math.max(0,Math.min(1,(val-min)/(max-min)));
		}
	}
}