package fileBrowser
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import popForm.PopButtonData;
	import popForm.PopMenuContent;
	import popForm.PopMenuEvent;
	import popForm.PopMenuFields;

	public class FileBrowser
	{
		private static var eventListen:Sprite = new Sprite();
		
		
		public static var selectedFile:File ;
		public static var selectedFileBytes:ByteArray ;
		
		private static var onDone:Function ;
		
		private static var lastLocation:File ;
		
		private static var Name:String ;
		
		private static var driveFrame:uint = 7,
							folderFrame:uint=8,
							fileFrame:uint=9,
							noFileFrame:uint=4;
		
		/**1: load file, 2:save file*/
		private static var mode:uint = 0;
		
		private static var foundedFiles:Vector.<File>,
							lastSearchVal:String,
							queEndTime:Number,
							lastSearchedFolder:File,
							searchQue:Vector.<File>,
							frameTimes:Number,
							searchTF:MTTextField;

		private static var baseFolder:File,
							baseFolderTarget:String;
		
		/**Set the Popmenu frames here*/
		public static function setUp(DriveButtonFrame:uint,FolderButtonsFrame:uint,
									 FilesButtonFrame:uint,NoFileButtonFrame:uint):void
		{
			driveFrame = DriveButtonFrame ;
			folderFrame = FolderButtonsFrame;
			fileFrame = FilesButtonFrame;
			noFileFrame = NoFileButtonFrame ;
		}

		public static function get isSupported():Boolean
		{
			trace("Check the iOS action for file browser first");
			return true ;
		}
		
		public static function browsToLoad(onFileSelected:Function):void
		{
			selectedFile = null ;
			selectedFileBytes = null ;
			mode = 1 ;
			onDone = onFileSelected ;
			showBrowser(lastLocation);
		}
		
		public static function browsToSave(targetBytes:ByteArray,fileName:String):void
		{
			// TODO Auto Generated method stub
			selectedFileBytes = targetBytes ;
			mode = 2;
			Name = fileName ;
			onDone = new Function();
			showBrowser(lastLocation);
		}
		
		public static function showBrowser(target:File,hint:String=''):void
		{
			lastLocation = target ;
			var buttons:Array = [Lang.t.cansel,''] ;
			
			baseFolderTarget = '' ;
			if(/*true || */DevicePrefrence.isIOS())
			{
				baseFolder = File.applicationStorageDirectory.resolvePath('FileManager');
				if(!baseFolder.exists)
				{
					baseFolder.createDirectory();
				}
				baseFolderTarget = baseFolder.nativePath ;
			}
			trace("lastLocation : "+lastLocation+' vs '+baseFolder)
			if(lastLocation==null)
			{
				lastLocation = baseFolder ;
			}
			else
			{
				trace("Location was not null : "+lastLocation.nativePath);
			}
			
			if(lastLocation!=null && 
				(baseFolder==null || lastLocation.nativePath!=baseFolder.nativePath))
			{
				buttons.push(Lang.t.back);
			}
			if(mode==2 && lastLocation!=null)
			{
				buttons.push(Lang.t.save);
			}
			else if(lastLocation!=null)
			{
				buttons.push(Lang.t.search);
			}
			var button:PopButtonData ;
			var i:int ;
			var currentFile:File ;
			
			var hadSub:Boolean = false ;
			
			if(lastLocation!=null)
			{
				var location:String = lastLocation.nativePath;
				if(baseFolderTarget!='')
				{
					location = location.split(baseFolderTarget).join('');
				}
				if(hint!='')
				{
					hint = hint+'\n'+location ;
				}
				else
				{
					hint = location ;
				}
			}
			
			if(lastLocation == null)
			{
				var bases:Array = File.getRootDirectories() ;
				if(bases.length==1)
				{
					showBrowser(bases[0] as File);
					return ;
				}
				for(i = 0 ; i<bases.length ; i++)
				{
					hadSub = true ;
					var baseFile:File = bases[i] as File ;
					button = new PopButtonData(baseFile.name,driveFrame,baseFile);
					buttons.push(button);
				}
			}
			else
			{
				var sub:Array = lastLocation.getDirectoryListing() ;
				for(i = 0 ; i<sub.length ; i++)
				{
					hadSub = true ;
					currentFile = sub[i] as File ;
					var buttonFrame:uint ;
					if(currentFile.isDirectory)
					{
						buttonFrame = folderFrame ;
					}
					else
					{
						buttonFrame = fileFrame ;
						if(mode==2)
						{
							continue ;
						}
					}
					button = new PopButtonData(currentFile.name,buttonFrame,currentFile);
					buttons.push(button);
				}
			}
			
			if(!hadSub)
			{
				button = new PopButtonData(Lang.t.no_file_here,noFileFrame,null,false);
				buttons.push(button);
			}
			
			var popText:PopMenuContent = new PopMenuContent(hint,null,buttons);
			trace("Open browser");
			PopMenu1.popUp(Lang.t.file_selector_title,null,popText,0,onFileSelected);
		}
		
		private static function onFileSelected(e:PopMenuEvent):void
		{
			var file:File ;
			if(e.buttonTitle == Lang.t.back)
			{
				showBrowser(lastLocation.parent);
			}
			else if(e.buttonTitle == Lang.t.search)
			{
				searchPage('');
			}
			else if(e.buttonTitle == Lang.t.cansel)
			{
				trace("Cansel");
				selectedFile = null;
				selectedFileBytes = null ;
				//onDone();
			}
			else if(e.buttonTitle == Lang.t.save)
			{
				var saveTarget:File = lastLocation.resolvePath(Name);
				
				var index:uint = 1 ;
				var extention:String = Name.substring(Name.lastIndexOf('.'));
				var baseName:String = Name.substring(0,Name.lastIndexOf('.'));
				while(saveTarget.exists)
				{
					saveTarget = lastLocation.resolvePath(baseName+'_'+index+extention);
					index++ ;
				}
				trace("File saved to : "+saveTarget.nativePath);
				var status:String = FileManager.seveFile(saveTarget,selectedFileBytes);
				if(status!='')
				{
					showBrowser(lastLocation,status);
				}
			}
			else if(e.buttonID is File)
			{
				file = e.buttonID as File;
				if(file.isDirectory)
				{
					showBrowser(file); 
				}
				else
				{
					selectThisFile(file);
				}
			}
		}
		
		/**Finish the browse*/
		private static function selectThisFile(file:File):void
		{
			// TODO Auto Generated method stub
			selectedFile = file ;
			
			selectedFileBytes = FileManager.loadFile(selectedFile);
			onDone();
		}
		
		private static function searchPage(searchVal:String=null):void
		{
			// TODO Auto Generated method stub
			if(searchVal!=null)
			{
				lastSearchVal = searchVal ;
			}
			foundedFiles = new Vector.<File>();
			frameTimes = 1000/30 ;
			var fields:PopMenuFields = new PopMenuFields();
			fields.addField(Lang.t.search,lastSearchVal,null,false);
			var buttons:Array = [Lang.t.search,Lang.t.back];
			var popText:PopMenuContent = new PopMenuContent('',fields,buttons);
			PopMenu1.popUp(Lang.t.file_selector_title,null,popText,0,onSearchButton);
		}
		
		private static function onSearchButton(e:PopMenuEvent):void
		{
			if(e.buttonTitle == Lang.t.search)
			{
				//Start search
				lastSearchVal = e.field[Lang.t.search] as String;
				if(lastSearchVal == '')
				{
					searchPage();
				}
				else
				{
					startSearch();
				}
			}
			else
			{
				showBrowser(lastLocation);
			}
		}
		
		private static function startSearch():void
		{
			trace("Start the search about : "+lastSearchVal);
			// TODO Auto Generated method stub
			var searchMC:MovieClip = new MovieClip();
			searchTF = new MTTextField(0,30,"B Yekan");
			searchTF.width = 400 ;
			searchMC.addChild(searchTF);
			searchTF.x = searchTF.width/-2;
			searchTF.text = '0';
			lastSearchedFolder = lastLocation ;
			
			startSearchig();
			
			var buttons:Array = [Lang.t.back,Lang.t.see_the_result];
			
			var popText:PopMenuContent = new PopMenuContent(Lang.t.founded_items,null,buttons,searchMC);
			PopMenu1.popUp(Lang.t.please_wait,null,popText,0,onSearchButton2);
		}
		
		private static function startSearchig():void
		{
			searchQue = new Vector.<File>();
			var bases:Array = File.getRootDirectories();
			for(var i = 0 ; i<bases.length ; i++)
			{
				searchQue.push(bases[i] as File);
			}
			//queEndTime = getTimer()+10/*frameTimes*/;
			// TODO Auto Generated method stub
			eventListen.addEventListener(Event.ENTER_FRAME,SearchOnQue);
		}
		
			protected static function SearchOnQue(event:Event):void
			{
				// TODO Auto-generated method stub
				searchTF.text = foundedFiles.length.toString();
				/*for(var i = 0 ; i<searchQue.length ; i++)
				{
					searchOn(searchQue[i]);
				}
				searchQue = new Vector.<File>();*/
				queEndTime = getTimer()+(frameTimes)*4/5;
				while(getTimer()<queEndTime)
				{
					//trace("lastSearchedFolder : "+getTimer()+'<'+queEndTime);
					if(lastSearchedFolder!=null)
					{
						//trace("Continue searching...");
						searchOn2(lastSearchedFolder);
					}
					else
					{
						//trace("Finished");
						stopSearching();
						ShowSearchResult();
						break;
					}
				}
				
				//stopSearching();
			}
			
			private static function searchOn2(file:File):void
			{
				//trace("Check this : "+file.nativePath);
				// TODO Auto Generated method stub
				if(file.isDirectory)
				{
					var sub:Array = file.getDirectoryListing();
					if(sub.length > 0)
					{
						lastSearchedFolder = sub[0] as File ;
						return ;
					}
					else
					{
						//Same as file
					}
				}
				else if(file.name.indexOf(lastSearchVal)!=-1)
				{
					foundedFiles.push(file);
				}
				
				while(file.nativePath!=lastLocation.nativePath && file!=null)
				{
					var nextFolder:File = file.parent;
					if(nextFolder==null)
					{
						lastSearchedFolder = null;
						return ;
					}
					var myIndex:uint = 0;
					var sisters:Array = nextFolder.getDirectoryListing();
					for(var i = 0 ; i<sisters.length ; i++)
					{
						if((sisters[i] as File).name == file.name)
						{
							myIndex = i ;
							break ;
						}
					}
					if(i+1<sisters.length)
					{
						lastSearchedFolder = sisters[i+1] as File;
						return ;
					}
					else
					{
						file = nextFolder ;
					}
					//trace("loop on : "+file.nativePath);
				}
				lastSearchedFolder = null ;
				/*for(var i = 0 ; i<sub.length ; i++)
				{
					subFile = sub[i];
					if(subFile.isDirectory)
					{
						lastSearchedFolder = subFile ;
						return ;
					}
					else if(subFile.name.indexOf(lastSearchVal)!=-1)
					{
						foundedFiles.push(subFile);
					}
				}*/
			}
			
				private static function searchOn(file:File):void
				{
					if(getTimer()>queEndTime)
					{
						searchQue.push(file);
						//trace("Time out on : "+file.nativePath);
						return ;
					}
					// TODO Auto Generated method stub
					var sub:Array = file.getDirectoryListing() ;
					var file2:File
					for(var i = 0 ; i<sub.length ; i++)
					{
						file2 = sub[i];
						if(file2.isDirectory)
						{
							searchOn(file2);
							//searchQue.push(file);
						}
						else
						{
							if(file2.name.indexOf(lastSearchVal)!=-1)
							{
								foundedFiles.push(file2);
							}
						}
					}
				}
		
		private static function stopSearching():void
		{
			// TODO Auto Generated method stub
			eventListen.removeEventListener(Event.ENTER_FRAME,SearchOnQue);
		}
		
		private static function onSearchButton2(e:PopMenuEvent)
		{
			//Stop the searches
			stopSearching();
			if(e.buttonTitle == Lang.t.back)
			{
				searchPage();
			}
			else
			{
				ShowSearchResult();
			}
		}
		
		private static function ShowSearchResult():void
		{
			// TODO Auto Generated method stub
			var buttons:Array = [Lang.t.back,''];
			
			for(var i = 0 ; i<foundedFiles.length ; i++)
			{
				var newButt:PopButtonData = new PopButtonData(foundedFiles[i].name,fileFrame,foundedFiles[i]);
				buttons.push(newButt);
			}
			
			var popText:PopMenuContent = new PopMenuContent(Lang.t.founded_files_with+lastSearchVal,null,buttons);
			PopMenu1.popUp(Lang.t.search,null,popText,0,onResultButton);
		}
		
		private static function onResultButton(e:PopMenuEvent):void
		{
			if(e.buttonID is File)
			{
				selectThisFile(e.buttonID as File);
			}
			else
			{
				searchPage();
			}
		}
		
	}
}