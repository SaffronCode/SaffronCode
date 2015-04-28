package popForm
{
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	
	public class PopButton extends MovieClip
	{
		private static const debug_windowSpace:Boolean = true;
		
		/**List of titles that will listening to the back event from key board to act*/
		private static var backList:Array = [] ;
		
		
		private var txtTF:TextField ;
		
		private var backMC:MovieClip ;
		
		/**it can be an uint or string*/
		public var ID:* ;
		
		public var title:String ;
		
		private var me:PopButton ;
		
		/**You can change the button type with entering its frame index.<br>
		 * You can set full button data with ability to change selectable or button id by using PopButtonData object on completeButtonObject*/
		public function PopButton(str:String=''/*,colorTrans:ColorTransform=null*/,buttonID:*=0,type:uint = 1,completeButtonObject:* = null )
		{
			super();
			
			if(completeButtonObject != null && completeButtonObject is PopButtonData)
			{
				type = completeButtonObject.buttonFrame ;
				buttonID = completeButtonObject.id ;
				str = completeButtonObject.title ;
				this.mouseChildren = this.mouseEnabled = completeButtonObject.selectable;
			}
			
			this.gotoAndStop(type);
			
			me = this ;
			
			
			this.mouseChildren = false;
			this.buttonMode = true ;
			txtTF = Obj.get('txt_txt',Obj.get('txt_txt',this));
			txtTF.dispatchEvent(new Event(Event.ADDED,true));
			backMC = Obj.get('back_mc',this);
			
			/*if(!DevicePrefrence.isTablet)
			{
				backMC.height += 20 ;
				//backMC.width += 20;
				//backMC.x+=10;
				backMC.y+=5;
				//txtTF.width+=20;
				txtTF.height+=10;
				var tf:TextFormat = txtTF.getTextFormat();
				tf.size = tf.size+10;
				txtTF.defaultTextFormat = tf ;
			}*/
			
			checkStage();
			
			
			setUp(str/*,colorTrans*/,buttonID);
		}
		
		
		
		/**add titles that will triggerring the back button*/
		public static function addBackTitleTrigger(backTitle:String)
		{
			backList.push(backTitle);
		}
		
		/**Check the stage*/
		private function checkStage(e:Event=null):void
		{
			// TODO Auto Generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE,checkStage);
			if(this.stage == null)
			{
				this.addEventListener(Event.ADDED_TO_STAGE,checkStage);
			}
			else
			{
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,checkBack);
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			}
		}
		
		protected function unLoad(event:Event):void
		{
			// TODO Auto-generated method stub
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN,checkBack);
		}
		
		private function checkBack(e:KeyboardEvent)
		{
			if(!Obj.getVisible(me) || !Obj.getImOnStage(me))
			{
				return ;
			}
			if(backList.indexOf(title)!=-1)
			{
				//		debug button
				if((debug_windowSpace && e.keyCode == Keyboard.SPACE) || e.keyCode == Keyboard.BACK)
				{
					me.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));
					me.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true));
					me.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,true));
					e.preventDefault();
				}
			}
		}
		
		/**From now , buttonID can be both string or uint*/
		public function setUp(str:String/*,colorTrans:ColorTransform=null*/,buttonID:*=0,type:uint = 1,completeButtonObject:* = null )
		{
			if(completeButtonObject != null && completeButtonObject is PopButtonData)
			{
				type = completeButtonObject.buttonFrame ;
				buttonID = completeButtonObject.id ;
				str = completeButtonObject.title ;
				this.mouseChildren = this.mouseEnabled = completeButtonObject.selectable;
			}
			
			this.gotoAndStop(type);
			
			txtTF = Obj.get('txt_txt',Obj.get('txt_txt',this));
			txtTF.dispatchEvent(new Event(Event.ADDED,true));
			backMC = Obj.get('back_mc',this);
			
			ID = buttonID ;
			//trace("Button title is : "+title);
			title = str ;
			
			//trace('SAVE AND EXIT BUTTON : '+str);
			
			txtTF.text = '' ;
			if(str!='')
			{
				if(txtTF.multiline)
				{
					TextPutter.onTextArea(txtTF,str,true,true,false);
				}
				else
				{
					TextPutter.OnButton(txtTF,str,true,true,false);
				}
			}
			/*if(colorTrans!=null)
			{
				backMC.transform.colorTransform = colorTrans ;
			}*/
		}
	}
}