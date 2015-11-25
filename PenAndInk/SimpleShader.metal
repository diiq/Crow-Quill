//
//  SimpleShader.metal
//  PenAndInk
//
//  Created by Sam Bleckley on 11/24/15.
//  Copyright © 2015 Sam Bleckley. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


vertex float4 basic_vertex(const device packed_float3* vertex_array [[ buffer(0) ]],
                           unsigned int vid [[ vertex_id ]]) {
  return float4(vertex_array[vid], 1.0);
}

fragment half4 basic_fragment() {
  return half4(0, 0, 0, 1);
}