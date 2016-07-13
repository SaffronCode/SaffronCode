package darkBox
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import netManager.urlSaver.URLSaver;
	import netManager.urlSaver.URLSaverEvent;
	
	[Event(name="LOADING", type="netManager.urlSaver.URLSaverEvent")]
	[Event(name="NO_INTERNET", type="netManager.urlSaver.URLSaverEvent")]
	[Event(name="LOAD_COMPLETE", type="netManager.urlSaver.URLSaverEvent")]
	public class ImageFile extends EventDispatcher
	{
		public static const TYPE_FLAT:int = 1,
							TYPE_PANORAMA:int = 2,
							TYPE_SPHERE:int = 3,
							TYPE_VIDEO:int = 4,
							TYPE_PDF:int = 5,
							TYPE_BINARY:int = 6;
		/**Uses to catch offline file*/
		private var saver:URLSaver ;
		
		
		/**Uses when the application has to store offline file*/
		private var onlineTarget:String,
					offlineTarget:String;
		
		/**File url*/
		public var target:String;
		
		/**Image title*/
		public var title:String;
		
		/**TYPE_FLAT:int = 1,
							TYPE_PANORAMA:int = 2,
							TYPE_SPHERE:int = 3,
							TYPE_VIDEO:int = 4
							TYPE_PDF:int = 5*/
		public var type:int ;
		
		/**You have to save this file for offline usage*/
		public var storeOffline:Boolean;
		
		private var timeOutId:uint;
		
		public var targetBytes:ByteArray ;
		
		public function get fullTitle():String
		{
			var end:String ='';
			if(type!=TYPE_BINARY && type!=TYPE_PDF)
			{
				end = '.jpg';
			}
			if(title!='')
			{
				return title+end ;
			}
			else
			{
				return onlineTarget.substr(onlineTarget.lastIndexOf('/')+1)+end;
			}
		}
		
		/**TYPE_FLAT:int = 1,
							TYPE_PANORAMA:int = 2,
							TYPE_SPHERE:int = 3,
							TYPE_VIDEO:int = 4
							TYPE_PDF:int = 5
		 * 
		 * @see darkBox.ImageFile*/
		public function ImageFile(Target:String='',Title:String='',Type:int=0,StoreOffline:Boolean=true)
		{
			target = Target ;
			title = Title ;
			type = Type ;
			if(type == TYPE_PDF)
			{
				storeOffline = true ;
			}
			else
			{
				storeOffline = StoreOffline ;
			}
		}
		
		public function download(timeOut:uint=0):void
		{
			onlineTarget = target ;
			if(timeOut>0)
			{
				clearTimeout(timeOutId);
				timeOutId = setTimeout(startDownload,timeOut);
			}
			else
			{
				startDownload();
			}
		}
		
		private function startDownload():void
		{
			if(onlineTarget=='')
			{
				trace("NO File selected");
				return ;
			}
			if(offlineTarget==null)
			{
				trace("Start donwload the image");
				saver = new URLSaver();
				saver.addEventListener(URLSaverEvent.LOAD_COMPLETE,onImageFileSaved);
				saver.addEventListener(URLSaverEvent.NO_INTERNET,noNet);
				saver.addEventListener(URLSaverEvent.LOADING,loadingProcess);
				
				var extention:String ;
				var fileName:String ;
				if(type == TYPE_PDF)
				{
					extention = ".pdf";
					fileName = title ;
				}
				
				saver.load(onlineTarget,null,extention,fileName);
			}
			else
			{
				trace("Image is donwloaded befor");
				onImageFileSaved(null,offlineTarget);
			}
		}
		
		/**This will delete the temprary file*/
		public function deleteFile():void
		{
			cansel();
			if(onlineTarget!=null && onlineTarget!='')
			{
				saver.deletFileIfExists(onlineTarget);
			}
		}
		
		protected function loadingProcess(event:URLSaverEvent):void
		{
			// TODO Auto-generated method stub
			this.dispatchEvent(new URLSaverEvent(event.type,event.precent));
		}
		
		protected function noNet(event:URLSaverEvent):void
		{
			// TODO Auto-generated method stub
			this.dispatchEvent(new URLSaverEvent(event.type,event.precent));
		}
		
		protected function onImageFileSaved(event:URLSaverEvent=null,downloadedFileTarget:String=null):void
		{
			// TODO Auto-generated method stub
			if(event!=null)
			{
				target = event.offlineTarget;
				targetBytes = event.loadedBytes ;
			}
			else
			{
				target = downloadedFileTarget ;
				//The targetBytes had to saved once
			}
			offlineTarget = target ;
			
			//Be carefull, update target befor dispatchig below event
			trace("offline image target is : "+offlineTarget);
			this.dispatchEvent(new URLSaverEvent(URLSaverEvent.LOAD_COMPLETE,1));
		}
		
		/**cansel downloading*/
		public function cansel():void
		{
			clearTimeout(timeOutId);
			if(saver)
			{
				saver.cansel()
			}
		}
	}
}