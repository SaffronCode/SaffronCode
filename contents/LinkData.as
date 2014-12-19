package contents
{
	public class LinkData
	{
		/**some links can have submenu on them*/
		public var subLinks:Vector.<LinkData> ;
		
		public var 	name:String='',
					id:String='',
					iconURL:String='';
					
		/**if level is -1 , it will add to curren page , if level is 0 , it is the page from main menu*/
		public var level:int;
					
		/*<link level="" name="فعالیت های عملی" id="faaliathayeamali" icon="sf.jpg"/>*/
		public function LinkData(linkXML:XML=null)
		{
			subLinks = new Vector.<LinkData>();
			
			if(linkXML!=null)
			{
				//trace('each link is : '+linkXML.@level+' - '+linkXML.@name);
				name = linkXML.@name;
				id = linkXML.@id ;
				iconURL = linkXML.@icon ;
				if(String(linkXML.@level) == '')
				{
					level = -1 ;
				}
				else
				{
					level = uint(linkXML.@level);
				}
				//trace('level is : '+level);
				if(linkXML!='')
				{
					if(linkXML.link != undefined)
					{
						for(var i = 0 ; i<linkXML.link.length() ; i++)
						{
							var newLink = new LinkData(linkXML.link[i]) ;
							subLinks.push(newLink) ;
						}
					}
				}
			}
		}
		
		/**export the link*/
		public function export():XML
		{
			var xml:XML = new XML("<link/>");
			xml.@level = level.toString();
			xml.@name = name ;
			xml.@id = id;
			xml.@icon = iconURL;
			
			for(var i = 0 ; i<subLinks.length ; i++)
			{
				xml['link'][i] = subLinks[i].export();
			}
			
			//Add export for sublink here
			
			return xml ;
		}
	}
}