package diagrams.table
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class TableBox extends Sprite
	{
		private var tf:TableTextField ;
		
		private var textY:Number,
					maxTextH:Number;
					
		private var Margin:Number ;
					
					
		private var vid:uint,hid:uint;
		
		private var casheValue:String ;
		
		private var w:Number,h:Number ;
		
		public function get vId():uint
		{
			return vid ;
		}
		
		public function get hId():uint
		{
			return hid ;
		}
		
		public function TableBox(W:Number,H:Number,Color:uint,Vid:uint,Hid:uint,Text:String='',margin:Number = TableConstants.margin,isTitle:Boolean=false)
		{
			vid = Vid ;
			hid = Hid ;
			w = W ;
			h = H ;
			Margin = margin ;
			
			color = Color ;
			
			if(isTitle)
			{
				tf = new TableTextField(TableConstants.Color_TitleText,TableConstants.titleFontSize,TableConstants.fontName);
			}
			else
			{
				//this.buttonMode = true ;
				tf = new TableTextField(TableConstants.Color_ContentText,TableConstants.contentFontSize,TableConstants.contentFontName);
				this.addEventListener(MouseEvent.CLICK,imSelected);
			}
			this.addChild(tf);
			tf.width = W-margin*2;
			textY = tf.y = margin;
			maxTextH = tf.height = H-margin*2;
			
			text = Text ;
		}
		
		protected function imSelected(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			trace("Im selected : "+vid+' '+hid);
			this.dispatchEvent(new TableEvent(TableEvent.TABLE_SELECTED,vid,hid,casheValue));
		}
		
		public function set color(value:uint):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,w,h);
			
			this.graphics.beginFill(value,1);
			this.graphics.drawRect(Margin,Margin,w-Margin*2,h-Margin*2);
		}
		
		public function set text(value:String):void
		{
			casheValue = value ;
			UnicodeStatic.fastUnicodeOnLines(tf,value,false);
			//trace('tf.textHeight : '+tf.textHeight+'  vs  '+tf.height+' Math.min(tf.textHeight+2,maxTextH) : '+Math.min(tf.textHeight+2,maxTextH));
			tf.height = Math.min(tf.textHeight+2,maxTextH);
			//trace("tf.height : "+tf.height);
			tf.y = textY+(maxTextH-tf.height)/2;
		}
	}
}