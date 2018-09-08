package contents.alert
{
	import flash.media.StageWebView;

	public class Alert
	{
		private static var sw:StageWebView ;

		public function Alert(...val)
		{
			Alert.show(val);
		}
		
		public static function show(...param):void
		{
            var title:String = param.join(',');
			setUp();
			trace("Alert:"+title);
			sw.loadURL("javascript:alert(\""+title.split('\n').join('').split('\r').join('').split('\\').join('\\\\').split('"').join('\\"')+"\");")
		}
		
		/**Create the sw for allerts*/
		private static function setUp():void	
		{
			if(sw==null)
				sw = new StageWebView();
		}
	}
}