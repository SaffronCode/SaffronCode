package contents.alert
{
	import flash.display.Stage;
	import flash.media.StageWebView;
	import flash.text.TextField;

	public class Alert
	{
		private static var sw:StageWebView ;
		
		private static var 	debugField1:TextField,
							debugField2:TextField,
							debugField3:TextField;

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
				debugField2.appendText(title+'\n');
				
				debugField1.scrollV++;
				debugField2.scrollV++;
			}
			else
			{
				sw.loadURL("javascript:alert(\""+title.split('\n').join('').split('\r').join('').split('\\').join('\\\\').split('"').join('\\"')+"\");")
			}
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
			debugField2 = new TextField();
			debugField3 = new TextField();
			
			debugField1.width = stage.stageWidth ;
			debugField1.height = stage.stageHeight ;
			debugField2.width = stage.stageWidth ;
			debugField2.height = stage.stageHeight ;
			debugField3.width = stage.stageWidth ;
			debugField3.height = stage.stageHeight ;
			
			debugField2.textColor = 0xffffff ;
			
			debugField1.x = 1;
			debugField1.y = 1;
			debugField3.x = -1;
			debugField3.y = -1;
			
			debugField3.mouseEnabled = debugField1.mouseEnabled = debugField2.mouseEnabled = false ;
			
			stage.addChild(debugField1);
			stage.addChild(debugField3);
			stage.addChild(debugField2);
		}
	}
}