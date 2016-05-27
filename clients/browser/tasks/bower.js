var gulp = require('gulp');
var bowerFiles = require('main-bower-files');
var changed = require('gulp-changed');
var concat = require('gulp-concat');
var filter = require('gulp-filter');
var flatten = require('gulp-flatten');
var revall = require('gulp-rev-all');
var sourcemaps = require('gulp-sourcemaps');

gulp.task('build/dev/bower', function() {
  return gulp.src(bowerFiles(), {
    base: 'bower_components'
  }).pipe(changed('build/dev/bower_components')).pipe(gulp.dest('build/dev/bower_components'));
});

gulp.task('build/dist/bower.js', function() {
  return gulp.src(bowerFiles(), {
    base: 'bower_components'
  }).pipe(filter('**/*.js')).pipe(concat('bower.js')).pipe(revall()).pipe(gulp.dest('build/dist.tmp'));
});

gulp.task('build/dist/bower.css', function() {
  return gulp.src(bowerFiles(), {
    base: 'bower_components'
  }).pipe(filter('**/*.css')).pipe(revall()).pipe(concat('bower.css')).pipe(revall()).pipe(gulp.dest('build/dist.tmp'));
});

gulp.task('build/dist/bower/fonts', function() {
  return gulp.src(bowerFiles(), {
    base: 'bower_components'
  })
  .pipe(filter(['**/*.eot', '**/*webfont.svg', '**/*.ttf', '**/*.woff', '**/*.otf']))
  .pipe(flatten())
  .pipe(revall())
  .pipe(gulp.dest('build/dist/fonts'));
});
