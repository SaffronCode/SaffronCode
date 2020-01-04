package contents.alert
{
	import flash.display.Stage;
	import flash.media.StageWebView;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import nativeClasses.vibration.VibrationDistriqt;

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
		
		/**
		 * You need vibration permission:  
		 * <uses-permission android:name="android.permission.VIBRATE" />
		 * @param duration 
		 */
		public static function vibrate(duration:uint=1000):void
		{
			setUp();
			if(VibrationDistriqt.isSupported())
			{
				VibrationDistriqt.vibrate(duration);
			}
			else if(DevicePrefrence.isAndroid())
			{
            	sw.loadURL("javascript:navigator.vibrate("+duration+");")
			}
		}
		/**
		 * You need vibration permission:  
		 * <uses-permission android:name="android.permission.VIBRATE" />
		 * @param duration 
		 */
		public static function vibrateDynamic(patternArray:Array):void
		{
			setUp();
			if(VibrationDistriqt.isSupported())
			{
				VibrationDistriqt.vibrateDynamic(patternArray);
			}
			if(DevicePrefrence.isAndroid())
			{
            	sw.loadURL("javascript:navigator.vibrate("+JSON.stringify(patternArray)+");")
			}
		}
		
		/**
		 * You need vibration permission:  
		 * <uses-permission android:name="android.permission.VIBRATE" />
		 * @param duration 
		 */
		public static function vibratePuls():void
		{
			if(VibrationDistriqt.isSupported())
			{
				VibrationDistriqt.puls();
			}
			else if(DevicePrefrence.isAndroid())
			{
            	vibrate(30);
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