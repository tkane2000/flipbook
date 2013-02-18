### controller ###

# set namespace
if not com? then com = {}
if not com.tkthompson? then com.tkthompson = {} 
window.com = com
    
com.tkthompson.preloadImgs = (urls, callback) ->
    imgTags = ""

    concatImgTags = ->
        imgTags = "#{imgTags}<img />"

    setSrc = (i, img) ->
        url = urls[i-1]
        img.src = url
        # console.log "setSrc: url: #{url}"
    
    concatImgTags imgUrl for imgUrl in urls
    imgs = $("#{imgTags}") 
    setSrc i + 1, img for img, i in imgs
    imgs.imagesLoaded 
        callback : ($images, $proper, $broken) ->
            callback $images, $proper, $broken


com.tkthompson.Filters = 
    grayscale : (pixels) ->
        d = pixels.data
        i = 0
            
        while i < d.length
            r = d[i]
            g = d[i + 1]
            b = d[i + 2]
            
            # CIE luminance for the RGB
            # The human eye is bad at seeing red and blue, so we de-emphasize them.
            v = 0.2126 * r + 0.7152 * g + 0.0722 * b
            d[i] = d[i + 1] = d[i + 2] = v
            i += 4
        pixels

# Entry Point:
$(document).ready ->
    model = com.tkthompson.model
    $canvas = $("canvas")
    $canvasEl = $canvas[0]
    onImagesLoaded = ($images, $proper, $broken) ->
        
        $canvas.flipbook 'setOptions', 
            images:$images
            filters:[com.tkthompson.Filters.grayscale]
            innerShadow:true
            # loop:true
            ms:200

        $canvas.flipbook 'drawImg', $images[0]
        
        $('.start').click (e) ->
            e.preventDefault()
            $canvas.flipbook()

        $canvas.click (e) ->
            $canvas.flipbook().done((status, el) -> 
                console.log "status: #{status}"
                console.log "element: #{el}"
            ).progress((status) -> 
                console.log "status: #{status}"
            )
                

        $('.filterToggle').data('filterToggleBool', true).click (e) ->
            e.preventDefault()
            bool = if $(this).data('filterToggleBool') then false else true
            $(this).data('filterToggleBool', bool);
            fltrs = if bool then [com.tkthompson.Filters.grayscale] else []
            $canvas.flipbook 'setOption','filters',fltrs 
            $canvas.flipbook 'drawImg', $images[0]
        
        $('.gradientToggle').data('gradientToggleBool', true).click (e) ->
            e.preventDefault()
            bool = if $(this).data('gradientToggleBool') then false else true
            $(this).data('gradientToggleBool', bool);
            $canvas.flipbook 'setOption', 'innerShadow', bool 
            $canvas.flipbook 'drawImg', $images[0]
    
    urls = model.getImageUrls('surf', 30)
    imgs = com.tkthompson.preloadImgs(urls, onImagesLoaded)
    
    
###
obj = 
    hello: (name) ->
        console.log "Hello " + name

defer = new $.Deferred()
defer.promise obj 
defer.resolve "John" 
 
obj.done ( name ) ->
    obj.hello name
.hello "Karl"   
###