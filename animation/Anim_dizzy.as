package animation
{
    import flash.display.DisplayObjectContainer;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.geom.Rectangle;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.filters.BlurFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;

    public class Anim_dizzy
    {
        private var dizzyAreaMC:DisplayObjectContainer ;

        private var dizzyBitmap:Bitmap,
                    bitmapData:BitmapData;

        private const extraEreaOnDizzy:uint = 2 ;

        private const dizzyResolution:uint = 2 ;


        private var diz:Number = 0,
                    dizzyX:Number=0,dizzyY:Number=0,
                    dizzyRad:Number=0 ;

        private const dizzyRadS:Number = 0.05;

        public function Anim_dizzy(area:DisplayObjectContainer,size:Rectangle,dizzy:Number=5)
        {
            diz = dizzy/dizzyResolution ;

            bitmapData = new BitmapData((size.width+(extraEreaOnDizzy*0)*2)/dizzyResolution,(size.height+(extraEreaOnDizzy*0)*2)/dizzyResolution,true,0x00000000);
            dizzyBitmap = new Bitmap(bitmapData);
            dizzyBitmap.x = size.x ;
            dizzyBitmap.y = size.y ;
            dizzyBitmap.scaleX = dizzyBitmap.scaleY = dizzyResolution ;

            dizzyAreaMC = area ;
            dizzyAreaMC.addEventListener(Event.ENTER_FRAME,anim,false,-10);

            dizzyAreaMC.addChild(dizzyBitmap);
        }

        private function anim(event:Event):void
        {
            dizzyAreaMC.addChild(dizzyBitmap);

            dizzyBitmap.visible = false ;
            bitmapData.lock();
            var ct:ColorTransform = new ColorTransform(1,1,1,0.1);
            var mat:Matrix = new Matrix(1/dizzyResolution,0,0,1/dizzyResolution);
            if(diz!=0)
            {
                dizzyRad += dizzyRadS ;
                
                dizzyX=(Math.sin(dizzyRad))*diz;
                dizzyY=(Math.cos(dizzyRad))*diz;



                mat.tx = dizzyX;
                mat.ty = dizzyY;
            }
            bitmapData.draw(dizzyAreaMC,mat,ct);
            bitmapData.applyFilter(bitmapData,bitmapData.rect,new Point(),new BlurFilter(4/dizzyResolution,4/dizzyResolution));
            bitmapData.unlock();

            dizzyBitmap.visible = true ;
        }
    }
}