var gulp = require('gulp');
var browserSync = require('browser-sync');
var del = require('del');
var path = require('path');
var reload = browserSync.reload;


gulp.task('watch', ['watch/dev']);

gulp.task('watch/dev', ['build/dev'], function() {
  gulp.watch(['app/**/*.js', '!app/**/*Test.js', 'config/dev.js'], ['build/dev/js', 'jasmine', 'build/dev/index.html', reload]);
  gulp.watch(['app/**/*.scss'], ['build/dev/css', function() {}]);
  gulp.watch(['app/index.html'], ['build/dev/index.html', reload]);
  gulp.watch(['app/**/*.js', 'app/**/*.scss', 'bower_components/**/*.js', '!app/**/*Test.js'], function(event) {
    if (event.type === "added") {
      gulp.start('build/dev/index.html', function() {
        return reload();
      });
    }
    if (event.type === "deleted") {
      return del(getDestPathFromSrcPath(event.path, 'build/dev'), function() {
        return gulp.start('build/dev/index.html', function() {
          return reload();
        });
      });
    }
  });

  return gulp.watch(['app/**/*.png', 'app/**/*.jpg', 'app/**/*.gif', 'app/**/*.svg', 'app/**/*.ico'], function(event) {
    if (event.type === "added" || event.type === "changed") {
      gulp.start('build/dev/images', function() {
        return reload();
      });
    }
    if (event.type === "deleted") {
      return del(getDestPathFromSrcPath(event.path, 'build/dev'), function() {
        return reload();
      });
    }
  });
});

gulp.task('watch/test', ['build/test/unit', 'jasmine'], function() {
  gulp.watch(['app/**/*Test.js'], ['jasmine']);

  return gulp.watch(['app/**/*Test.js'], function(event) {
    if (event.type === "deleted") {
      return del(getDestPathFromSrcPath(event.path, 'build/test'));
    }
  });
});

var getDestPathFromSrcPath = function(srcFile, destDirectory) {
  var destPath, relPath;
  relPath = path.relative(path.resolve('app'), srcFile);
  destPath = path.resolve(destDirectory, relPath);
  switch (path.extname(srcFile)) {
    case ".js":
      return path.join(path.dirname(destPath), path.basename(destPath, ".js")) + ".js";
    case ".scss":
      return path.join(path.dirname(destPath), path.basename(destPath, ".scss")) + ".css";
    default:
      return destPath;
  }
};
