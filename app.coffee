#experimental
express = require 'express'
app = express()
path = require('path')

app.engine 'hamlc', require('haml-coffee').__express
app.set("view engine", "hamlc")

app.use '/js', express.static(path.join(__dirname, '/public/js'))
app.use '/stylesheets', express.static(path.join(__dirname, '/public/stylesheets'))
app.use '/views', express.static(path.join(__dirname, '/views'))

app.get '/' , (req, res) ->
  res.render 'index', app: "A.C"

app.get '/tests' , (req, res) ->
  res.render 'SpecRunner'  

app.listen 3000  
console.log "listening on port 3000"