# TODO

### HUD based on uniforms
* Iris-exclusive `currentPlayerHealth` and `maxPlayerHealth` uniforms, among [others][uniforms]
* Draw a segmented health bar based on `currentPlayerHealth / maxPlayerHealth`
* Text akin to a console?
* Oscilloscope overlay/Hasselblad [reseau grid w/ fiducials][reticules]
* Option to invert `hideGui`

### Pixel size
* Virtualize large pixels
* Options `Horizontal` and `Vertical` resolution as well as border size
* Options for RGB subpixels and/or chromatic dispersion
* See Builder's code for reference

### Entity Radar
* Option to show through blocks

[reticules]: http://www.clavius.org/photoret.html
[uniforms]: https://github.com/IrisShaders/Iris/blob/1.18.2/src/main/java/net/coderbot/iris/uniforms/IrisExclusiveUniforms.java#L25-L32