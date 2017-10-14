package appManager.displayContent
	//appManager.displayContent.SliderBoolets
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class SliderBoolets extends MovieClip
	{
		private var myConfig:SliderBooletSetting ;
		
		public function SliderBoolets(config:SliderBooletSetting)
		{
			super();
			
			myConfig = config ;
			
			myConfig.sliderGallery.addEventListener(Event.CHANGE,updateInterface);
			updateInterface(null);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		protected function unLoad(event:Event):void
		{
			myConfig.sliderGallery.removeEventListener(Event.CHANGE,updateInterface);
		}
		
		protected function updateInterface(event:Event):void
		{
			drawInterface(myConfig.sliderGallery.totalImages(),myConfig.sliderGallery.currentImageIndex);
		}
		
		private function drawInterface(total:uint,currect:uint):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,myConfig.color);
			
			var x0:Number;
			if(myConfig.rtl)
			{
				x0 = (myConfig.booletW*total+myConfig.booletMargin*(total-1))/2;
			}
			else
			{
				x0 = (myConfig.booletW*total+myConfig.booletMargin*(total-1))/-2;
			}
			
			for(var i:int = 0 ; i<total ; i++)
			{
				if(currect==i)
				{
					this.graphics.beginFill(myConfig.color,1);
				}
				else
				{
					this.graphics.beginFill(myConfig.color,0);
				}
				if(myConfig.rtl)
				{
					this.graphics.drawCircle(x0-myConfig.booletW,-myConfig.booletW/2-myConfig.booletMargin,myConfig.booletW/2);
					x0-=(myConfig.booletW+myConfig.booletMargin) ;
				}
				else
				{
					this.graphics.drawCircle(x0+myConfig.booletW,-myConfig.booletW/2-myConfig.booletMargin,myConfig.booletW/2);
					x0+=(myConfig.booletW+myConfig.booletMargin) ;
				}
			}
		}
	}
}