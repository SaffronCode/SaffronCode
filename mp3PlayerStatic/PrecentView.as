package mp3PlayerStatic
{//mp3PlayerStatic.PrecentView
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class PrecentView extends MovieClip
	{
		private var precentTF:TextField ;
		public function PrecentView()
		{
			super();
			precentTF = Obj.get("precent_txt",this);
			setPrecentViewText(0)

			this.mouseEnabled = false
			this.mouseChildren = false
			this.addEventListener(Event.ENTER_FRAME,cheker)	
			this.addEventListener(Event.REMOVED_FROM_STAGE,unload)
		}
		
		protected function unload(event:Event):void
		{
			// TODO Auto-generated method stub
			if(MediaPlayerStatic.evt!=null)
			{
				MediaPlayerStatic.evt.removeEventListener(MediaPlayerEventStatic.DOWNLOAD_PRECENT,showPrecent)	
			}
			this.removeEventListener(Event.ENTER_FRAME,cheker)	
		}
		
		protected function cheker(event:Event):void
		{
			// TODO Auto-generated method stub
			if(MediaPlayerStatic.evt!=null)
			{	
				setPrecentViewText(0)
				MediaPlayerStatic.evt.addEventListener(MediaPlayerEventStatic.DOWNLOAD_PRECENT,showPrecent)	
				this.removeEventListener(Event.ENTER_FRAME,cheker)		
			}
		}
		protected function showPrecent(event:MediaPlayerEventStatic):void
		{
			// TODO Auto-generated method stub
			setPrecentViewText(event.downloadPrecent)
		}
		
		private function setPrecentViewText(Precent_p:Number):void
		{
			if(Precent_p==0)
			{
				this.visible = false
			}
			else
			{
				this.visible = true
			}
			
			if(precentTF!=null)
			{
				precentTF.text = Precent_p + '%'
			}
			
			if(Precent_p == 100)
			{
				precentTF.text =''
			}
			
			this.gotoAndStop(Precent_p)
			
		}
	}
}