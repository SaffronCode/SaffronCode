package animation
//animation.Folower
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.geom.Point;
    import contents.alert.Alert;

    public class Folower extends MovieClip
    {
        private var leader:MovieClip ;

        public function Folower()
        {
            super();
            if(this.name.indexOf('instan')==0)
            {
                throw "You should name your MovieClip to folow the same MovieClip on the stage";
            }
            if(this.stage!=null)
            {
                setUp(null)
            }
            else
            {
                this.addEventListener(Event.ADDED_TO_STAGE,setUp);
            }
        }

        private function findMyLeader():MovieClip
        {
            if(leader!=null && leader.stage!=null)
            {
                return leader;
            }
            leader = null ;
            var sames:Array = Obj.getAllChilds(this.name,this.stage);
            for(var i:int = 0 ; i<sames.length ; i++)
            {
                leader = sames[i] as MovieClip ;
                if(this!=leader && leader!=null)
                {
                    break;
                }
            }
            return leader ;
        }

        private function setUp(e:Event):void
        {
            animate(null);
            this.addEventListener(Event.ENTER_FRAME,animate,false,-10000);
            this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
        }

        private function unLoad(event:Event):void
        {
            this.removeEventListener(Event.ENTER_FRAME,animate);
            this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
        }

        private function animate(event:Event):void
        {
            var lead:MovieClip = findMyLeader();
            if(lead==null)
            {
                this.visible = false ;
                return ;
            }
            this.visible = true ;
            var leaderGlobalPoint:Point = lead.localToGlobal(new Point());
            var myPoint:Point = this.parent.globalToLocal(leaderGlobalPoint);
            this.x = myPoint.x;
            this.y = myPoint.y ;
        }
    }
}