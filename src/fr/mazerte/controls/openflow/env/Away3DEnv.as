/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.env
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.TargetCamera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Mesh;
	import away3d.core.math.Number3D;
	import away3d.core.render.Renderer;
	import away3d.events.MouseEvent3D;
	import away3d.materials.MovieMaterial;
	import away3d.primitives.Plane;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import fr.mazerte.controls.openflow.interpolator.IInterpolator;
	import fr.mazerte.controls.openflow.itemRenderer.IItemRenderer;
	import fr.mazerte.controls.openflow.layout.ILayout;
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	import fr.mazerte.controls.openflow.utils.eaze.transform3D.Away3DAdapter;
	
	import mx.utils.ArrayUtil;
	
	public class Away3DEnv extends Sprite implements IEnv
	{
		protected static const _CAMERA_INIT_ZOOM:Number = 10;
		protected static const _CAMERA_INIT_FOCUS:Number = 100;
		
		protected static const _CAMERA_INIT_POS_X:Number = 0;
		protected static const _CAMERA_INIT_POS_Y:Number = 0;
		protected static const _CAMERA_INIT_POS_Z:Number = -1000;
		
		protected var _seek:Number = 0;
		
		protected var _view:View3D;
		protected var _camera:Camera3D;
		protected var _scene:Scene3D;
		
		protected var _layout:ILayout;
		protected var _interpolators:Array;
		
		protected var _coverflowContainer:ObjectContainer3D;
		protected var _coverflowContainerChildren:Array;
		protected var _coverflowContainerChildrenDict:Dictionary;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		public var clickToMove:Boolean = true;
		public var useOverAnimation:Boolean = true;
		
		public function Away3DEnv(pClickToMove:Boolean = true, pUseOverAnimation:Boolean = true)
		{
			clickToMove = pClickToMove;
			useOverAnimation = pUseOverAnimation;
			
			_coverflowContainerChildren = [];
			_coverflowContainerChildrenDict = new Dictionary();
			
			Away3DAdapter.register();
		}
		
		public function init(layout:ILayout, interpolators:Array):void
		{
			_layout = layout;
			_interpolators = interpolators;
			
			_scene = new Scene3D();
			
			_camera = new TargetCamera3D({
				zoom:	_CAMERA_INIT_ZOOM, 
				focus:	_CAMERA_INIT_FOCUS, 
				x:		_CAMERA_INIT_POS_X, 
				y:		_CAMERA_INIT_POS_Y, 
				z:		_CAMERA_INIT_POS_Z
			}
			);
			_camera.lookAt(new Number3D(
				_CAMERA_INIT_POS_X, 
				_CAMERA_INIT_POS_Y, 
				_CAMERA_INIT_POS_Z
			));
			_camera.lens = new PerspectiveLens();
			
			_view = new View3D( { 
				scene:  _scene, 
				camera: _camera,
				width:  _width, 
				height: _height
			} );
			
			_view.renderer = Renderer.BASIC;
			
			_view.x = _width >> 1;
			_view.y = _height >> 1;
			
			_coverflowContainer = new ObjectContainer3D();
			_coverflowContainer.y = 0;
			//_coverflowContainer.ownCanvas = true;
			_scene.addChild(_coverflowContainer);
			
			_coverflowContainerChildren = [];
			
			addChild(_view);
			
			addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
		}
		
		public function update():void
		{
			var item:IItemRenderer;
			var m:MovieMaterial;
			for each(var child:Plane in _coverflowContainerChildren)
			{
				m = child.material as MovieMaterial;
				item = m.movie as IItemRenderer;
				
				m = new MovieMaterial(item as Sprite, {
					interactive:  false,
					smooth:       true,
					lockW:        Sprite(item).width,
					lockH:        Sprite(item).height
				});
				
				child.width = Sprite(item).width;
				child.height = Sprite(item).height;
				
				child.material = m;
			}
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
		
		public function addItem(item:IItemRenderer, seek:Number, index:int, withAnim:Boolean = true):void
		{
			var m:MovieMaterial = new MovieMaterial(item as Sprite, {
				interactive:  true,
				smooth:       true,
				lockW:        Sprite(item).width,
				lockH:        Sprite(item).height
			});
			
			var p:Plane = new Plane({
				width: 		Sprite(item).width,
				height: 	Sprite(item).height,
				material: 	m,
				ownCanvas: true,
				bothsides: true
			});
			
			p.addEventListener(MouseEvent3D.MOUSE_DOWN, _itemMouseDownHandler);
			p.addEventListener(MouseEvent3D.MOUSE_UP, _itemMouseUpHandler);
			p.addEventListener(MouseEvent3D.MOUSE_OVER, _itemMouseOverHandler);
			p.addEventListener(MouseEvent3D.MOUSE_OUT, _itemMouseOutHandler);
			
			var position:AbstractMatrix3D = _layout.getPostion(index, seek)
			for each(var interpolator:IInterpolator in _interpolators)
			{
				if(withAnim)
					interpolator.addInterpolationItem(p, position, index, seek);
				else
					interpolator.interpolationItem(p, position, index, seek);
			}
			
			_coverflowContainerChildren.splice(index, 0, p);
			_coverflowContainerChildrenDict[p] = item;
			_coverflowContainer.addChild(p);
		}
		
		public function removeItem(item:IItemRenderer, withAnim:Boolean=true):void
		{	
			for(var i:uint = 0; i < _coverflowContainerChildren.length; i++)
			{
				if(MovieMaterial(Mesh(_coverflowContainerChildren[i]).material).movie == item)
				{
					Mesh(_coverflowContainerChildren[i]).removeEventListener(MouseEvent3D.MOUSE_DOWN, _itemMouseDownHandler);
					Mesh(_coverflowContainerChildren[i]).removeEventListener(MouseEvent3D.MOUSE_UP, _itemMouseUpHandler);
					
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
							function(item:Mesh):void
							{
								_coverflowContainer.removeChild(item);
							}, duration * 1000, _coverflowContainerChildren[i]
						);
					}
					else
					{
						_coverflowContainer.removeChild(_coverflowContainerChildren[i] as Mesh);
					}
					
					delete _coverflowContainerChildrenDict[_coverflowContainerChildren[i]];
					_coverflowContainerChildren.splice(i, 1);
				}
			}
		}
		
		
		public function setSeek(seek:Number, withAnim:Boolean = true):void
		{
			//_itemMouseDown = false;
			_seek = seek;
			
			if(!_coverflowContainerChildren || _coverflowContainerChildren.length < 1)
				return;
			
			var item:Mesh;
			for(var i:uint = 0; i < _coverflowContainerChildren.length; i++)
			{
				item = _coverflowContainerChildren[i] as Mesh;
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
				item = _coverflowContainerChildren[seek] as Mesh;
				if(item)
					MovieMaterial(item.material).interactive = true;
			}
		}
		
		
		private var _item:Mesh;
		private var _itemMouseDown:Boolean = false;
		
		private function _itemMouseDownHandler(event:MouseEvent3D):void
		{
			if(!clickToMove)
				return;
				
			_item = event.currentTarget as Mesh;
			_itemMouseDown = true;
		}
		
		private function _itemMouseUpHandler(event:MouseEvent3D):void
		{
			if(!clickToMove)
				return;
			
			if(_item && _item == event.currentTarget && _itemMouseDown)
			{
				var item:Mesh;
				for(var i:uint = 0; i < _coverflowContainerChildren.length; i++)
				{
					item = _coverflowContainerChildren[i] as Mesh;
					if(item ==  event.currentTarget)
						dispatchEvent(new EnvEvent(EnvEvent.SEEK, i));
				}
			}
			
			_itemMouseDown = false;
		}
		
		private function _itemMouseOverHandler(event:MouseEvent3D):void
		{
			if(!_coverflowContainerChildrenDict[event.currentTarget])
				return;
			
			IItemRenderer(_coverflowContainerChildrenDict[event.currentTarget]).rollOver();
			if(useOverAnimation)
			{
				var index:int = ArrayUtil.getItemIndex(event.currentTarget, _coverflowContainerChildren);
				for(var i:uint = 0; i < _coverflowContainerChildren.length; i++)
				{
					for each(var interpolator:IInterpolator in _interpolators)
						interpolator.overInterpolationItem(_coverflowContainerChildren[i], _layout.getRollOverPostion(i, _seek, index), i, _seek);
				}
			}
		}
		
		private function _itemMouseOutHandler(event:MouseEvent3D):void
		{
			_itemMouseDown = false;
			
			IItemRenderer(_coverflowContainerChildrenDict[event.currentTarget]).rollOver();
			if(useOverAnimation)
			{
				for(var i:uint = 0; i < _coverflowContainerChildren.length; i++)
				{
					for each(var interpolator:IInterpolator in _interpolators)
						interpolator.moveInterpolationItem(_coverflowContainerChildren[i], _layout.getPostion(i, _seek), i, _seek);
				}
			}
		}
		
		
		public function resize(width:Number, height:Number):void
		{
			_view.x = width >> 1;
			_view.y = height >> 1;
			
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
			_view.render();
		}
		
		public function dispose():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedToStageHandler);
			stage.removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			
			removeChild(_view);
			
			_view = null;
			_camera = null;
			_scene = null;
			
			_layout = null;
			_interpolators = null;
			
			for each(var p:Plane in _coverflowContainer.children)
			{
				p.removeEventListener(MouseEvent3D.MOUSE_DOWN, _itemMouseDownHandler);
				p.removeEventListener(MouseEvent3D.MOUSE_UP, _itemMouseUpHandler);
				IItemRenderer(_coverflowContainerChildren[p]).dispose();
				_coverflowContainer.removeChild(p);
			}
			
			_coverflowContainerChildren = [];
			_coverflowContainerChildrenDict = new Dictionary();
			
			_coverflowContainerChildren = null;
		}
	}
}