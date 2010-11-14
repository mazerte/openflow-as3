﻿package away3d.materials.shaders{	import away3d.arcane;	import away3d.containers.*;	import away3d.core.base.*;	import away3d.core.light.*;	import away3d.core.math.*;	import away3d.core.render.*;	import away3d.core.utils.*;		import flash.display.*;	import flash.geom.*;	import flash.utils.*;		use namespace arcane;		/**	 * Diffuse Dot3 shader class for directional lighting.	 * 	 * @see away3d.lights.DirectionalLight3D	 */    public class DiffuseDot3Shader extends AbstractShader    {		/** @private */        arcane override function updateMaterial(source:Object3D, view:View3D):void        {        	if (_bitmapDirty)        		invalidateFaces();        	        	var _source_lightarray_directionals:Array = source.lightarray.directionals;        	for each (var directional:DirectionalLight in _source_lightarray_directionals) {        		if (!directional.diffuseTransform[source] || view.scene.updatedObjects[source]) {        			directional.setDiffuseTransform(source);        			directional.setNormalMatrixDiffuseTransform(source);        			updateFaces(source, view);        		}        	}        }		/** @private */        arcane override function renderLayer(priIndex:uint, viewSourceObject:ViewSourceObject, renderer:Renderer, layer:Sprite, level:int):int        {        	super.renderLayer(priIndex, viewSourceObject, renderer, layer, level);        	        	var _lights_directionals:Array = _lights.directionals;        	for each (var directional:DirectionalLight in _lights_directionals)        	{        		if (_lights.numLights > 1) {					_shape = _session.getLightShape(this, level++, layer, directional);	        		_shape.filters = [directional.normalMatrixDiffuseTransform[_source]];	        		_shape.blendMode = blendMode;	        		_shape.transform.colorTransform = directional.ambientColorTransform;	        		_graphics = _shape.graphics;        		} else {        			layer.filters = [directional.normalMatrixDiffuseTransform[_source]];	        		layer.transform.colorTransform = directional.ambientColorTransform;	        		_graphics = layer.graphics;        		}        						_source.session.renderTriangleBitmap(_bitmap, getUVData(priIndex), _screenVertices, _screenIndices, _startIndex, _endIndex, smooth, false, _graphics);        	}						if (debug)                _source.session.renderTriangleLine(0, 0x0000FF, 1, _screenVertices, renderer.primitiveCommands[priIndex], _screenIndices, _startIndex, _endIndex);                        return level;        }                private var _zeroPoint:Point = new Point(0, 0);        private var _bitmap:BitmapData;        private var _normalDictionary:Dictionary = new Dictionary(true);        private var _normalBitmap:BitmapData;		private var _diffuseTransform:MatrixAway3D;		private var _szx:Number;		private var _szy:Number;		private var _szz:Number;		private var _normal0z:Number;		private var _normal1z:Number;		private var _normal2z:Number;		private var _bitmapDirty:Boolean;				protected override function calcUVT(priIndex:uint, uvt:Vector.<Number>):Vector.<Number>		{			priIndex;						uvt[2] = 1/(_focus + _screenVertices[_screenIndices[_startIndex]*3 + 2]);			uvt[5] = 1/(_focus + _screenVertices[_screenIndices[_startIndex + 1]*3 + 2]);			uvt[8] = 1/(_focus + _screenVertices[_screenIndices[_startIndex + 2]*3 + 2]);			uvt[0] = _uvs[0].u;    		uvt[1] = 1 - _uvs[0].v;    		uvt[3] = _uvs[1].u;    		uvt[4] = 1 - _uvs[1].v;    		uvt[6] = _uvs[2].u;    		uvt[7] = 1 - _uvs[2].v;    		    		return uvt;		}				/**		 * @inheritDoc		 */        public function updateFaces(source:Object3D = null, view:View3D = null):void        {        	source; view;        	        	notifyMaterialUpdate();        	        	for each (var faceMaterialVO:FaceMaterialVO in _faceDictionary)        		if (source == faceMaterialVO.source)	        		if (!faceMaterialVO.cleared)	        			faceMaterialVO.clear();        }        		/**		 * @inheritDoc		 */        public function invalidateFaces(source:Object3D = null, view:View3D = null):void        {        	source; view;        	        	_bitmapDirty = false;        	        	for each (var faceMaterialVO:FaceMaterialVO in _faceDictionary)        		faceMaterialVO.invalidated = true;        }        		/**		 * @inheritDoc		 */        protected override function renderShader(priIndex:uint):void        {			priIndex;						//check to see if normalDictionary exists			_normalBitmap = _normalDictionary[_faceVO];			if (!_normalBitmap || _faceMaterialVO.resized) {				_normalBitmap = _normalDictionary[_faceVO] = _parentFaceMaterialVO.bitmap.clone();				_normalBitmap.lock();			}						_n0 = _source.geometry.getVertexNormal(_face.v0);			_n1 = _source.geometry.getVertexNormal(_face.v1);			_n2 = _source.geometry.getVertexNormal(_face.v2);						var _source_lightarray_directionals:Array = _source.lightarray.directionals;			for each (var directional:DirectionalLight in _source_lightarray_directionals)	    	{				_diffuseTransform = directional.diffuseTransform[_source];												_szx = _diffuseTransform.szx;				_szy = _diffuseTransform.szy;				_szz = _diffuseTransform.szz;								_normal0z = _n0.x * _szx + _n0.y * _szy + _n0.z * _szz;				_normal1z = _n1.x * _szx + _n1.y * _szy + _n1.z * _szz;				_normal2z = _n2.x * _szx + _n2.y * _szy + _n2.z * _szz;								//check to see if the uv triangle lies inside the bitmap area				if (_normal0z > -0.2 || _normal1z > -0.2 || _normal2z > -0.2) {										//store a clone					if (_faceMaterialVO.cleared && !_parentFaceMaterialVO.updated) {						_faceMaterialVO.bitmap = _parentFaceMaterialVO.bitmap.clone();						_faceMaterialVO.bitmap.lock();					}										//update booleans					_faceMaterialVO.cleared = false;					_faceMaterialVO.updated = true;										//resolve normal map					_normalBitmap.applyFilter(_bitmap, _faceVO.face.bitmapRect, _zeroPoint, directional.normalMatrixDiffuseTransform[_source]);		            					//draw into faceBitmap					_faceMaterialVO.bitmap.draw(_normalBitmap, null, directional.diffuseColorTransform, blendMode);				}	    	}        }                //TODO: implement tangent space option        /**        * Determines if the DOT3 mapping is rendered in tangent space (true) or object space (false).        */        public var tangentSpace:Boolean;                /**        * Returns the width of the bitmapData being used as the shader DOT3 map.        */        public function get width():Number        {            return _bitmap.width;        }                /**        * Returns the height of the bitmapData being used as the shader DOT3 map.        */        public function get height():Number        {            return _bitmap.height;        }                /**        * Returns the bitmapData object being used as the shader DOT3 map.        */        public function get bitmap():BitmapData        {        	return _bitmap;        }                public function set bitmap(val:BitmapData):void        {        	_bitmap = val;        	        	_bitmapDirty = true;        }                /**        * Returns the argb value of the bitmapData pixel at the given u v coordinate.        *         * @param	u	The u (horizontal) texture coordinate.        * @param	v	The v (verical) texture coordinate.        * @return		The argb pixel value.        */        public function getPixel32(u:Number, v:Number):uint        {        	return _bitmap.getPixel32(u*_bitmap.width, (1 - v)*_bitmap.height);        }				/**		 * Creates a new <code>DiffuseDot3Shader</code> object.		 * 		 * @param	bitmap			The bitmapData object to be used as the material's DOT3 map.		 * @param	init	[optional]	An initialisation object for specifying default instance properties.		 */        public function DiffuseDot3Shader(bitmap:BitmapData, init:Object = null)        {            super(init);            			_bitmap = bitmap;			            tangentSpace = ini.getBoolean("tangentSpace", false);        }    }}