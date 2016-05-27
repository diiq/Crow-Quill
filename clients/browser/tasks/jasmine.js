var gulp = require('gulp');
var jasmine = require('gulp-jasmine');
var depsOrder = require('gulp-deps-order');
var naturalSort = require('gulp-natural-sort');
var concat = require('gulp-concat');


gulp.task('jasmine', ['build/dev', 'build/test/unit'], function() {
  return gulp.src('build/dev/**/*Test.js').pipe(jasmine({
    vendor: ['build/dev/bower_components/**/**.js', 'build/dev/**/**.js'],
    jasmineVersion: '2.3'
  }));
});
