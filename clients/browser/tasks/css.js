var gulp = require('gulp');
var browserSync = require('browser-sync');
var cache = require('gulp-cached');
var concat = require('gulp-concat');
var filter = require('gulp-filter');
var gutil = require('gulp-util');
var naturalSort = require('gulp-natural-sort');
var path = require('path');
var reload = browserSync.reload;
var revall = require('gulp-rev-all');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');


var compileError;

gulp.task('build/dev/css', function() {
  return gulp.src('app/**/*.scss').pipe(sourcemaps.init()).pipe(sass({
    includePaths: ['bower_components/', 'app/shared_styles', 'app/'],
    onError: compileError
  })).pipe(sourcemaps.write())
     .pipe(naturalSort())
     .pipe(gulp.dest('build/dev'))
     .pipe(filter('**/*.css'))
     .pipe(cache('css'))
     .pipe(reload({
       stream: true
     }));
});

gulp.task('build/dist/main.css', function() {
  return gulp.src('app/**/*.scss').pipe(sass({
    includePaths: ['bower_components/', 'app/shared_styles', 'app/']
  })).pipe(naturalSort())
     .pipe(concat('main.css'))
     .pipe(revall())
     .pipe(gulp.dest('build/dist.tmp'));
});

compileError = function(error) {
  var fileName;
  fileName = path.relative(path.resolve(__dirname, '..'), error.file);
  gutil.beep();
  return gutil.log(
    gutil.colors.red("SASS error") +
      gutil.colors.white(" (") +
      gutil.colors.magenta(fileName + ":" + error.line) +
      gutil.colors.white("): ") +
      gutil.colors.white(error.message));
};
