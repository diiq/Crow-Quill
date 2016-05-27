var gulp = require('gulp');
var scsslint = require('gulp-scss-lint');


gulp.task('lint', ['lint/scss']);

// Gotta add a js linter

gulp.task('lint/scss', function() {
  return gulp.src('app/**/*.scss').pipe(scsslint({
    config: 'tasks/scss_lint.yml',
    bundleExec: true
  })).pipe(scsslint.failReporter());
});
