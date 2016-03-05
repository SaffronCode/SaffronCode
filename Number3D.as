package  {
	import com.adobe.utils.IntUtil;
	
	import eventMovie.ThumbnailEvent;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import org.bytearray.micrecorder.MicRecorder;
	
	
	public class Number3D extends MovieClip
	{

		public var startNumber:int,
		currentNumber:int,
		totalNumber:int,
		radius:Number,
		perspective:Number,
		numberValue:int,
		speed:int,
		move:int,
		ziro:int;
		
		private var _className:String;
		public function get className():String
		{
			return _className;
		}
		private var _target:MovieClip;
		public function get target():MovieClip
		{
			return _target
		}
		private var _numberMovie3D:MovieClip
		public function get numberMovie3D():MovieClip
		{
			return _numberMovie3D
		}
		
		private var startYlocation:Number;
		
		private var speedMin:Number;
		private var _numberMovie3DArray:Array = new Array()

	
		private var stopRol:Boolean;
			
		private var spp:Number	
		public function Number3D(Target_p:MovieClip,Class_p:String,StartNumber_p:int,CurrentNumber_p:int,TotalNumber_p:int,Radius_p:Number,Perspective_p:Number,Ziro_p:int=1,Speed_p:int=5,Movie_p:int=1) 
		{
			
			// constructor code
			super();
			startNumber = StartNumber_p
			currentNumber = CurrentNumber_p
			totalNumber = TotalNumber_p	
			perspective = Perspective_p
			radius = Radius_p	
			if(radius>0)
			{
				radius = radius*-1
			}
			ziro = Ziro_p	
			speed = Speed_p		
			move = Movie_p	
			_className = Class_p	
			_target = Target_p
			_target.numberMovie3D_mc.visible = false	
				
			_target.transform.perspectiveProjection=new PerspectiveProjection();
			_target.transform.perspectiveProjection.projectionCenter = new Point(_target.x,_target.y);
			_target.transform.perspectiveProjection.fieldOfView = perspective
				


		}
		public function setup():void
		{
			_target.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown_fun)
			_target.addEventListener(MouseEvent.MOUSE_UP,removeMouseMovie_fun)	
			_target.addEventListener(MouseEvent.RELEASE_OUTSIDE,removeMouseMovie_fun)
			var id:int=0	
			for(var i:int = startNumber;i<=totalNumber;i++)
			{			
				var components:Class = getDefinitionByName(_className) as Class;
				_numberMovie3D = new components() 
			
				_numberMovie3D.text_movie.value_text.text = Add_Zero_Behind.add(ziro,i)
				_target.addChild(_numberMovie3D)	
				_numberMovie3D.text_movie.z = radius
				var D:Number =  (360/((totalNumber-startNumber)+1))
				var rotatX:Number = D*id 	
				_numberMovie3D.rotationX = rotatX
				_numberMovie3DArray.push(_numberMovie3D)
				id++
			}
			_target.z = -radius
			_target.rotationX  = -D*(currentNumber-startNumber)	
			computAlpha(currentNumber)
		}
		
		protected function mouseDown_fun(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			startYlocation = this.mouseY
			stopRol = false		
			this.addEventListener(Event.ENTER_FRAME,enterFrame_fun)
			this.addEventListener(Event.REMOVED_FROM_STAGE,removeEnterFrame)

		}
		
		protected function removeEnterFrame(event:Event):void
		{
			// TODO Auto-generated method stub
			unloadEnterFrame()
		
		}
		
		protected function removeMouseMovie_fun(event:MouseEvent):void
		{
			//startYlocation = this.mouseY
			stopRol = true	
		
		}
		protected function enterFrame_fun(event:Event):void
		{
			// TODO Auto-generated method stub
			moveEffect_fun()
		}

		private function moveEffect_fun()
		{
			
			if(!stopRol)
			{
				speedMin = ((this.mouseY-startYlocation)*move)+_target.rotationX
				spp = speedMin	

			}
			
			computExportNumber(_target.rotationX)
			_target.rotationX += (spp-_target.rotationX)/speed		
			 if(_target.rotationX>=360 || _target.rotationX<=-360)
			 {
				 _target.rotationX = 0
			 } 
		}

		private function computExportNumber(Rotat_p:Number)
		{
			var degree:Number = (360/((totalNumber-startNumber)+1))
			var roundRotat:int = Rotat_p	
			var exportNum:Number= Math.round(roundRotat/degree)
			var num:Number
			if(exportNum<0)
			{
				num =(-exportNum)+startNumber	
			}
			else if(exportNum>0)
			{
				num = ((totalNumber+1)-exportNum)		
			}
			else 
			{
				num = startNumber
			}
			if(stopRol)
			{
				spp = degree*Math.round(speedMin/degree)
				if(spp>=360 || spp<=-360)
				{
					spp = (Math.round((spp/360))*360)-spp
				} 
			}

			if(num!=numberValue)
			{
				numberValue = num
				this.dispatchEvent(new ThumbnailEvent(ThumbnailEvent.THUMB_CLICKED,this))
			}
			
			
			computAlpha(numberValue)
		}
		private function computAlpha(NumberValue_p:Number):void
		{
			var numberValue=NumberValue_p-startNumber

			for ( var index:int=0;index<=_numberMovie3DArray.length-1;index++)
			{			
				_numberMovie3DArray[index].visible = false
			}
			
			if(_numberMovie3DArray[numberValue]!=undefined)_numberMovie3DArray[numberValue].visible = true
			if(numberValue>=2)
			{		
				if(_numberMovie3DArray[numberValue-1]!=undefined)_numberMovie3DArray[numberValue-1].visible = true	
				if(_numberMovie3DArray[numberValue-2]!=undefined)_numberMovie3DArray[numberValue-2].visible = true
			}
			else if(numberValue>=1)
			{
				if(_numberMovie3DArray[numberValue-1]!=undefined)_numberMovie3DArray[numberValue-1].visible = true	
				if(_numberMovie3DArray[_numberMovie3DArray.length-1]!=undefined)_numberMovie3DArray[_numberMovie3DArray.length-1].visible = true

			}
			else if(numberValue>=0)
			{
				if(_numberMovie3DArray[_numberMovie3DArray.length-1]!=undefined)_numberMovie3DArray[_numberMovie3DArray.length-1].visible = true	
				if(_numberMovie3DArray[_numberMovie3DArray.length-2]!=undefined)_numberMovie3DArray[_numberMovie3DArray.length-2].visible = true

			}
			if(numberValue<=_numberMovie3DArray.length-3)
			{
				if(_numberMovie3DArray[numberValue+1]!=undefined)_numberMovie3DArray[numberValue+1].visible = true	
				if(_numberMovie3DArray[numberValue+2]!=undefined)_numberMovie3DArray[numberValue+2].visible = true
			}
			else if(numberValue<=_numberMovie3DArray.length-2)
			{
				if(_numberMovie3DArray[numberValue+1]!=undefined)_numberMovie3DArray[numberValue+1].visible = true	
				if(_numberMovie3DArray[0]!=undefined)_numberMovie3DArray[0].visible = true
			}
			else if(numberValue<=_numberMovie3DArray.length-1)
			{
				if(_numberMovie3DArray[0]!=undefined)_numberMovie3DArray[0].visible = true	
				if(_numberMovie3DArray[1]!=undefined)_numberMovie3DArray[1].visible = true
			}

		}
		public function unload():void
		{
			for ( var index:int=0;index<=_numberMovie3DArray.length-1;index++)
			{
				if(_numberMovie3DArray[index]!=undefined)
				{
					_target.removeChild(_numberMovie3DArray[index])
				}
				_numberMovie3DArray = new Array()
			}		
		}
		public function unloadEnterFrame():void
		{
			this.removeEventListener(Event.ENTER_FRAME,enterFrame_fun)	

		}
	}
	
}
