package contents.alert
{
	import flash.display.Stage;
	import flash.media.StageWebView;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Alert
	{
		private static var sw:StageWebView ;
		
		private static var 	debugField1:TextField;

		public function Alert(...val)
		{
			Alert.show(val);
		}
		
		public static function show(...param):void
		{
            var title:String = param.join(',');
			setUp();
			trace("Alert:"+title);
			if(debugField1!=null)
			{
				debugField1.appendText(title+'\n');
				
				
				debugField1.scrollV++;
			
			}
			else
			{
				sw.loadURL("javascript:alert(\""+title.split('\n').join('').split('\r').join('').split('\\').join('\\\\').split('"').join('\\"')+"\");")
			}
		}
		
		public static function vibrate(duration:uint=1000):void
		{
            sw.loadURL("javascript:navigator.vibrate("+duration+");")
		}
		
		public static function vibratePuls():void
		{
            vibrate(100);
		}
		
		/**Create the sw for allerts*/
		private static function setUp():void	
		{
			if(sw==null)
				sw = new StageWebView();
		}
		
		/**Set Screen debugger instead on Alert*/
		public static function setScreenDebugger(stage:Stage):void
		{
			debugField1 = new TextField();
			
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 18;
			
			debugField1.width = stage.stageWidth ;
			debugField1.height = stage.stageHeight ;
			
			
			debugField1.textColor = 0xFF0000 ;
			
			
			
			debugField1.defaultTextFormat = textFormat;
			
			
			debugField1.x = 1;
			debugField1.y = 1;
			
			
			debugField1.mouseEnabled = false ;
			
			stage.addChild(debugField1);
		}
	}
}