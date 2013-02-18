# jquery.flipbook.js
# Copyright 2013, Trevor Thompson
# Licensed under the MIT License.

###

author: Trevor Thompson
flipbook plugin


TODO:
    add comments
    copyright
    memory leak?
    jsperf
    set bg color to black when you get a portrait image and fix gradient
    responsive?
    X: event handling (use deferred object?)
     - complete
     - nextImage
     - ...can be used in a scrubber
    X: ability to set gradient in options
    X: make sure width and height are variable
### 

do($=jQuery) ->
    'use strict'
    pluginName = 'flipbook'
    defaults = 
        loop:false
        ms:300
        # bgColor:'#000'
        images:[]
        filters:[]
        innerShadow:false
    
    Plugin = (element, options) ->
        @element = element
        @$element = $(element)
        @w = @$element.width()
        @h = @$element.height()
        @ctx = @element.getContext("2d")
        @i = 0
        @options = null
        @setOptions options if typeof options isnt 'string'
        @timeoutId = 0
        @grd=null
        @setRadialGradient()
        @dfd = null
        @
        
    Plugin.prototype.setOptions = (options) ->
        @options = options or {}
        @options = $.extend {}, defaults, options

    Plugin.prototype.setOption = (key, value) ->
        @options = @options or {}
        @options[key] = value if key? and value?

    Plugin.prototype.getCenterX = (img) ->
        (@$element.width() - $(img).width()) / 2
    
    Plugin.prototype.setRadialGradient = ->
        console.log 'setRadialGradient'
        @grd=@ctx.createRadialGradient(400,260,250,420,200,480)
        @grd.addColorStop(0,"transparent")
        @grd.addColorStop(1,"black")
        
    Plugin.prototype.applyFilter = (filter, var_args) ->
        args = [@getPixels()]
        i = 2
    
        while i < arguments.length
            args.push arguments[++i]
        
        filter.apply null, args
        
    Plugin.prototype.runFilter = (filter) ->
        idata = @applyFilter filter
        c = @$element # TODO: use $(@element)? 
        c.width(idata.width)
        c.height(idata.height)
        @ctx.putImageData(idata, 0, 0)
    
    Plugin.prototype.getPixels = ->
        @ctx.getImageData 0, 0, @element.width, @element.height

    Plugin.prototype.addInnerShadow = ->
        @ctx.fillStyle=@grd
        @ctx.fillRect(0,0,@w,@h)
        
    Plugin.prototype.drawImg = (img) ->
        x = if img.width < @$element.width() then @getCenterX(img) else 0
        @ctx.drawImage img, x, 0
        @runFilter filter for filter in @options.filters
        @addInnerShadow() if @options.innerShadow

    Plugin.prototype.drawImgByIndex = (i) ->
        img = @options.images[i]
        @drawImg(img)
        
    Plugin.prototype.flip = ->
        options = @options
        imgs = options.images
        len = imgs.length
        if len > @i
            # @timeoutId = window.requestAnimFrame =>
            @timeoutId = setTimeout =>
                img = @drawImg(imgs[@i])
                @i = @i+1
                if @i < len
                    if @dfd.state() is "pending"
                        @dfd.notify @i
                    @flip options
                else
                    @i = 0
                    @dfd.resolve "finished!", @element
                    @flip options if options.loop
                img
            , options.ms
        else
            console.log "ERROR: index is over length of images" 
        imgs

    Plugin.prototype.reset = ->
        clearTimeout @timeoutId
        @i=0
        
    $.fn.flipbook = (options) ->
        plugin = null
        args = Array.prototype.slice.call( arguments, 1 )
        dfd = $.Deferred()
        dfd.promise @
        @each ->
            plugin = $.data(this, 'plugin_' + pluginName)
            if (!plugin)
                if typeof options isnt 'string' or not options.images?
                    plugin = new Plugin(@, options)
                    $.data this, 'plugin_' + pluginName, plugin
                else
                    console.log 'You need to set the image list before doing anything else!'
            
            plugin.dfd = dfd if plugin
            
            if typeof options is 'string' and plugin[options]
                plugin[options].apply plugin, args
            else if ( typeof options is 'object' )
                plugin.reset()
                plugin.setOptions options
                plugin.flip()
            else if (typeof options is 'undefined' or options is null)
                plugin.reset()
                plugin.flip()
            else
                $.error('Method ' +  options + ' does not exist on jQuery.flipbook.  \nmethods: ' + plugin )
        
