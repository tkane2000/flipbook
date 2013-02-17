flipbook
========

Flips through a list of images to create an animation.  This is not a 'page turn' plugin (often called a flipbook) such as the ones found here: http://smashfreakz.com/2012/09/jquery-page-flip-book-plugins/.

This plugin uses the HTML5 canvas element and so is not supported on IE8:
http://caniuse.com/#search=canvas

If that's an issue, there are other options out there.  Here are a couple:
http://code.pea53.com/jquery-ui.flipbook/
http://inscopeapps.com/demos/flipbook/

Usage: (In CoffeeScript for now)
--------------------------------------------
# You are responsible for preloading images!

# Most simple usage: ---------------
$canvas.click (e) ->
    $(this).flipbook
        images:$images

# Add some extra configs: ----------
$canvas.click (e) ->
    $(this).flipbook
	    images:$images
		filters:[com.tkthompson.Filters.grayscale]
		innerShadow:true
		ms:120

# A more complicated config: ------
# Set options before running so you can have an image in the canvas before the animation starts
# Use jQuery deferred object methods 'done' and 'progress' to listen for events

$canvas.flipbook 'setOptions', 
    images:$images
    filters:[com.tkthompson.Filters.grayscale]
    innerShadow:true
    # loop:true
    ms:200

$canvas.flipbook 'drawImg', $images[0]

$canvas.click (e) ->
    $canvas.flipbook().done((status, el) -> 
        console.log "status: #{status}"
        console.log "element: #{el}"
    ).progress((status) -> 
        console.log "status: #{status}"
    )


