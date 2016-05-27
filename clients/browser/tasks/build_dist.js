var gulp = require('gulp');
var concat = require('gulp-concat');
var del = require('del');
var revall = require('gulp-rev-all');
var minifyCSS = require('gulp-minify-css');
var uglify = require('gulp-uglify');


gulp.task('build/dist', ['build/dist/index.html', 'build/dist/app.js', 'build/dist/app.css', 'build/dist/images', 'build/dist/bower/fonts'], function() {
  return del.sync(['build/dist.tmp']);
});

gulp.task('build/dist/app.js', ['build/dist/bower.js', 'build/dist/main.js'], function() {
  del.sync(['build/dist/app.*.js']);
  return gulp.src(['build/dist.tmp/bower.*.js', 'build/dist.tmp/main.*.js']).pipe(concat('app.js')).pipe(uglify()).pipe(revall()).pipe(gulp.dest('build/dist'));
});

gulp.task('build/dist/app.css', ['build/dist/main.css', 'build/dist/bower.css'], function() {
  del.sync(['build/dist/app.*.css']);
  return gulp.src(['build/dist.tmp/bower.*.css', 'build/dist.tmp/main.*.css']).pipe(concat('app.css')).pipe(minifyCSS()).pipe(revall()).pipe(gulp.dest('build/dist'));
});
