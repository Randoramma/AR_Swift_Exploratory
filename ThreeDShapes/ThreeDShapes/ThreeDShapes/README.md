#  3D Shapes 

### Initial Setup 
1. App was setup using the ARProject template 
2. Session configuration was setup in the viewWillAppear
3. Status label was added to the main storyboard
4. Status label was wired up to the ViewController
5. Shape Factory file and enum was added to the project. 
6. 'shapeForValue' and 'shapeNodes' properties were added to the ViewController. 
7. 'addShape' function was added to the ViewController. 

### Setting Up Plane Detection 
#### Plane detection allows us to be aware of our surroundings. 
#### Planes are detected using 'feature points' 

1. Added VirtualPlane Class
2. Added 'planes' property to ViewController 
3. Added 'Plane Detection Delegate' in ViewController 
4. Added 'Virtual Plane Update and Setup Functions' methods to VirtualPlane Class
5. Updated setupScene with debugging options. 



