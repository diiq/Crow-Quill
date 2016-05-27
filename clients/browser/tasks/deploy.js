var gulp = require('gulp');
var argv = require('yargs').argv;
var awspublish = require('gulp-awspublish');
var awspublishRouter = require('gulp-awspublish-router');
var parallelize = require('concurrent-transform');
var _ = require('lodash');


gulp.task('deploy', ['build/dist'], function() {
  var publisher = awspublish.create({
    bucket: argv.bucket
  });

  return gulp.src('build/dist/**/*').pipe(awspublishRouter({
    routes: {
      '^index.html$': {
        gzip: true,
        cacheTime: 30
      },
      '\.[0-9a-fA-F]{8}\.(?:js|css|svg|ttf|eot|otf)$': {
        gzip: true,
        cacheTime: 31536000
      },
      '\.[0-9a-fA-F]{8}\.': {
        cacheTime: 31536000
      },
      '\.(?:js|css|svg|ttf|eot|otf)$': {
        gzip: true
      },
      '^.+$': {
        cacheTime: 900
      }
    }
  })).pipe(parallelize(publisher.publish(), 3))
     .pipe(publisher.sync())
     .pipe(awspublish.reporter());
});
