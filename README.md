matrect
=======

## Draw rectangles on images in Matlab and store their locations.

To use, make sure the files are in your path.

#### Sample Call:

`collect_data('/Users/astorer/Dev/matrect/img','alex')`

The first argument is the path to the image files.
The second argument is the name of the person drawing rectangles.  Their data will be stored in, e.g., `alex.mat`.

### Options

* `c` --  Press to change box from transparent to colored
* `r` --  Press and hold to use mouse to rotate box
* `x` --  Press and hold to scale x direction of box
* `y` --  Press and hold to scale y direction of box
* `1` --  Press and hold to move one side of the box in the x direction
* `2` --  Press and hold to move one side of the box in the x direction
* `3` --  Press and hold to move one side of the box in the y direction
* `4` --  Press and hold to move one side of the box in the y direction
* `n` --  Press to toggle between quit and continue when figure is closed
* Use the mouse to drag the box

### Data

Data is saved in the same location as the images, as `alex.dat`, or
whichever name was provided to the `collect_data` function.  This
contains a structure called `s`, which looks like this:

```
         id: 'alex'
    lastimg: 'SURFBOARDS-COVER.jpg'
       data: {[1x1 struct]  [1x1 struct]}
```

The data within `s` is a single rectangle:

```
>> s.data{1}

ans = 

      img: '1965lookingintoscience1.jpg'
    XData: [4x1 double]
    YData: [4x1 double]
     time: '28-Mar-2014 16:02:58'
```
