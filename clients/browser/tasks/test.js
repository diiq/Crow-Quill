var gulp = require('gulp');
var changed = require('gulp-changed');
var babel = require('gulp-babel');
var gutil = require('gulp-util');
var plumber = require('gulp-plumber');
var sourcemaps = require('gulp-sourcemaps');


gulp.task('build/test/unit', function() {
  return gulp.src(['app/**/*Test.coffee'])
    .pipe(changed('build/test', {
      extension: '.js'
    }))
    .pipe(sourcemaps.init())
    .pipe(plumber(compileError))
    .pipe(babel({
      presets: ['es2015']
    }))
    .pipe(plumber.stop())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('build/test'));
});

var compileError = function(error) {
  gutil.beep();
  return gutil.log(gutil.colors.red('CoffeeScript test compilation error:'), error.toString());
};
