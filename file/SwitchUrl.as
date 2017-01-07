package file
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	
	

	public class SwitchUrl extends MovieClip
	{
		[Event(name="SWITCH_URL",type="file.SwitchUrlEvent")]
		[Event(name="SWITCH_ERROR_WRITE",type="file.SwitchUrlEvent")]
		[Event(name="SWITCH_ERROR_DOWNLOAD",type="file.SwitchUrlEvent")]
		[Event(name="SWITCH_DOWNLOAD_PRECENT",type="file.SwitchUrlEvent")]
		private var _file:File;
		public function get file():File
		{
			return _file
		}
		private var _path:String;
		private var _fileName:String;
		
		private var _changeDownLoadPrecent:int;
		
		public function switcH(Path_p:String,FileName_p:String,Url_p:String=''):Boolean
		{
			_path = Path_p
			_fileName = FileName_p	
			_file = File.applicationDirectory.resolvePath(Path_p+FileName_p)
			if(_file.exists)
			{
				downLoadPrecent(100,100)
				this.dispatchEvent(new SwitchUrlEvent(SwitchUrlEvent.SWITCH_URL,this))
				return false
			}
			_file = File.applicationStorageDirectory.resolvePath(Path_p+FileName_p)
			if(_file.exists)
			{
				downLoadPrecent(100,100)
				this.dispatchEvent(new SwitchUrlEvent(SwitchUrlEvent.SWITCH_URL,this))
				return false
			}
			if(Url_p!='')
			{
				download(Url_p)		
			}		
			return true
		}
		
		private function download(Url_p:String):void
		{
			

			var _urlLodaer:URLLoader = new URLLoader()
			_urlLodaer.addEventListener(Event.COMPLETE,complete_fun)
			_urlLodaer.addEventListener(IOErrorEvent.IO_ERROR,IO_ERROR_fun)
			_urlLodaer.addEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERROR_fun)
			_urlLodaer.addEventListener(ProgressEvent.PROGRESS,PROGRESS_fun)	
			_urlLodaer.dataFormat = URLLoaderDataFormat.BINARY
			var _urlRequest:URLRequest = new URLRequest(Url_p)	
			_urlLodaer.load(_urlRequest)
		}	
		
		protected function PROGRESS_fun(event:ProgressEvent):void
		{
			
			downLoadPrecent(event.bytesLoaded,event.bytesTotal)
		}
		
		protected function SECURITY_ERROR_fun(event:SecurityErrorEvent):void
		{
			
			this.dispatchEvent(new SwitchUrlEvent(SwitchUrlEvent.SWITCH_ERROR_DOWNLOAD,null,event.text))
		}
		
		protected function IO_ERROR_fun(event:IOErrorEvent):void
		{
			
			this.dispatchEvent(new SwitchUrlEvent(SwitchUrlEvent.SWITCH_ERROR_DOWNLOAD,null,event.text))
		}
		protected function complete_fun(event:Event):void
		{
			
			_file = CheckExistsPaht.check(_path,_fileName)
			var errorMessage:String = Read_Write.write(_file,event.target.data)
			if(errorMessage =='')
			{
				this.dispatchEvent(new SwitchUrlEvent(SwitchUrlEvent.SWITCH_URL,this))
			}
			else
			{
				this.dispatchEvent(new SwitchUrlEvent(SwitchUrlEvent.SWITCH_ERROR_WRITE,null,errorMessage))
			}
		}
		private function downLoadPrecent(Bytesloaded_p:Number,TotalBytes_p:Number):void
		{
			var _downLoadPrecent:int = Math.round((Bytesloaded_p*100)/TotalBytes_p)
			if(_changeDownLoadPrecent != _downLoadPrecent)
			{
				this.dispatchEvent(new SwitchUrlEvent(SwitchUrlEvent.SWITCH_DOWNLOAD_PRECENT,null,'',_downLoadPrecent))	
			}
			_changeDownLoadPrecent = _downLoadPrecent
		}
	}
}