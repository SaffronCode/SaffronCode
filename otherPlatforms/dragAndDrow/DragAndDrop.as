package otherPlatforms.dragAndDrow
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;

	public class DragAndDrop
	{
		/**Accepting file extentions should set something like below:<br>
		 * 'jpg','png'<br>
		 * the receivedDroppedFiles will get Vector.<Files>*/
		public static function activateDragAndDrop(area:Sprite,receivedDroppedFiles:Function,acceptingFormats:Array=null,acceptDirectory:Boolean=false):void
		{
			if(receivedDroppedFiles.length==0)
			{
				throw "receivedDroppedFiles shoud get at least one parameter of vector.<File>."
				return ;
			}
			NativeDragManager.acceptDragDrop(area);
			area.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragged);
			
			function onDragged(event:NativeDragEvent):void
			{
				var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				var anyAccepted:Boolean = false ;
				for(var i:int = 0 ; i<files.length ; i++)
				{
					var aFile:File = files[i] as File ;
					if (aFile.isDirectory && acceptDirectory)
					{
						anyAccepted = true ;
						break ;
					}
					else if(acceptingFormats==null)
					{
						anyAccepted = true ;
						break;
					}
					else
					{
						for(var j:int = 0 ; j<acceptingFormats.length ; j++)
						{
							 if( !aFile.isDirectory && (acceptingFormats[j].indexOf(aFile.extension)!=-1))
							 {
								anyAccepted = true ;
								break;
							}
						}
					}
				}
				if(anyAccepted)
				{
					NativeDragManager.acceptDragDrop(area.stage);
					area.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDroppedd);
				}
			}
			
			function onDroppedd(event:NativeDragEvent):void
			{
				area.stage..removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDroppedd);
				var acceptedFiles:Vector.<File> = new Vector.<File>();
				
				var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				for(var i:int = 0 ; i<files.length ; i++)
				{
					var aFile:File = files[i] as File ;
					if (aFile.isDirectory && acceptDirectory)
					{
						acceptedFiles.push(aFile);
						continue;
					}
					for(var j:int = 0 ; j<acceptingFormats.length ; j++)
					{
						trace("aFile.extension : "+aFile.extension+" vs "+acceptingFormats[j])
						if( !aFile.isDirectory && (acceptingFormats[j].indexOf(aFile.extension)!=-1))
						{
							acceptedFiles.push(aFile);
							break;
						}
					}
				}
				if(acceptedFiles.length>0)
					receivedDroppedFiles(acceptedFiles);
			}
		}
		
		/**Use can drop the file where he wanted to*/
		public static function startDrag(area:Sprite,fileToDrop:File,bitmap:BitmapData=null):void
		{
			var clip:Clipboard = new Clipboard();
			clip.setData(ClipboardFormats.FILE_LIST_FORMAT,[fileToDrop],false);
			NativeDragManager.doDrag(area,clip,bitmap);
		}
	}
}