
struct ForwardPerpendicularOutset : StrokeTransformation {
  func apply(points: [StrokePoint]) -> [StrokePoint] {
    return points.slidingWindow { focus, before, after in
      guard before != nil || after != nil else { return nil }

      let perpendicular: StrokePoint = {
        if before == nil {
          return (after! - focus).perpendicular()
        } else if after == nil {
          return (focus - before!).perpendicular()
        } else {
          return (after! - before!).perpendicular()
        }
      }()

      return focus + perpendicular * focus.weight / 2.0
    }
  }
}

struct BackwardPerpendicularOutset : StrokeTransformation {
  func apply(points: [StrokePoint]) -> [StrokePoint] {
    return points.slidingWindow { focus, before, after in
      guard before != nil || after != nil else { return nil }

      let perpendicular: StrokePoint = {
        if before == nil {
          return (after! - focus).perpendicular()
        } else if after == nil {
          return (focus - before!).perpendicular()
        } else {
          return (after! - before!).perpendicular()
        }
      }()

      return focus - perpendicular * focus.weight / 2.0
    }
  }
}
