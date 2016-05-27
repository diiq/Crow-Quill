var gulp = require('gulp');
var es6transpiler = require('gulp-es6-transpiler');
var argv = require('yargs').argv;
var changed = require('gulp-changed');
var concat = require('gulp-concat');
var fs = require('fs');
var gutil = require('gulp-util');
var plumber = require('gulp-plumber');
var revall = require('gulp-rev-all');
var sourcemaps = require('gulp-sourcemaps');


gulp.task('build/dev/js', function() {
  gulp.src(['app/app.js', '!app/**/*Test.js', 'config/dev.js'])
    .pipe(changed('build/dev', {extension: '.js'}))
    .pipe(sourcemaps.init())
    .pipe(plumber(compileError))
    .pipe(es6transpiler())
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

  gulp.src(['app/**/*.coffee', '!app/**/*Test.coffee', configFile])
    .pipe(es6transpiler())
    .pipe(concat('main.js'))
    .pipe(revall())
    .pipe(gulp.dest('build/dist.tmp'));
});

// This is here to make the terminal beep when js compilation fails
var compileError = function(error) {
  gutil.beep();
  gutil.log(
    gutil.colors.red('CoffeeScript compilation error:'),
    error.toString()
  );
};
