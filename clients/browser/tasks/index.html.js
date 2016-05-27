var gulp = require('gulp');
var argv = require('yargs').argv;
var bowerFiles = require('main-bower-files');
var gulpif = require('gulp-if');
var htmlmin = require('gulp-htmlmin');
var inject = require('gulp-inject');
var naturalSort = require('gulp-natural-sort');
var revall = require('gulp-rev-all');
var depsOrder = require('gulp-deps-order');


gulp.task('build/dev/index.html', ['build/dev/js', 'build/dev/bower', 'build/dev/css'], function() {
  var bower, cssfiles, js;
  bower = gulp.src(bowerFiles(), {
    base: "bower_components",
    read: false
  });

  js = gulp.src(['**/*.js', '!bower_components/**/*'], {
    cwd: 'build/dev'
  })
    .pipe(naturalSort())
    .pipe(depsOrder());

  cssfiles = gulp.src(['**/*.css', '!bower_components/**/*.css', '!shared_styles/imports.css'], {
    cwd: 'build/dev',
    read: false,
    nodir: true
  })
    .pipe(naturalSort());

  return gulp.src('app/index.html')
    .pipe(inject(bower, {
      name: 'bower'
    }))
    .pipe(inject(js))
    .pipe(inject(cssfiles))
    .pipe(inject(gulp.src('app/external_scripts/*.html'), {
      starttag: '<!-- inject:external_scripts:{{ext}} -->',
      transform: function(filePath, file) {
        return file.contents.toString('utf8');
      }
    }))
    .pipe(gulp.dest('build/dev'));
});

gulp.task('build/dist/index.html', ['build/dist/app.js', 'build/dist/app.css'], function() {
  var cssfiles, ourjs;
  ourjs = gulp.src('app.*.js', {
    cwd: 'build/dist',
    read: false
  });
  cssfiles = gulp.src('app.*.css', {
    cwd: 'build/dist',
    read: false
  });
  return gulp.src('app/index.html')
    .pipe(inject(ourjs))
    .pipe(inject(cssfiles))
    .pipe(gulpif(argv.config !== "production", inject(gulp.src('app/external_scripts/*.html'), {
      starttag: '<!-- inject:external_scripts:{{ext}} -->',
      transform: function(filePath, file) {
        return file.contents.toString('utf8');
      }
    })))
    .pipe(gulpif(argv.config === "production", inject(gulp.src('app/external_scripts/**/*.html'), {
      starttag: '<!-- inject:external_scripts:{{ext}} -->',
      transform: function(filePath, file) {
        return file.contents.toString('utf8');
      }
    })))
    .pipe(revall({
      ignore: [/^\/index.html/]
    }))
    .pipe(htmlmin({
      removeComments: true,
      collapseWhitespace: true
    }))
    .pipe(gulp.dest('build/dist'));
});
