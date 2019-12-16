package nativeClasses
{
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import dynamicFrame.FrameGenerator;
	import contents.alert.Alert;

	public class WindowApplicationManager
	{
		public static function makeFullScreen(stage:Stage,addMinimizeAndCloseButtons:Boolean=true):void
		{
			stage.nativeWindow.maximize();
			//Alert.show("H:"+stage.fullScreenHeight+'vs'+stage.stageHeight+" and W:"+stage.fullScreenWidth+'vs'+stage.stageWidth);
			if(addMinimizeAndCloseButtons)
				FrameGenerator.createFrame(stage,0x555555,null,true);
		}
	}
}