# Model

# set namespace
com = {} if not com?
com.tkthompson = {} if not com.tkthompson?
com.tkthompson.model = {} if not com.tkthompson.model?

com.tkthompson.model.getImageUrls = (name, count) ->
    total = count
    imgUrls = while count -= 1
        num = total - count 
        "/images/#{name}/#{name}-#{num}.jpg"
    
  