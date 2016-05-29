var gulp = require('gulp');
var changed = require('gulp-changed');
var babel = require('gulp-babel');
var gutil = require('gulp-util');
var plumber = require('gulp-plumber');
var sourcemaps = require('gulp-sourcemaps');
var rollup = require('gulp-rollup');
var rollupIncludePaths = require('rollup-plugin-includepaths');


gulp.task('build/test/unit', function() {
  return gulp.src(['app/**/*Test.js'])
    .pipe(changed('build/test', {
      extension: '.js'
    }))
    .pipe(sourcemaps.init())
    .pipe(plumber(compileError))
    .pipe(rollup({
      sourceMap: true,
      plugins: [
        rollupIncludePaths({paths: ['app']})
      ]}))
    .pipe(babel({
      presets: ['es2015']
    }))
    .pipe(plumber.stop())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('build/test'));
});

var compileError = function(error) {
  gutil.beep();
  return gutil.log(gutil.colors.red('js test compilation error:'), error.toString());
};
