package appManager.displayContent
{
	import appManager.displayContentElemets.LightImage;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	internal class SliderGalleryElements extends MovieClip
	{
		private var lightImage:LightImage ;
		
		private var myArea:Rectangle ;
		
		private var lastImage:SliderImageItem ;
		
		private var lastImageLoaded:String ;
		
		private var H:Number;
		
		private var myPreloader:MovieClip ;
		private var preLoaderShowerTimeOutId:uint;
		
		/**All light images will store here*/
		private var lightImageHistory:Vector.<LightImage>,
					lightImageLinks:Vector.<String> ;
					
		private var oldDisplayInterface:SliderElementInterface ;
					
		private var maxHistory:uint = 5 ;
		
		private var lastIndex:int = int.MIN_VALUE ;
		
		public function SliderGalleryElements(rect:Rectangle)
		{
			super();
			
			lightImageHistory = new Vector.<LightImage>();
			lightImageLinks = new Vector.<String>();
			
			myArea = rect.clone() ;
			//lightImage = new LightImage();
			//lightImage.animated = false ;
			//this.addChild(lightImage);
			//this.graphics.beginFill(0x000000,0.5);
			//this.graphics.drawRect(0,0,rect.width,rect.height);
			
			if(SliderGallery.preloaderClass!=null)
			{
				myPreloader = new SliderGallery.preloaderClass();
				this.addChild(myPreloader);
				myPreloader.x = myArea.width/2;
				myPreloader.y = myArea.height/2;
			}
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			
			drawBackGround();
		}
		
		override public function get width():Number
		{
			if(myArea)
			{
				return myArea.width ;
			}
			else
			{
				return super.width ;
			}
		}
		
		private function drawBackGround():void
		{
			if(SliderGallery.imageBackGroundColor!=-1)
			{
				this.graphics.clear();
				this.graphics.beginFill(SliderGallery.imageBackGroundColor,SliderGallery.imageBackAlpha);
				this.graphics.drawRect(0,0,myArea.width,myArea.height);
			}
		}
		
		protected function unLoad(e:Event):void
		{
			clearTimeout(preLoaderShowerTimeOutId);
		}
		
		override public function set height(value:Number):void
		{
			myArea.height = value ;
			if(myPreloader)
			{
				myPreloader.y = myArea.height/2;
			}
			//Obj.remove(lightImage);
			//lightImage = new LightImage();
			//this.addChild(lightImage);
			drawBackGround();
			load();
		}
		
		override public function get height():Number
		{
			return myArea.height ;
		}
		
		public function load(imageItem:SliderImageItem=null,imageIndex:int=-1):void
		{
			if(lastIndex==imageIndex && lastIndex!=-1)
			{
				return ;
			}
			lastIndex = imageIndex ;
			clearTimeout(preLoaderShowerTimeOutId);
			if(imageItem!=null && imageItem.pageInterface!=null)
			{
				if(oldDisplayInterface!=imageItem.pageInterface)
				{
					removeOldInterface();
					oldDisplayInterface = imageItem.pageInterface
					this.addChild(oldDisplayInterface);
					oldDisplayInterface.setUp(imageItem.data,myArea,imageIndex);
					this.addChild(oldDisplayInterface);
				}
			}
			else
			{
				if((imageItem==null && lastImage!=null) || imageItem!=lastImage)
				{
					if(imageItem==null)
					{
						imageItem = lastImage ;
					}
					
					if(lightImage)
					{
						lightImage.removeEventListener(Event.COMPLETE,imageLoaded);
					}
					
					var imageWasLoadedBefor:Boolean = false ;
					
					if(imageItem.image is String)
					{
						for(var i = 0 ; i<lightImageHistory.length ; i++)
						{
							if(lightImageLinks[i] == imageItem.image )
							{
								if(lightImage)
								{
									lightImage.visible = false ;
								}
								lightImage = lightImageHistory[i];
								lightImage.visible = true ;
								imageWasLoadedBefor = true ;
								break;
							}
						}
					}
					
					if(!imageWasLoadedBefor)
					{
						if(lightImage)
						{
							lightImage.visible = false ;
						}
						lightImage = new LightImage();
						this.addChild(lightImage);
						lightImage.addEventListener(Event.COMPLETE,imageLoaded);
						
						if(myPreloader)
						{
							preLoaderShowerTimeOutId = setTimeout(showPreLoader,5);
						}
						
						
						if(imageItem.image is BitmapData)
						{
							lightImage.setUpBitmapData(imageItem.image,false,myArea.width,myArea.height,0,0,true,imageItem.keepRatio);
						}
						else if(imageItem.image is ByteArray)
						{
							lightImage.setUpBytes(imageItem.image,false,myArea.width,myArea.height,0,0,true,imageItem.keepRatio);
						}
						else if(imageItem.image is String)
						{
							lightImage.setUp(imageItem.image,false,myArea.width,myArea.height,0,0,imageItem.keepRatio);
						}
						
						if(imageItem.image is String)
						{
							lightImageHistory.push(lightImage);
							lightImageLinks.push(imageItem.image);
						}
					}
					
					lastImage = imageItem ;
					
					
					if(lightImageHistory.length>maxHistory)
					{
						var lightOne:LightImage = lightImageHistory.shift();
						lightImageLinks.shift();
						Obj.remove(lightOne);
					}
					
					removeOldInterface();
				}
			}
		}
		
		/**Removes old interface from the stage*/
		private function removeOldInterface():void
		{
			if(oldDisplayInterface!=null)
			{
				oldDisplayInterface.hide();
				Obj.remove(oldDisplayInterface);
				oldDisplayInterface = null ;
			}
		}
		
		
		private function imageLoaded(e:Event):void
		{
			if(myPreloader)
			{
				myPreloader.visible = false ;
			}
			clearTimeout(preLoaderShowerTimeOutId);
		}
		
		
		private function showPreLoader():void
		{
			myPreloader.visible = true ;
			this.addChild(myPreloader);
		}
	}
}