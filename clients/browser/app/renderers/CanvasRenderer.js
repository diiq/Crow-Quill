export default class CanvasRenderer {
  constructor(context) {
    this.context = context;
    this.context.lineCap = 'round';
  }

  currentImage() {
    return this.context.getImageData(
      0, 0,
      this.context.width,
      this.context.height);
  }

  line(a, b) {
    this.context.push(`line: ${a}, ${b}`);
  }

  arc(a, b) {
    var delta = b - a;
    var center = a + delta / 2;
    var radius = delta.length() / 2;
    this.context.arc(
      center.x,
      center.y,
      radius,
      a.minus(center).radians(),
      b.minus(center).radians());
  }

  circle(center, radius) {
    this.context.arc(
      center.x,
      center.y,
      radius,
      0,
      2 * Math.PI);
  }

  bezier(a, cp1, cp2, b) {
    this.context.bezierCurveTo(
      cp1.x, cp1.y,
      cp2.x, cp2.y,
      b.x, b.y);
  }

  image(image) {
    this.context.drawImage(image);
  }

  moveTo(point) {
    this.context.moveTo(point.x, point.y);
  }

  stroke(lineWidth) {
    this.context.lineWidth=lineWidth;
    this.context.stroke();
  }

  fill() {
    this.context.fill();
  }

  shadowOn() {
    this.context.shadowColor = '#333333';
    this.context.shadowBlur = 1.5;
  }

  shadowOff() {
    this.context.push('shadow off');
  }

  clear() {
    this.context = [];
  }

  color(color) {
    this.context.fillStyle = color;
    this.context.strokeStyle = color;
  }

  placeImage(start, width, height, name) {

  }
}
