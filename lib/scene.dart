import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math_lists.dart';

class Myself {

}

class Scene {
  Ray ray;
  VectorList<Vector3> positions;

  makeScene() {
    this.ray = new Ray.originDirection(new Vector3.zero(), new Vector3(1.0, 0.0, 0.0));
  }

  makeTravelPlan() {
    this.positions = new Vector3List(5);
    for (var i=0; i<this.positions.length; i++) {
      this.positions[i] = Vector3(10.0 - i, 0.0, 0.0);
    }
  }

  travel(Ray ray) {

  }

}