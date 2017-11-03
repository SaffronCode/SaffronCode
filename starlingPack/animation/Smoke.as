/**
 * Created by mes on 03/11/2017.
 */
package starlingPack.animation {
import starling.display.Canvas;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;

import starlingPack.core.ObjStarling;

public class Smoke extends Sprite {


    private var smokes:Vector.<Canvas> = new Vector.<Canvas>();

    private var sX:Vector.<Number> = new Vector.<Number>();
    private var sY:Vector.<Number> = new Vector.<Number>();
    private var sA:Vector.<Number> = new Vector.<Number>();
    private var sW:Vector.<Number> = new Vector.<Number>();

    private var areaW:Number,areaH:Number,total:uint;

    public function Smoke(X:Number,Y:Number,AreaWidth:Number,AreaHeight:Number,totalSmokes:uint) {
        super();

        areaW = AreaWidth ;
        areaH = AreaHeight ;
        total = totalSmokes ;

        this.x = X ;
        this.y = Y ;

        if(this.stage!=null)
            added();
        else
            this.addEventListener(Event.ADDED_TO_STAGE,added);
    }

    private function added(event:Event=null):void {
        this.removeEventListener(Event.ADDED_TO_STAGE,added);
        for(var i:int = 0 ; i<total ; i++)
        {
            var circ:Canvas = new Canvas();
            sX.push(Math.random()-0.5);
            sY.push(Math.random()-0.5);
            sA.push(Math.random()*0.02+0.05);
            sW.push(Math.random());
            circ.beginFill(0xccbc70,0.4);
            circ.drawCircle(0,0,20);
            circ.filter = new BlurFilter(2,2,1);
            circ.x = this.x+Math.random()*areaW-areaW/2 ;
            circ.y = this.y+Math.random()*areaH-areaH/2 ;
            circ.alpha=0;
            smokes.push(circ);
            this.parent.addChild(circ);
        }
        this.addEventListener(Event.ENTER_FRAME,anim);
        this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
    }

    private function unLoad(event:Event):void {
        this.removeEventListener(Event.ENTER_FRAME,anim);
        for(var i:int = 0 ; i<smokes.length ; i++)
        {
            ObjStarling.remove(smokes[i]);
        }
    }

    private function anim(e:Event):void
    {
        for(var i:int = 0 ; i<smokes.length ; i++)
        {
            smokes[i].alpha+=sA[i];
            if(smokes[i].alpha>=1)
            {
                sA[i] = Math.abs(sA[i])/-2;
            }
            smokes[i].x+=sX[i];
            smokes[i].y+=sY[i];
            smokes[i].width+=sW[i];
            smokes[i].height = smokes[i].width;
            if(smokes[i].alpha<=0)
            {
                ObjStarling.remove(smokes[i]);
                smokes.removeAt(i);
            }
        }

        if(smokes.length==0)
        {
            ObjStarling.remove(this);
        }
    }
}
}
