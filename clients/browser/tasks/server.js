var gulp = require('gulp');
var browserSync = require('browser-sync');
var connect = require('gulp-connect');
var modRewrite = require('connect-modrewrite');


// Any paths without a . in them will get served index.html instead
var rewrite = modRewrite([ '^[^\\.]*$ /index.html [L]' ]);

gulp.task('server/dev', ['build/dev'], function() {
  return browserSync({
    open: false,
    notify: false,
    server: {
      baseDir: 'build/dev',
      middleware: [rewrite]
    }
  });
});

gulp.task('test/e2e/webserver', ['build/dev'], function() {
  return connect.server({
    port: 3001,
    root: 'build/dev',
    middleware: function() {
      return [rewrite];
    }
  });
});

gulp.task('server/dist', function() {
  return connect.server({
    port: 3000,
    root: 'build/dist',
    middleware: function() {
      return [rewrite];
    }
  });
});

gulp.task('test/dist/e2e/webserver', ['build/dist'], function() {
  return connect.server({
    port: 3001,
    root: 'build/dist',
    middleware: function() {
      return [rewrite];
    }
  });
});
