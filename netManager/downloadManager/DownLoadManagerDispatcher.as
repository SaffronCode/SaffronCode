// *************************
// * COPYRIGHT
// * DEVELOPER: MTEAM ( info@mteamapp.com )
// * ALL RIGHTS RESERVED FOR MTEAM
// * YOU CAN'T USE THIS CODE IN ANY OTHER SOFTWARE FOR ANY PURPOSE
// * YOU CAN'T SHARE THIS CODE
// *************************

package netManager.downloadManager
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Event(name="downloadComplete", type="com.mteamapp.downloadManager.DownloadManagerEvents")]
	[Event(name="downloadProgress", type="com.mteamapp.downloadManager.DownloadManagerEvents")]
	[Event(name="urlIsNotExists", type="com.mteamapp.downloadManager.DownloadManagerEvents")]
	
	public class DownLoadManagerDispatcher extends EventDispatcher
	{
		public function DownLoadManagerDispatcher()
		{
			super();
		}
	}
}