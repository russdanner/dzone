
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
<!-- three.js library -->
<script src='/static-assets/vendor/threejs/three.js'></script>
<script src="/static-assets/vendor/threejs/loaders/MTLLoader.js"></script>
<script src="/static-assets/vendor/threejs/loaders/OBJLoader.js"></script>

<!-- jsartookit -->
<script src="/static-assets/vendor/jsartoolkit5/build/artoolkit.min.js"></script>
<script src="/static-assets/vendor/jsartoolkit5/js/artoolkit.api.js"></script>

<!-- include threex.artoolkit -->
<script src="/static-assets/vendor/threex/threex-artoolkitsource.js"></script>


<body style='margin : 0px; overflow: hidden; font-family: Monospace; user-select: none;'>

<script>
	var modelObj; 

	var renderer	= new THREE.WebGLRenderer({
		antialias: true,
		alpha: true
	});

	renderer.setClearColor(new THREE.Color('lightgrey'), 0)
	renderer.setSize( window.innerWidth, window.innerHeight );
	renderer.domElement.style.position = 'absolute'
	renderer.domElement.style.top = '0px'
	renderer.domElement.style.left = '0px'

	document.body.appendChild( renderer.domElement );

	renderer.autoClear = false;

	var onRenderFcts= [];

	// init scene and camera
	var scene	= new THREE.Scene();
	var ambient = new THREE.AmbientLight( 0x666666 );
	scene.add( ambient );

	var directionalLight = new THREE.DirectionalLight( 0x887766 );
	directionalLight.position.set( -1, 1, 1 ).normalize();
	scene.add( directionalLight );
	
	// Initialize a basic camera
	var camera = new THREE.Camera();
	var cameraRatio = window.innerWidth / window.innerHeight;
	var camera = new THREE.PerspectiveCamera( 75, cameraRatio, 0.1, 1000 );
	camera.position.z = 10;

	// Initialize the camera
	var arToolkitSource = new THREEx.ArToolkitSource({
		// to read from the webcam 
		sourceType : 'webcam',
	});

	arToolkitSource.init(function onReady(){
		// handle resize of renderer
		arToolkitSource.onResize(renderer.domElement)		
	});
	
	// handle resize
	window.addEventListener('resize', function(){
		// handle arToolkitSource resize
		arToolkitSource.onResize(renderer.domElement)		
	});


	function loadModelIntoScene(modelData, scene) {
      // Load the 3D Model
      var objectLoader = new THREE.OBJLoader();
      var mtlLoader = new THREE.MTLLoader();

      mtlLoader.setPath(modelData.basePath);
      mtlLoader.load(modelData.mtlPath, function (materialCreator) {
          materialCreator.preload();
          var materials = materialCreator.materials;
   
          objectLoader.setMaterials(materialCreator);
  
          objectLoader.load(modelData.objPath, function ( obj ) {				 	
              scene.add( obj );
  
              obj.scale.set(.2,.2,.2).multiplyScalar(modelData.scaleMultiplier);
              obj.rotation.x = modelData.xRotation; 
              obj.position.x = modelData.xPosition;
              obj.position.y = modelData.yPosition;
          });			
      });
   	};
    
	// no longer needed as these are provided by the CMS / controller
	//var model =  { id: "pikachu", scale: 5, xRotation: 0 };
	//var model =  { id: "snorlax", scale: 1, xRotation: 0 };

	<#list pokemonInstances as pokemonInstance>

      <#assign texturePath = pokemonInstance.model.textureFile.item[0].key />
      <#assign objectPath = pokemonInstance.model.objectFile.item[0].key />
      
      loadModelIntoScene({ 
      	basePath: "${texturePath?substring(0, texturePath?last_index_of('/')+1)}",
        mtlPath: "${texturePath?substring(texturePath?last_index_of('/') + 1)}",
        objPath: "${objectPath}",
        scaleMultiplier: ${pokemonInstance.scaleMultiplier},
        xPosition: ${pokemonInstance.xPosition},
        yPosition: ${pokemonInstance.yPosition},
        xRotation: ${pokemonInstance.model.xRotation}}, scene);
        
	</#list>	
    
	// render the scene
	onRenderFcts.push(function(){
		renderer.clear();
		renderer.render( scene, camera );		
	})

	// run the rendering loop
	var lastTimeMsec= null
	requestAnimationFrame(function animate(nowMsec){
		// keep looping
		requestAnimationFrame( animate );
		// measure time
		lastTimeMsec	= lastTimeMsec || nowMsec-1000/60
		var deltaMsec	= Math.min(200, nowMsec - lastTimeMsec)
		lastTimeMsec	= nowMsec
		// call each update function
		onRenderFcts.forEach(function(onRenderFct){
			onRenderFct(deltaMsec/1000, nowMsec/1000)
		})
	})
</script></body>
