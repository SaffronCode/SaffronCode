package contents
{

	public class PageData
	{
		public var 	id:String='',
					musicURL:String='',
					type:String='',
					title:String='',
					imageTarget:String='',
					content:String='';
		
		//New variables on content tag↓
		public var contentX:Number=NaN,
					contentAlign:String = '',
					contentY:Number=NaN,
					contentW:Number=NaN;
		
		public var links1:Vector.<LinkData>,
					links2:Vector.<LinkData>;
					
		public var images:Vector.<ImageData>;
		
		
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
			type = inputXML.type ;
			title = inputXML.title ;
			imageTarget = inputXML.image;
			content = inputXML.content ;
			
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
			xml.content.@align = contentAlign ; 
			
			
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
			return new PageData(export());
		}
	}
}