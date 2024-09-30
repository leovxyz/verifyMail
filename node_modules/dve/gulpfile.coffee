gulp = require 'gulp'

# utils
rename = require 'gulp-rename'
replace = require 'gulp-replace'
concat = require 'gulp-concat'
merge = require 'merge-stream'
sourcemaps = require 'gulp-sourcemaps'
npmpackage = require './package.json'
livereload = require 'gulp-livereload'

# interactive builds
gulp.task 'watch', ['watchcoffee', 'html', 'style'], ->
  livereload.listen()
  gulp.watch 'style/*.styl', ['style']
  gulp.watch 'index.html', ['html']

# build everything
gulp.task 'default', ['style', 'coffee']

# style
stylus = require 'gulp-stylus'
autoprefixer = require 'gulp-autoprefixer'
minifycss = require 'gulp-minify-css'
cssimport = require 'gulp-cssimport'

# compress stylus files and library css together
gulp.task 'style', ->
  styl = gulp.src 'style/index.styl'
    .pipe sourcemaps.init()
    .pipe stylus()
    .pipe autoprefixer browsers: ['last 2 versions', 'ie >= 10']
    .pipe cssimport() 
    .pipe rename "#{npmpackage.name}-#{npmpackage.version}.css"
    .pipe gulp.dest 'dist'
    .pipe minifycss(compatibility: '*,-properties.zeroUnits')
    .pipe rename "#{npmpackage.name}-#{npmpackage.version}.min.css"
    .pipe sourcemaps.write './'
    .pipe gulp.dest 'dist'
    .pipe livereload()

# coffee
browserify = require 'browserify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
uglify = require 'gulp-uglify'
watchify = require 'watchify'
errorify = require 'errorify'
gutil = require 'gulp-util'

# crawl using browserfy and include .coffee files
coffee = (options) ->
  shouldwatch = options?.watch? and options.watch
  browserifyargs =
    entries: './index.coffee'
    # output sourcemaps
    debug: yes
    # needed for watchify
    cache: {}
    packageCache: {}
    fullPaths: shouldwatch
    standalone: 'dve'
  bundler = browserify browserifyargs
  bundler = watchify bundler if shouldwatch
  # plugin to search for .coffee files first
  coffeefirst = (bundle) ->
    extensions = ['.coffee', '.cson', '.js', '.json']
    bundle._mdeps.options.extensions = extensions
    bundle._extensions = extensions
  bundler
    .plugin coffeefirst
    .on 'error', ->
      gutil.log.apply this, arguments
      bundler.end()
  if shouldwatch
    bundler.plugin errorify
    bundler.transform 'caching-coffeeify', global: yes
  else
    bundler.transform 'coffeeify', global: yes
  compressor = ->
    comp = bundler.bundle()
      .on 'error', ->
        gutil.log.apply this, arguments
        comp.end()
      .pipe source "#{npmpackage.name}-#{npmpackage.version}.min.js"
      .pipe buffer()
      .pipe sourcemaps.init loadMaps: yes
    # faster interactive builds
    comp.pipe uglify() unless shouldwatch
    comp
      .pipe sourcemaps.write './'
      .pipe gulp.dest 'dist'
      .pipe livereload()
  if shouldwatch
    bundler.on 'update', (files) ->
      for file in files
        gutil.log "M .#{file.substr __dirname.length}"
      compressor()
  compressor()

gulp.task 'coffee', -> coffee()
gulp.task 'watchcoffee', -> coffee watch: yes

gulp.task 'html', ->
  gulp.src 'index.html'
    .pipe livereload()
