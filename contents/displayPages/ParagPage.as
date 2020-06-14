package contents.displayPages
{
	import com.mteamapp.StringFunctions;
	
	import contents.ImageData;
	import contents.PageData;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ParagPage extends DynamicPage
	{
		private var paragH:Number ;
		
		public function ParagPage()
		{
			super();
			fullImageShow = false ;
		}
		
		public function setUpParag(maskRect:Rectangle,listOfParag:Vector.<ParagData>,activateHTMLlink:Boolean=false,linkColor:int=-1,createURLLinks:Boolean=true,alighn:Boolean=true,useCash:Boolean=false):void
		{
			var i:int ;
			
			//Debug lines
				/*this.alpha = 0.5 ;
				this.graphics.beginFill(0xff0000,1);
				this.addEventListener(MouseEvent.MOUSE_DOWN,showMousePose);
				function showMousePose(e:MouseEvent):void
				{
					SaffronLogger.log(this.mouseY);
				}*/
			
			if(activateHTMLlink)
			{
				super.activateHTMLLinks(linkColor,createURLLinks) ;
			}
			
			maskArea = maskRect.clone();
			//textContainer.x = maskRect.x;
			//textContainer.y = maskRect.y;
			textTF.width = maskRect.width ;
			textTF.height = 50 ;
			
			textTF.text = '-';
			textTF.multiline = true ;
			paragH = textTF.textHeight;
			textTF.appendText('\n-');
			paragH = textTF.textHeight-paragH ;
			SaffronLogger.log("paragH is : "+paragH);
			textTF.text = '';
			
			var imageW:Number = maskRect.width;
			var imageH:Number = 768/(1024/maskRect.width)
			
			var samplePagedata:PageData = new PageData();
			//Do not set the X and Y to the text container, because it will act on Scroller
				//samplePagedata.contentX = maskRect.x;
				//samplePagedata.contentY = maskRect.y;
			samplePagedata.contentW = maskRect.width;
			
			SaffronLogger.log("samplePagedata.contentW : "+samplePagedata.contentW);
			SaffronLogger.log("maskRect.width : "+maskRect.width);
			if(alighn)
			{
				samplePagedata.contentAlign = '1';
			}
			else
			{
				samplePagedata.contentAlign = '0';
			}
			//var alighn:Boolean = true ;
			
			var ImageY:Number = 0 ;
			var textY:Number = 0 ;
			
			var contentsString:String = '' ;
			
			//SaffronLogger.log("ImageH : "+imageH+' vs ParagH : '+paragH+' : '+(imageH/paragH));
			
			var imageParagEnters:String = '';
			var paragNumber:uint = Math.ceil((imageH/paragH));
			var imageParagHeight:Number = paragNumber*paragH ;
			var singleEnter:String = ' \n';
			for(i = 0 ; i<paragNumber ; i++)
			{
				//SaffronLogger.log("•");
				imageParagEnters+=' \n';
			}
			
			for(i = 0 ; i<listOfParag.length ; i++)
			{
				if(listOfParag[i].imageURL!='')
				{
					//contents+='-';
					var image:ImageData = new ImageData();
					image.targURL = listOfParag[i].imageURL;
					image.x = 0 ;
					image.y = ImageY ;
					image.height = imageH ;
					image.width = imageW ;
					ImageY+=imageH ;
					
					samplePagedata.images.push(image);
					//textY+=paragH;
					//contents+='\n ';
						//contentsString+=imageParagEnters;
						while(textTF.textHeight<ImageY)
						{
							//SaffronLogger.log("textTF.textHeight : "+textTF.textHeight+' vs ImageY : '+ImageY);
							textTF.appendText(' \n ');
							contentsString+=' \n ';
						}
						textTF.appendText(' \n ');
						contentsString+=' \n '
					//textY=imageParagHeight;
					//SaffronLogger.log("Enters added to content : "+contentsString+' > '+contentsString.length);
				}
				else if(i!=0)
				{
					if(listOfParag[i].content!='')
					{
						contentsString+=singleEnter;
					}
					//textY+=paragH ;
				}
				
				//textY+=paragH;
				/*while(textY<ImageY)
				{
					SaffronLogger.log("•");
					textY += paragH ;
					//if(textY<ImageY)
					//{
					//	contents+='\n ';
					//}
				}*/
				//SaffronLogger.log('----------------------');
				//SaffronLogger.log("Parag string is : • "+listOfParag[i].content+' • ');
				if(listOfParag[i].content!='')
				{
					contentsString+=listOfParag[i].content;
					TextPutter.onTextArea(textTF,contentsString,true,false,useCash,0,alighn);
					textY = textTF.textHeight;
				//SaffronLogger.log("ImageY : "+ImageY);
					ImageY = textY ;
				}
				//textY+=paragH;
					
				//TextPutter.onTextArea(textTF,currentPageData.content,true,true,true,0,alighn);
			}
			
			
			samplePagedata.content = contentsString ;
			//SaffronLogger.log("samplePagedata.content : "+samplePagedata.content);
			super.setUp(samplePagedata);
			
			
			//SaffronLogger.log("ParagPage.scaleY : "+this.scaleY);
		}
	}
}