/**3/11/2015
 * version 1.0.1 : contentH added to this class.
 * 
 * 
 * 
 * 
 * 
 */
package contents
{
	import flash.utils.getQualifiedClassName;

	public class PageData
	{
		
		public var 	id:String='',
					musicURL:String='',
					type:String='',
					title:String='',
					imageTarget:String='',
					content:String='';
		
		/**New atribute for music volume */
		public var musicVolume:Number = 1 ;
		
		//New variables on content tag↓
		public var 	contentX:Number=NaN,
					contentAlign:String = '',
					contentY:Number=NaN,
					contentW:Number=NaN,
					contentH:Number=NaN;
		
		public var links1:Vector.<LinkData>,
					links2:Vector.<LinkData>;
					
		public var images:Vector.<ImageData>;
		
		
		/**New variables to make auto scroll on the pageManager*/
		public var 	scrollAble:Boolean=false,
					scrollWidth:Number=0,
					scrollHeight:Number=0,
					scrollEffect:Boolean=false;
		
		
		
		
		/*<page id="homePage">
			<scroll w="" h=""/>
			<music>The Descent.mp3</music>
			<type>home</type>
			<title>خانه</title>
			<image></image>
			<content></content>
			<links>
				<link name="جنگ به روایت تصویر" id="janberevayatetasvir"/>
				<link name="فعالیت های عملی" id="faaliathayeamali"/>
				<link name="امام و رهبری" id="emamvarahbari"/>
				<link name="انقلاب اسلامی" id="enghelabeeslami"/>
				<link name="سلاح ها و تاکتیک های جنگی" id="selahhavataktikhayejangi"/>
			</links>
			<links>
				<link name="شهدای دانش آموز" id="shohadayedaneshamuz"/>
				<link name="فرماندهان جنگ" id="farmandehanejang"/>
				<link name="معلمان شهید" id="moalemaneshahid"/>
				<link name="عملیات مهم" id="amaliatemohem"/>
			</links>
			<images>
				<img text="" targ=""/>
			</images>
			<character anim="Animations/mainCharacter.swf" sound="Animations/sample.mp3"/>
		</page>*/
		public function PageData(inputXML:XML=null)
		{
			images = new Vector.<ImageData>();
			links1 = new Vector.<LinkData>();
			links2 = new Vector.<LinkData>();
			if(inputXML==null)
			{
				//trace('page data is not generated');
				return ;
			}
			id = inputXML.@id ;
			musicURL = inputXML.music ;
			//trace("inputXML.music.@v : "+inputXML.music.@v);
			if( inputXML.music.@v != inputXML.music.@no_attribute_like_this )
			{
				musicVolume = Number(inputXML.music.@v);
				if(isNaN(musicVolume))
				{
					musicVolume = 1 ;
				}
				else
				{
					musicVolume = Math.min(Math.max(0,musicVolume),1);
				}
			}
			//trace("musicVolume : "+musicVolume);
			type = inputXML.type ;
			title = inputXML.title ;
			imageTarget = inputXML.image;
			content = inputXML.content ;
			
			if(inputXML.scroll == inputXML.no_tag_like_this)
			{
				scrollAble = false ;
			}
			else
			{
				scrollAble = true ;
				scrollWidth = uint(inputXML.scroll.@w) ;
				scrollHeight = uint(inputXML.scroll.@h) ;
				if(inputXML.scroll.@effect=="true")
				{
					scrollEffect = true ;
				}
				else
				{
					scrollEffect = false ;
				}
			}
			
			contentAlign = inputXML.content.@align ;
			if(String(inputXML.content.@x)!='')
			{
				contentX = Number(inputXML.content.@x);
			}
			if(String(inputXML.content.@y)!='')
			{
				contentY = Number(inputXML.content.@y);
			}
			if(String(inputXML.content.@w)!='')
			{
				contentW = Number(inputXML.content.@w);
			}
			if(String(inputXML.content.@h)!='')
			{
				contentH = Number(inputXML.content.@h);
			}
			
			///trace("inputXML.content.@w : "+inputXML.content.@w);
			///trace("inputXML.content.@h : "+inputXML.content.@h);
			
			var newLink:LinkData ;
			var newImg:ImageData ;
			var i:int ;
			
			if(inputXML.links[0] != undefined)
			{
				for(i = 0 ; i<inputXML.links[0].link.length() ; i++)
				{
					newLink = new LinkData(inputXML.links[0].link[i]);
					links1.push(newLink);
				}
			}
			
			if(inputXML.links[1] != undefined)
			{
				for(i = 0 ; i<inputXML.links[1].link.length() ; i++)
				{
					newLink = new LinkData(inputXML.links[1].link[i]);
					links2.push(newLink);
				}
			}
			
			if(inputXML.images[0] != undefined)
			{
				for(i = 0 ; i<inputXML.images[0].img.length() ; i++)
				{
					newImg = new ImageData(inputXML.images[0].img[i]);
					images.push(newImg);
				}
			}
		}
		
		/*<page id="homePage">
		<music>The Descent.mp3</music>
		<type>home</type>
		<title>خانه</title>
		<image></image>
		<content></content>
		<links>
		<link name="جنگ به روایت تصویر" id="janberevayatetasvir"/>
		<link name="فعالیت های عملی" id="faaliathayeamali"/>
		<link name="امام و رهبری" id="emamvarahbari"/>
		<link name="انقلاب اسلامی" id="enghelabeeslami"/>
		<link name="سلاح ها و تاکتیک های جنگی" id="selahhavataktikhayejangi"/>
		</links>
		<links>
			<link name="شهدای دانش آموز" id="shohadayedaneshamuz"/>
			<link name="فرماندهان جنگ" id="farmandehanejang"/>
			<link name="معلمان شهید" id="moalemaneshahid"/>
			<link name="عملیات مهم" id="amaliatemohem"/>
		</links>
		<images>
			<img text="" targ=""/>
		</images>
		</page>*/
		public function export():XML
		{
			var xml = XML('<page><links/><links/></page>');
			
			xml.@id = id;
			xml.music = musicURL ;
			xml.type = type;
			xml.title = title;
			xml.image = imageTarget;
			xml.content = content;
			
			xml.content.@x = contentX ;
			xml.content.@y = contentY ;
			xml.content.@w = contentW ;
			xml.content.@h = contentH ;
			xml.content.@align = contentAlign ; 
			
			if( musicVolume != 1 )
			{
				xml.music.@v = musicVolume ;
			}
			
			if(scrollAble)
			{
				xml.scroll = new XML();
				xml.scroll.@w = scrollWidth;
				xml.scroll.@h = scrollHeight;
				xml.scroll.@effect = scrollEffect ;
			}
			
			
			//var link1Node:XML = XML('<links/>');
			//xml.links = new XML();
			for(var i = 0 ; i<links1.length ;i++)
			{
				xml.links[0].link[i] = links1[i].export();
			}
			//xml.links = new XML();
			for(i = 0 ; i<links2.length ;i++)
			{
				xml.links[1].link[i] = links2[i].export();
			}
			xml.images = new XML();
			for(i = 0 ; i<images.length ;i++)
			{
				xml.images[0].img[i] = images[i].export();
			}
			
			
			return xml;
		}
		
		public function clone():PageData
		{
			// TODO Auto Generated method stub
			//return new PageData(export());
			
			//new Clone system 
			var newPageData:PageData = new PageData();
			var i:int ;
			
			newPageData.id = id ;
			newPageData.musicURL = musicURL ;
			newPageData.type = type ;
			newPageData.title = title ;
			newPageData.imageTarget = imageTarget ;
			newPageData.content = content ;
			newPageData.contentX = contentX ;
			newPageData.contentAlign = contentAlign ;
			newPageData.contentY = contentY ;
			newPageData.contentW = contentW ;
			newPageData.contentH = contentH ;
			
			newPageData.scrollAble = scrollAble ;
			newPageData.scrollWidth = scrollWidth ;
			newPageData.scrollHeight = scrollHeight ;
			newPageData.scrollEffect = scrollEffect ;

			newPageData.musicVolume = musicVolume ;
			
			
			//Mange belos ↓
			for(i = 0 ; i<links1.length ; i++)
			{
				newPageData.links1[i] = links1[i].clone() ;
			}
			for(i = 0 ; i<links2.length ; i++)
			{
				newPageData.links2[i] = links2[i].clone() ;
			}
			
			for(i = 0 ; i<images.length ; i++)
			{
				newPageData.images[i] = images[i].clone() ;
			}
			return newPageData ;
		}
	}
}