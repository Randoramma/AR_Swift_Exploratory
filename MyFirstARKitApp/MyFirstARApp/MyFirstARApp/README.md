#  MyFirstARKitApp

### Chapter 1 - Getting Started with ARKit

Basically here we just setup Xcode and reviewed what AR kit is and how it works.. 

### Chapter 2 - My First AR App

#### Setting up ARKit ScreenKit View and ARSCNView Session

1. Created Xcode project
2. Setup view controller with an ARSCNView obnect bound to the safe areas of the main view
3. Within the View Controller imported AR Kit 
4. Created an outlet in the main vew controller for the SRSCNView. 
5. Within the viewWillAppear created the 'ARWorldTrackingConfiguration' object and applied it to the sceneView's run function.  
6. Within the viewWillDissapear we implemented the sceneView's pause function. 


#### Setting up Camera for AR Use 

1. Provided the Camera Usage Description permission within the Info.plist 
2. ARKit is not supported on the iOS simulator so must be run on the device.
3. Enabling developer permissions in Settings > Device Management may be required
4. Run app on device


#### Adding 3D objects to the ARSCNView 

1. Add cube object in ViewController 
2. Add boxNode
3. Set cube to the geometery of the boxNode
4. Create a scene object
5. Set the box node as the root node for the scene.
6. Set the scene object as the SceneView's scene. 

#### Adding Gesture Recognizer to the ARSCNView 

1. Code was refactored 
2. Added extension for the float3 object.. 
3. Refactored the addCube function
4. Refactored the didTap function



