package fr.mazerte.controls.openflow.env
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import fr.mazerte.controls.openflow.interpolator.IInterpolator;
	import fr.mazerte.controls.openflow.itemRenderer.IItemRenderer;
	import fr.mazerte.controls.openflow.layout.ILayout;
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	import fr.mazerte.controls.openflow.utils.eaze.transform3D.PapervisionAdapter;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.proto.DisplayObjectContainer3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	public class PapervisionEnv extends Sprite implements IEnv
	{
		protected var _layout:ILayout;
		protected var _interpolators:Array;
		
		private var _viewport:Viewport3D;
		private var _camera:Camera3D;
		private var _scene:Scene3D;
		private var _renderEngine:LazyRenderEngine;
		
		protected var _coverflowContainer:DisplayObject3D;
		protected var _coverflowContainerChildren:Array;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		public var clickToMove:Boolean = true
		
		public function PapervisionEnv(pClickToMove:Boolean = true)
		{
			clickToMove = pClickToMove;
			_coverflowContainerChildren = [];
			
			PapervisionAdapter.register();
		}
		
		public function init(layout:ILayout, interpolators:Array):void
		{
			_layout = layout;
			_interpolators = interpolators;
			
			_scene = new Scene3D();
			_camera = new Camera3D();
			_camera.z = -865;
			_camera.zoom = 100;
			
			_viewport = new Viewport3D(_width, _height);
			_viewport.interactive = true;

			_renderEngine = new LazyRenderEngine(_scene, _camera, _viewport);
			
			_coverflowContainer = new DisplayObject3D();
			_coverflowContainer.useOwnContainer = true;
			_scene.addChild(_coverflowContainer);
			
			addChild(_viewport);
			
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		public function update():void
		{
			/*var item:IItemRenderer;
			var m:MovieMaterial;
			var p:Plane;
			var coverflowContainerChildren:Array = [];
			for each(var child:Plane in _coverflowContainerChildren)
			{
			item = MovieMaterial(child.material).movie as IItemRenderer;
			
			child.removeEventListener(MouseEvent.MOUSE_DOWN, _itemMouseDownHandler);
			child.removeEventListener(MouseEvent.MOUSE_UP, _itemMouseUpHandler);
			_coverflowContainer.removeChild(p);
			
			m = new MovieMaterial(
			item as Sprite, true, true, true,
			new Rectangle(0, 0, Sprite(item).width, Sprite(item).height)
			);
			m.doubleSided = true;
			m.smooth = true;
			m.interactive = true;
			
			p = new Plane(
			m, 
			Sprite(item).width,  
			Sprite(item).height, 
			1, 
			1
			);
			p.useOwnContainer = true;
			
			p.addEventListener(MouseEvent.MOUSE_DOWN, _itemMouseDownHandler);
			p.addEventListener(MouseEvent.MOUSE_UP, _itemMouseUpHandler);
			
			p.transform = child.transform;
			
			coverflowContainerChildren.push(p);
			_coverflowContainer.addChild(p);
			}*/
		}
		
		private function _addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			
			stage.addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			
			addEventListener(Event.REMOVED_FROM_STAGE, _removedToStageHandler);
		}
		
		private function _removedToStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedToStageHandler);
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		public function addItem(item:IItemRenderer, seek:Number, index:int, withAnim:Boolean=true):void
		{
			var m:MovieMaterial = new MovieMaterial(
				item as Sprite, true, true, true,
				new Rectangle(0, 0, Sprite(item).width, Sprite(item).height)
			);
			m.doubleSided = true;
			m.smooth = true;
			m.interactive = true;
			
			var p:Plane = new Plane(
				m, 
				Sprite(item).width,  
				Sprite(item).height, 
				1, 
				1
			);
			p.useOwnContainer = true;
			
			p.addEventListener(MouseEvent.MOUSE_DOWN, _itemMouseDownHandler);
			p.addEventListener(MouseEvent.MOUSE_UP, _itemMouseUpHandler);
			
			var position:AbstractMatrix3D = _layout.getPostion(index, seek);
			for each(var interpolator:IInterpolator in _interpolators)
			{
				if(withAnim)
					interpolator.addInterpolationItem(p, position, index, seek);
				else
					interpolator.interpolationItem(p, position, index, seek);
			}
			
			_coverflowContainerChildren.splice(index, 0, p);
			_coverflowContainer.addChild(p);
		}
		
		public function removeItem(item:IItemRenderer, withAnim:Boolean=true):void
		{			
			for(var i:uint = 0; i < _coverflowContainerChildren.length; i++)
			{
				if(MovieMaterial(Plane(_coverflowContainerChildren[i]).material).movie == item)
				{
					if(withAnim)
					{
						var duration:Number = 0;
						var tmpDuration:Number;
						for each(var interpolator:IInterpolator in _interpolators)
						{
							tmpDuration = interpolator.removeInterpolationItem(_coverflowContainerChildren[i], i, 0);
							duration = (tmpDuration > duration) ? tmpDuration : duration;
						}
						
						setTimeout(
							function(item:Plane):void
							{
								_coverflowContainer.removeChild(item);
							}, duration * 1000, _coverflowContainerChildren[i]
						);
						_coverflowContainerChildren.splice(i, 1);
					}
					else
					{
						_coverflowContainer.removeChild(_coverflowContainerChildren[i] as Plane);
						_coverflowContainerChildren.splice(i, 1);
					}
				}
			}
		}
		
		public function setSeek(seek:Number, withAnim:Boolean=true):void
		{
			var item:Plane;
			for(var i:uint = 0; i < _coverflowContainerChildren.length; i++)
			{
				item = _coverflowContainerChildren[i] as Plane;
				MovieMaterial(item.material).interactive = false;
				var position:AbstractMatrix3D = _layout.getPostion(i, seek);
				for each(var interpolator:IInterpolator in _interpolators)
				{
					if(withAnim)
						interpolator.moveInterpolationItem(item, position, i, seek);
					else
						interpolator.interpolationItem(item, position, i, seek);
				}
			}
			
			if(seek == Math.round(seek))
			{
				item = _coverflowContainerChildren[seek] as Plane;
				MovieMaterial(item.material).interactive = true;
			}
		}
		
		
		private var _item:Plane;
		private var _itemMouseDown:Boolean = false;
		
		private function _itemMouseDownHandler(event:MouseEvent):void
		{
			if(!clickToMove)
				return;
			
			_item = event.currentTarget as Plane;
			_itemMouseDown = true;
		}
		
		private function _itemMouseUpHandler(event:MouseEvent):void
		{
			if(!clickToMove)
				return;
			
			if(_item && _item == event.currentTarget && _itemMouseDown)
			{
				var item:Plane;
				for(var i:uint = 0; i < _coverflowContainerChildren.length; i++)
				{
					item = _coverflowContainerChildren[i] as Plane;
					if(item ==  event.currentTarget)
						dispatchEvent(new EnvEvent(EnvEvent.SEEK, i));
				}
			}
		}
		
		
		public function resize(width:Number, height:Number):void
		{
			_viewport.viewportWidth = width;
			_viewport.viewportHeight = height;
			
			_width = width;
			_height = height;
		}
		
		
		public function get layout():ILayout
		{
			return _layout;
		}
		
		public function set layout(l:ILayout):void
		{
			_layout = l;
		}
		
		public function get interpolators():Array
		{
			return _interpolators;
		}
		
		public function set interpolators(a:Array):void
		{
			_interpolators = a;
		}
		
		
		private function _enterFrameHandler(event:Event):void
		{
			_renderEngine.renderScene(_scene, _camera, _viewport);
		}
		
		public function dispose():void
		{
		}
	}
}