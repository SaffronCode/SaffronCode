package rtmp
{//rtmp.RtmpPlayer
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import videoShow.VideoClassRTMP;
	
	public class RtmpPlayer extends MovieClip
	{
		private static var ME:RtmpPlayer;
		private var closePlayerMc:MovieClip;
		private var playerMc:MovieClip;
		private var vid:VideoClassRTMP;
		public function RtmpPlayer()
		{
			super();
			ME = this;
			closePlayerMc = Obj.get('closePlayer_mc',this);
			closePlayerMc.addEventListener(MouseEvent.CLICK,closeVideo);
			playerMc = Obj.get('player_mc',this);
		}
		
		public static function setup(Width:Number,Height:Number):void
		{
			ME.vid =  new VideoClassRTMP(Width,Height)
			ME.visible = false;	
		}
		public static function show(rtmp:String):void
		{
			ME.visible = true
			ME.playerMc.addChild(ME.vid)
			ME.vid.load(rtmp);
		}
		protected function closeVideo(event:MouseEvent=null):void
		{
			// TODO Auto-generated method stub
			this.visible = false;
			if(vid!=null)
			{
				vid.close();
				playerMc.removeChild(vid)
			}
		}
	}

}