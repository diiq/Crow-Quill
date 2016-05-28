export default class TestRenderer {
  constructor() {
    this.image = [];
  }

  currentImage() {
    return _.clone(this.image);
  }

  line(a, b) {
    this.image.push(`line: ${a}, ${b}`);
  }

  arc(a, b) {
    this.image.push(`arc: ${a}, ${b}`);
  }

  circle(center, radius) {
    this.image.push(`circle: ${center}, ${radius}`);
  }

  bezier(a, cp1, cp2, b) {
    this.image.push(`bezier: ${a}, [${cp1}, ${cp2}], ${b}`);
  }

  image(image) {
    this.image.append(image);
  }

  moveTo(point) {
    this.image.push(`move: ${point})`);
  }

  stroke(lineWidth) {
    this.image.push(`stroke (${lineWidth})`);
  }

  fill() {
    this.image.push('fill');
  }

  shadowOn() {
    this.image.push('shadow on');
  }

  shadowOff() {
    this.image.push('shadow off');
  }

  clear() {
    this.image = [];
  }

  color(color) {
    this.image.push(`color ${color}`);
  }

  placeImage(start, width, height, name) {

  }
}
