var gulp = require('gulp');


// Build the development site
gulp.task(
  'build/dev',
  [
    'build/dev/index.html',
    'build/dev/js',
    'build/dev/css',
    'build/dev/bower',
    'build/dev/images'
  ]);

// Build the tests and test dependencies
gulp.task('build/test', ['build/test/unit']);

// Run all the tests and exit
gulp.task('test', ['test/unit', 'lint']);

// Run tests against dist
gulp.task('test/dist', ['test/dist/unit']);

// Run the dev server and test runner, in debug mode
gulp.task('test/unit/debug', ['server/dev','build/dev', 'watch', 'test/unit/debug']);

// Just dist stuff
gulp.task('dist', ['build/dist', 'server/dist']);

// Run the dev server and test runner while watching for changes
gulp.task('default', ['build/dev', 'server/dev', 'watch']);
