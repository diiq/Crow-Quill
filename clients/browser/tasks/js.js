var gulp = require('gulp');
var babel = require('gulp-babel');
var argv = require('yargs').argv;
var changed = require('gulp-changed');
var concat = require('gulp-concat');
var fs = require('fs');
var gutil = require('gulp-util');
var plumber = require('gulp-plumber');
var revall = require('gulp-rev-all');
var sourcemaps = require('gulp-sourcemaps');
var rollup = require('gulp-rollup');
var rollupIncludePaths = require('rollup-plugin-includepaths');

gulp.task('build/dev/js', function() {
  gulp.src(['app/app.js'])
    .pipe(changed('build/dev', {extension: '.js'}))
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
    .pipe(gulp.dest('build/dev'));
});

gulp.task('build/dist/main.js', function() {
  var configFile = "config/" + argv.config + ".js";

  if (!fs.existsSync(configFile)) {
    console.error("Config file (#{configFile}) not found.");
    process.exit(1);
  }

  gulp.src(['app/app.js'])
    .pipe(plumber(compileError))
    .pipe(rollup({
        plugins: [
          rollupIncludePaths({paths: ['app']})
        ]}))
    .pipe(babel({
			presets: ['es2015']
		}))
    .pipe(plumber.stop())
    .pipe(gulp.dest('build/dist'));
});

// This is here to make the terminal beep when js compilation fails
var compileError = function(error) {
  gutil.beep();
  gutil.log(
    gutil.colors.red('JS compilation error:'),
    error.toString()
  );
};
