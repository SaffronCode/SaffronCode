package darkBox
{
	import videoPlayer.myVideoPlayer;

	public class VideoImage extends DefaultImage
	{
		private var videoPlayerMC:myVideoPlayer ;
		
		public function VideoImage()
		{
			super();
			
			videoPlayerMC = Obj.findThisClass(myVideoPlayer,this);
		}
		
		override public function show(target:String=''):void
		{
			super.show();
			
			try
			{
				this.removeChild(videoPlayerMC);
			}catch(e){};
			
			videoPlayerMC = new myVideoPlayer();
			this.addChild(videoPlayerMC);
			
			videoPlayerMC.width = rect.width;
			videoPlayerMC.height = rect.height;
			videoPlayerMC.scaleX = videoPlayerMC.scaleY = Math.min(videoPlayerMC.scaleX,videoPlayerMC.scaleY);
			videoPlayerMC.x = (rect.width-videoPlayerMC.width)/2;
			videoPlayerMC.y = (rect.height-videoPlayerMC.height)/2;
			
			
			myVideoPlayer.playeMyVideo(target);
		}
		
		override public function hide():void
		{
			super.hide();
			try
			{
				myVideoPlayer.close();
				this.removeChild(videoPlayerMC);
			}catch(e){};
		}
	}
}