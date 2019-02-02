# visualodometry

The dataset can be found here:
https://robotcar-dataset.robots.ox.ac.uk/

Create two folders named model and stereo in the same directory as the codes. Then place the model information in the folder named "model" and place the stereo pair images in the folder named "stereo". Now you're ready to run the code.

# How to run the code?

Hybrid_code.m
WithMatlabfunctions.m
WithoutMatlabfunctions.m

are the three main codes, each will output a slightly different visual odometry.
As it can be seen below, Hybrid approach generated the most accurate trajectory.

![Output](/trajectories.png)

The red road in the image below shows the entire dataset whereas the yellow circle shows the part that I tested my code with.
Notice that the Hybrid code outputs a very accurate representation of the actual road.

![Dateset Route](/route-map.png)
