var gulp = require('gulp');
var imagemin = require('gulp-imagemin');
var revall = require('gulp-rev-all');


var imageFiles = ['app/**/*.png', 'app/**/*.jpg', 'app/**/*.gif', 'app/**/*.svg', 'app/**/*.ico'];

gulp.task('build/dev/images', function() {
  return gulp.src(imageFiles)
             .pipe(gulp.dest('build/dev'));
});

gulp.task('build/dist/images', function() {
  return gulp.src(imageFiles)
             .pipe(revall({
               ignore: [/^\/static\//]
              }))
             .pipe(imagemin())
             .pipe(gulp.dest('build/dist'));
});
