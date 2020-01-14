package assistant.screenShot
{
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import stageManager.StageManager;
	import contents.alert.Alert;

	public class ScreenShotGenerator
	{
		public static function appleStoreShot():void
		{
			if(!StageManager.isSatUp())
			{
				Alert.show("You should set StageManger to be able to generate screenShots");
				return;
			}
			var sizes:Vector.<ScreenSizes> = new Vector.<ScreenSizes>();
			//Refrence: https://docs.appmanager.io/docs/screenshot-sizes
			sizes.push(new ScreenSizes("6.5-inch (iPhone XS Max-XR)",[1242,2688],[2688,1242] ));
			sizes.push(new ScreenSizes("5.8-inch (iPhone X-XS)",[1125,2436],[2436,1125] ));
			sizes.push(new ScreenSizes("5.5-inch (iPhone 6-6s-7-8 Plus)",[1242,2208],[2208,1242] ));
			sizes.push(new ScreenSizes("4.7-inch (iPhone 6-6s-7-8)",[750,1334],[1334,750] ));
			sizes.push(new ScreenSizes("4.7-inch (iPhone 6-6s-7-8)",[750,1334],[1334,750] ));
			sizes.push(new ScreenSizes("4-inch (iPhone SE)",[640,1096],[640,1136],[1136,600],[1136,640] ));
			sizes.push(new ScreenSizes("3.5-inch (iPhone 4s)",[640,920],[640,960],[960,600],[960,640] ));
			
			sizes.push(new ScreenSizes("12.9-inch (iPad Pro 3rd Gen.)",[2048,2732],[2732,2048]));
			sizes.push(new ScreenSizes("12.9-inch (iPad Pro 2nd Gen.)",[2048,2732],[2732,2048]));
			sizes.push(new ScreenSizes("11-inch (iPad Pro)",[1668,2388],[2388,1668]));
			sizes.push(new ScreenSizes("10.5-inch (iPad Pro)",[1668,2224],[2224,1668]));
			sizes.push(new ScreenSizes("9.7-inch (iPad, iPad mini)",[2048,1496],[2048,1536],[1536,2008],[1536,2048],[1024,748],[1024,768],[768,1004],[768,1024]));


			var screenShotFolder:File = File.desktopDirectory.resolvePath("ScreenShots");
			if(screenShotFolder.exists)
			{
				FileManager.deleteAllFiles(screenShotFolder);
			}
			screenShotFolder.createDirectory();
			for(var i:int = 0 ; i<sizes.length ; i++)
			{
				var direct:File = screenShotFolder.resolvePath(sizes[i].name);
				direct.createDirectory();
				for(var j:int = 0 ; j<sizes[i].sizes.length ; j++)
				{
					var W:Number = sizes[i].sizes[j][0];
					var H:Number = sizes[i].sizes[j][1];
					var screenShotFile:File = direct.resolvePath(W+"X"+H+".jpg");
					DevicePrefrence.setNativeWindowSizeAndPositino(-1,-1,W,H);
					ScreenShot.shot(StageManager.myStage,StageManager.stageVisibleArea,W,H,screenShotFile);
				}
			}
			DevicePrefrence.DetectApplicationSizes();

			Alert.show("All Apple screen shots created on desktop.");
		}

	}
}