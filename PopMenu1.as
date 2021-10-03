package
{
	import flash.geom.Point;
	
	import popForm.PopMenu;
	import popForm.PopMenuContent;
	import popForm.PopMenuDispatcher;
	import popForm.PopMenuTypes;
	
	public class PopMenu1 extends PopMenu
	{
		private static var ME1:PopMenu1 ;
		
		private static var maxPageHeight:Number = 0;
		private static var staticStageHeight:Number = 1024;
		
		private static var contenty0:Number,
							contenth0:Number,
							titley0:Number;
		
		public function PopMenu1()
		{
			super();
			ME1 = this;
			contenty0 = ME1.myContent.y ;
			contenth0 = ME1.myContent.height0 ;
			titley0 = ME1.titleContainerMC.y ;
		}
		
		/**This will makes popMneucontents to have dynamic height.<br>
		 * But the popMenu should not have css to repositioning*/
		public static function makeHeightDynamic(newStageHieght:Number=1024,applicationStageSize:Number=1024):void
		{
			maxPageHeight = newStageHieght ;
			staticStageHeight = applicationStageSize ;
		}
		
		public static function popUp(title:String='' , type:PopMenuTypes=null , content:PopMenuContent=null,closeOnTime:uint=0,onButtonSelects:Function = null,onClosedByTimer:Function=null,onClose:Function=null):void
		{
			//SaffronLogger.log('POP 1 MENU OPENED '+Math.random());
			//ME1.popUp2(title, type, content,closeOnTime,onButtonSelects);
			
			
			///↓
			//ME1.y = 0 ;
			ME1.myContent.localHeight(0);
			
			SaffronLogger.log('POP 2 MENU OPENED '+Math.random());
			ME1.popUp2(title, type, content,closeOnTime,onButtonSelects,onClosedByTimer,onClose);
			
			
			
			SaffronLogger.log("ME2.myContent.height"+ME1.myContent.height+"  ME2.myContent.height0"+contenth0);
			
			ME1.myContent.y = contenty0;
			if(maxPageHeight!=0 && ME1.myContent.height > contenth0)
			{
				var deltaY:Number = Math.max(0,ME1.myContent.height-contenth0) ;
				SaffronLogger.log("deltaY :"+deltaY+' > '+contenth0);
				//ME1.y = y0-deltaY/2 ;
				SaffronLogger.log("ME2.y positino changed to : "+ME1.y);
				SaffronLogger.log("ME2.name ?? "+ME1.name);
				
				var minVisibleYOnStage:Number = (maxPageHeight-staticStageHeight)/-2;
				var maxVisibleYOnStage:Number = staticStageHeight+(maxPageHeight-staticStageHeight)/2;
				
				var titlePoseBasedOnStage:Point = ME1.titleContainerMC.parent.localToGlobal(new Point(0,titley0-deltaY));
				var acceptedData:Number = Math.max(titlePoseBasedOnStage.y,minVisibleYOnStage);
				ME1.titleContainerMC.y = ME1.titleContainerMC.parent.globalToLocal(new Point(0,acceptedData)).y;
				
				var contentPoseBasedOnStage:Point = ME1.myContent.parent.localToGlobal(new Point(0,contenty0-deltaY));
				var accepdetDeltaForContent:Number = Math.max(contentPoseBasedOnStage.y,ME1.titleContainerMC.localToGlobal(new Point(0,ME1.titleContainerMC.height)).y);
				var conentDeltaY:Number = ME1.myContent.parent.globalToLocal(new Point(0,accepdetDeltaForContent)).y ;
				ME1.myContent.setY(conentDeltaY) ;
				SaffronLogger.log("conentDeltaY : "+conentDeltaY);
				
				var contentHeightBasedOnStage:Point = ME1.myContent.parent.localToGlobal(new Point(0,ME1.myContent.y+contenth0+deltaY));
				var maxAcceptableYForHeight:Number = Math.min(contentHeightBasedOnStage.y,maxVisibleYOnStage);
				var maxAcceptableYOnContentArea:Point = ME1.myContent.parent.globalToLocal(new Point(0,maxAcceptableYForHeight));
				SaffronLogger.log("maxAcceptableYForHeight : "+maxAcceptableYForHeight);
				SaffronLogger.log("maxAcceptableYOnContentArea.y : "+maxAcceptableYOnContentArea);
				SaffronLogger.log("ME1.myContent.y : "+ME1.myContent.y);
				ME1.myContent.localHeight((maxAcceptableYOnContentArea.y-ME1.myContent.y)-contenth0);
				ME1.myContent.updateScrollheight();
			}
		}		
		
		public static function get popDispatcher():PopMenuDispatcher
		{
			return ME1.popDispatcher ;
		}
		public static function close():void
		{
			if(ME1)
			{
				ME1.close();
			}
		}
		
		/**this will tell if the popMenuIsOpen*/
		public static function get isOpen():Boolean
		{
			return ME1.show ;
		}
		
		/**Returns the content width*/
		public static function width():Number
		{
			if(ME1)
			{
				return ME1.getContentWidth();
			}
			return 0 ;
		}
		
		/**Returns the content height*/
		public static function height():Number
		{
			if(ME1)
			{
				return ME1.getContentHeight();
			}
			return 0 ;
		}
		
		/**Returns true if the pop menu is exists*/
		public static function isExists():Boolean
		{
			if(ME1==null)
			{
				return false ;
			}
			return true ;
		}
	}
}