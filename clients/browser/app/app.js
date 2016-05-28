import CanvasRenderer from 'renderers/CanvasRenderer';
import Point from 'point/Point';

var canvas = document.getElementById('main-canvas');
var renderer = new CanvasRenderer(canvas.getContext('2d'));
var center = new Point(100, 100);

renderer.circle(center, 50);
renderer.color('#334455');
renderer.fill();
