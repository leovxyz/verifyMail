# DVE

Visualisations built from a simple json structure.

Styles can be required from `style/dve.styl'. DVE visualisations must be wrapped in a `.dve-container` to work.

## Chart layout

```
                            container                            
 ________________________________________________________________
|                                               |                |
|                                               |                |
|      ___________________________________      |                |
|     |                                   |     |                |
|     |                                   |     |                |
|     |                                   |     |                |
|     |                                   |     |                |
|     |               inner               |     |     legend     |
|     |                                   |     |                |
|     |                                   |     |                |
|     |                                   |     |                |
|     |___________________________________|     |                |
|                                               |                |
|                                               |                |
|_______________________________________________|________________|
```

The container is the element passed to dve. Its width should be set in CSS, but DVE may override with a max/min width.

The inner contains the actual graph. Axes, labels, and titles sit outside of the inner.

Legends and other extra areas are offest from the inner and its margins. These will usually have fixed widths.

Usually, the size of inner will be dynaimc. Ideally, the inner width will be the width of the provided container, less any legend and margin. However, if the container is too small or too big, the inner may decide to override this.

