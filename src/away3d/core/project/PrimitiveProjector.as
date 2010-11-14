package away3d.core.project
{
	import away3d.arcane;
	import away3d.cameras.*;
	import away3d.cameras.lenses.*;
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.clip.*;
	import away3d.core.geom.*;
	import away3d.core.math.*;
	import away3d.core.render.*;
	import away3d.core.session.*;
	import away3d.core.utils.*;
	import away3d.core.vos.*;
	import away3d.materials.*;
	import away3d.sprites.*;
	
	import flash.utils.Dictionary;
	
	use namespace arcane;
	
	public class PrimitiveProjector
	{
		/** @private */
		arcane var _cameraVarsStore:CameraVarsStore;
		/** @private */
		arcane var _screenVertices:Array;
		/** @private */
		arcane var _screenIndices:Array;
		/** @private */
		arcane var _viewSourceObject:ViewSourceObject;
		private var _view:View3D;
		private var _screenVerticesStore:Dictionary = new Dictionary(true);
		private var _screenIndicesStore:Dictionary = new Dictionary(true);
		private var _viewSourceObjectStore:Dictionary = new Dictionary(true);
		private var _mesh:Mesh;
		private var _clipFlag:Boolean;
		private var _defaultStartIndices:Array = new Array();
		private var _startIndices:Array;
		private var _defaultVertices:Array = new Array();
		private var _vertices:Array;
		private var _defaultClippedFaceVOs:Array = new Array();
		private var _faceVOs:Array;
		private var _defaultClippedSegmentVOs:Array = new Array();
		private var _segmentVOs:Array;
		private var _defaultClippedBillboards:Array = new Array();
		private var _spriteVOs:Array;
		private var _camera:Camera3D;
		private var _clipping:Clipping;
		private var _lens:AbstractLens;
		private var _outlineIndices:Dictionary = new Dictionary(true);
		private var _material:Material;
		private var _area:Number;
		private var _face:Face;
		private var _faceVO:FaceVO;
		private var _index:uint;
		private var _startIndex:uint;
		private var _endIndex:uint;
        private var _backface:Boolean;
		private var _backmat:Material;
		private var _frontmat:Material;
		private var _segmentVO:SegmentVO;
		private var _smaterial:Material;
		private var _spriteVO:SpriteVO;
		private var _spmaterial:Material;
		private var _bMaterial:BitmapMaterial;
		private var _scale:Number;
		private var _n01:Face;
		private var _n12:Face;
		private var _n20:Face;
		private var _dofCache:DofCache;
		private var _cameraViewMatrix:MatrixAway3D;
		private var _viewTransformDictionary:Dictionary;
		private var _container:ObjectContainer3D;
		private var _screenX:Number;
        private var _screenY:Number;
        private var _screenZ:Number;
		private var _i:int;
		private var _depthPoint:Number3D = new Number3D();
        private var _sIndex:uint;
		private var _eIndex:uint;
		private var _pushfront:Boolean;
		private var _pushback:Boolean;
		
		
        public function getScreenVertices(source:Object3D):Array
		{
			return _screenVerticesStore[source] || (_screenVerticesStore[source] = []);
		}
		
		public function getScreenIndices(source:Object3D):Array
		{
			return _screenIndicesStore[source] || (_screenIndicesStore[source] = []);
		}

		public function getViewSourceObject(source:Object3D):ViewSourceObject
		{
			return _viewSourceObjectStore[source] || (_viewSourceObjectStore[source] = new ViewSourceObject(source));
		}
		
        public function PrimitiveProjector(view:View3D)
        {
        	_view = view;
        	_cameraVarsStore = _view.cameraVarsStore;
        }
        
		public function project(source:Object3D, viewTransform:MatrixAway3D, renderer:Renderer):void
		{
			_cameraVarsStore.createVertexClassificationDictionary(source);
			
			_mesh = source as Mesh;
			_camera = _view.camera;
			_clipping = _view.screenClipping;
			_lens = _camera.lens;
        	
			_frontmat = _mesh.material;
			_backmat = _mesh.back || _frontmat;
			
            //check if an element needs clipping
            _clipFlag = _cameraVarsStore.nodeClassificationDictionary[source] == Frustum.INTERSECT && !(_clipping is RectangleClipping);
            
			if (_clipFlag) {
            	_vertices = _defaultVertices;
				_vertices.length = 0;
				_screenIndices = getScreenIndices(source);
				_screenIndices.length = 0;
            	_startIndices = _defaultStartIndices;
				_startIndices.length = 0;
            	_faceVOs = _defaultClippedFaceVOs;
				_faceVOs.length = 0;
            	_segmentVOs = _defaultClippedSegmentVOs;
				_segmentVOs.length = 0;
            	_spriteVOs = _defaultClippedBillboards;
				_spriteVOs.length = 0;
            	_clipping.checkElements(_mesh, _faceVOs, _segmentVOs, _spriteVOs, _vertices, _screenIndices, _startIndices);
			} else {
            	_vertices = _mesh.vertices;
            	_screenIndices = _mesh.indices;
            	_startIndices = _mesh.startIndices;
            	_faceVOs = _mesh.faceVOs;
            	_segmentVOs = _mesh.segmentVOs;
            	_spriteVOs = _mesh.spriteVOs;
            }
            
			_screenVertices = getScreenVertices(source);
			_screenVertices.length = 0;
            _lens.project(viewTransform, _vertices, _screenVertices);
            
			_viewSourceObject = getViewSourceObject(source);
			_viewSourceObject.screenVertices = _screenVertices;
			_viewSourceObject.screenIndices = _screenIndices;
            
			if (_mesh.outline) {
            	_i = _faceVOs.length;
            	while (_i--)
            		_outlineIndices[_faceVOs[_i]] = _i;
            }
            
            _i = 0;
			//loop through all clipped faces
            for each (_faceVO in _faceVOs) {
				
				_startIndex = _startIndices[_i++];
                _endIndex = _startIndices[_i];
                
				if (!_clipFlag) {
					_index = _startIndex;
					
					while (_screenVertices[_screenIndices[_index]*3] != null && _index < _endIndex)
						_index++;
					
					if (_index < _endIndex)
						continue;
				}
                
				//determine if _triangle is facing towards or away from camera
                _backface = (_area = _viewSourceObject.getArea(_startIndex)) < 0;
            	
            	
				
				//if _triangle facing away, check for backface material
                if (_backface) {
                    if (!_mesh.bothsides)
                    	continue;
                    
                    _material = _faceVO.back;
                    
                    if (!_material)
                    	_material = _faceVO.material;
                } else {
                    _material = _faceVO.material;
                }
                
				//determine the material of the _triangle
                if (!_material) {
                    if (_backface)
                        _material = _backmat;
                    else
                        _material = _frontmat;
                }
                
				//do not draw material if visible is false
                if (_material && !_material.visible)
                    _material = null;
				
				//if there is no material and no outline, continue
                if (!_mesh.outline && !_material)
                	continue;
                
                
                if (_mesh.outline && !_backface) {
	                _pushfront = _mesh.pushfront;
	                _pushback = _mesh.pushback;
            		_mesh.pushback = false;
            		_mesh.pushfront = true;
                }
                
                //check whether screenClipping removes triangle
                if (!renderer.primitive(renderer.createDrawTriangle(_faceVO, _faceVO.commands, _faceVO.uvs, _material, _startIndex, _endIndex, _viewSourceObject, _area, _faceVO.generated)))
                	continue;
				
            	_face = _faceVO.face;
                
                if (_mesh.outline && !_backface) {
            		_mesh.pushback = true;
            		_mesh.pushfront = false;
                    _n01 = _mesh.geometry.neighbour01(_face);
                    if (_n01 == null || _viewSourceObject.getArea(_startIndices[_outlineIndices[_n01.faceVO]]) <= 0) {
                    	_segmentVO = _cameraVarsStore.createSegmentVO(_mesh.outline);
                    	_sIndex = _screenIndices.length;
                    	_screenIndices[_screenIndices.length] = _screenIndices[_startIndex];
                    	_screenIndices[_screenIndices.length] = _screenIndices[_startIndex+1];
                    	_eIndex = _screenIndices.length;
                    	renderer.primitive(renderer.createDrawSegment(_segmentVO, _segmentVO.commands, _mesh.outline, _sIndex, _eIndex, _viewSourceObject, true));
                    }
					
                    _n12 = _mesh.geometry.neighbour12(_face);
                    if (_n12 == null || _viewSourceObject.getArea(_startIndices[_outlineIndices[_n12.faceVO]]) <= 0) {
                    	_segmentVO = _cameraVarsStore.createSegmentVO(_mesh.outline);
                    	_sIndex = _screenIndices.length;
                    	_screenIndices[_screenIndices.length] = _screenIndices[_startIndex+1];
                    	_screenIndices[_screenIndices.length] = _screenIndices[_startIndex+2];
                    	_eIndex = _screenIndices.length;
                    	renderer.primitive(renderer.createDrawSegment(_segmentVO, _segmentVO.commands, _mesh.outline, _sIndex, _eIndex, _viewSourceObject, true));
                    }
                    
                    _n20 = _mesh.geometry.neighbour20(_face);
                    if (_n20 == null || _viewSourceObject.getArea(_startIndices[_outlineIndices[_n20.faceVO]]) <= 0) {
                    	_segmentVO = _cameraVarsStore.createSegmentVO(_mesh.outline);
                    	_sIndex = _screenIndices.length;
                    	_screenIndices[_screenIndices.length] = _screenIndices[_startIndex+2];
                    	_screenIndices[_screenIndices.length] = _screenIndices[_startIndex];
                    	_eIndex = _screenIndices.length;
                    	renderer.primitive(renderer.createDrawSegment(_segmentVO, _segmentVO.commands, _mesh.outline, _sIndex, _eIndex, _viewSourceObject, true));
                    }
	                _mesh.pushfront = _pushfront;
	                _mesh.pushback = _pushback;
                }
                
            }
            
            for each (_segmentVO in _segmentVOs)
            {
				_startIndex = _startIndices[_i++];
                _endIndex = _startIndices[_i];
                
				if (!_clipFlag) {
					_index = _startIndex;
					
					while (_screenVertices[_screenIndices[_index]*3] != null && _index < _endIndex)
						_index++;
					
					if (_index < _endIndex)
						continue;
				}
				
            	_smaterial = _segmentVO.material || _frontmat;
				
                if (!_smaterial.visible)
                    continue;
                
                //check whether screenClipping removes segment
                renderer.primitive(renderer.createDrawSegment(_segmentVO, _segmentVO.commands, _smaterial, _startIndex, _endIndex, _viewSourceObject, _segmentVO.generated));
            }
            
            //loop through all clipped sprites
            for each (_spriteVO in _spriteVOs)
            {
            	_startIndex = _startIndices[_i++];
				_endIndex = _startIndices[_i];
				
				if (!_clipFlag) {
					_index = _startIndex;
					
					while (_screenVertices[_screenIndices[_index]*3] != null && _index < _endIndex)
						_index++;
					
					if (_index < _endIndex)
						continue;
				}
                
                //switch materials for directional sprites
				if (_spriteVO.materials.length) {
					var minZ:Number = Infinity;
					var z:Number;
					_index = _endIndex - _startIndex;
		            while (_index--) {
		                z = _screenVertices[(_startIndex + _index)*3 + 2];
		                
		                if (minZ > z) {
		                    minZ = z;
		                    if (_index)
		                    	_spmaterial = _spriteVO.materials[_index - 1];
		                    else
		                    	_spmaterial = _spriteVO.material || _frontmat;
		                }
		            }
				} else {
					_spmaterial = _spriteVO.material || _frontmat;
				}
				
                if (!_spmaterial.visible)
                    continue;
		        
		        _index = _screenIndices[_startIndex]*3;
		        _screenZ = _screenVertices[_index + 2];
		        
		        if (_spriteVO.distanceScaling)
		        	_scale = _spriteVO.scaling*_lens.getPerspective(_screenZ);
		        else
		        	_scale = _spriteVO.scaling;
		        
		        if (_spriteVO.displayObject) {
					switch(_spriteVO.align){
						case SpriteAlign.CENTER:
							_screenVertices[_index] -= _spriteVO.displayObject.width/2;
							_screenVertices[_index + 1] -= _spriteVO.displayObject.height/2;
							break;
						case SpriteAlign.TOP:
							_screenVertices[_index] -= _spriteVO.displayObject.width/2;
							break;
						case SpriteAlign.BOTTOM:
							_screenVertices[_index] -= _spriteVO.displayObject.width/2;
							_screenVertices[_index + 1] -= _spriteVO.displayObject.height;
							break;
						case SpriteAlign.RIGHT:
							_screenVertices[_index] -= _spriteVO.displayObject.width;
						    _screenVertices[_index + 1] -= _spriteVO.displayObject.height/2;
						  break;
						case SpriteAlign.TOP_RIGHT:
							_screenVertices[_index] -= _spriteVO.displayObject.width;
							break;
						case SpriteAlign.BOTTOM_RIGHT:
							_screenVertices[_index] -= _spriteVO.displayObject.width;
							_screenVertices[_index + 1] -= _spriteVO.displayObject.height;
							break;
						case SpriteAlign.LEFT:
							_screenVertices[_index + 1] -= _spriteVO.displayObject.height/2;
							break;
						case SpriteAlign.TOP_LEFT:
							break;
						case SpriteAlign.BOTTOM_LEFT:				
							_screenVertices[_index + 1] -= _spriteVO.displayObject.height;
							break;
					}
		            renderer.primitive(renderer.createDrawDisplayObject(_spriteVO, _startIndex, _viewSourceObject, _scale));
		        } else {
		        	
		        	if (_spriteVO.depthOfField && (_bMaterial = _spmaterial as BitmapMaterial)) {
		        		_dofCache = DofCache.getDofCache(_bMaterial);
		            	renderer.primitive(renderer.createDrawSprite(_spriteVO, _dofCache.getBitmapMaterial(_screenZ), _startIndex, _viewSourceObject, _scale));
		        	} else {
		        		renderer.primitive(renderer.createDrawSprite(_spriteVO, _spmaterial, _startIndex, _viewSourceObject, _scale));
		        	}
            	}
		    }
		    
		    _container = source as ObjectContainer3D;
			
			if (!_container)
				return;
			
			_cameraViewMatrix = _view.camera.viewMatrix;
			_viewTransformDictionary = _view.cameraVarsStore.viewTransformDictionary;
			
			var _container_children:Array = _container.children;
			var child:Object3D;
        	for each (child in _container_children) {
				if (child.ownCanvas && child.visible) {
					
					if (child.ownSession is SpriteSession)
						(child.ownSession as SpriteSession).cacheAsBitmap = true;
					
					_screenX = child.screenXOffset;
					_screenY = child.screenYOffset;
					
					if (!isNaN(child.ownSession.screenZ)) {
						_screenZ = child.ownSession.screenZ;
					} else {
						if (child.scenePivotPoint.modulo) {
							_depthPoint.clone(child.scenePivotPoint);
							_depthPoint.rotate(_depthPoint, _cameraViewMatrix);
							_depthPoint.add(_viewTransformDictionary[child].position, _depthPoint);
							
			             	_screenZ = _depthPoint.modulo;
							
						} else {
							_screenZ = _viewTransformDictionary[child].position.modulo;
						}
			            
		             	if (child.pushback)
		             		_screenZ += child.parentBoundingRadius;
		             		
		             	if (child.pushfront)
		             		_screenZ -= child.parentBoundingRadius;
		             		
		             	_screenZ += child.screenZOffset;
	    			}
	    			
					_screenIndices.push(_index = _screenVertices.length/3);
					_screenVertices.push(_screenX, _screenY, _screenZ);
					child.spriteVO.displayObject = child.session.getContainer(_view);
					renderer.primitive(renderer.createDrawDisplayObject(child.spriteVO, _index, _viewSourceObject, 1));
				}
        	}
		}
	}
}